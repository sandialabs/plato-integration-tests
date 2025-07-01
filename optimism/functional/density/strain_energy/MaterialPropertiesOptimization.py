from jax import grad
from jax import jit
from optimism import EquationSolver
from optimism import VTKWriter
from optimism import FunctionSpace
from optimism import Mechanics
from optimism import Mesh
from optimism import Objective
from optimism import QuadratureRule
from optimism import ReadExodusMesh
from optimism import SparseMatrixAssembler
from optimism.FunctionSpace import DofManager
from optimism.FunctionSpace import EssentialBC
from optimism.material import Neohookean_VariableProps

import jax.numpy as np
import numpy as onp
from collections import namedtuple

EnergyFunctions = namedtuple('EnergyFunctions',
                            ['energy_function_props'])

# simulation parameterized on material properties
class MaterialPropertiesOptimization:

    def __init__(self):
        self.scaleObjective = -1.0 # -1.0 to maximize
        self.stateNotStored = True
        self.writeOutput = True

        self.quad_rule = QuadratureRule.create_quadrature_rule_on_triangle(degree=2)

        self.ebcs = [
            EssentialBC(nodeSet='yminus_sideset', component=0),
            EssentialBC(nodeSet='yminus_sideset', component=1),
            EssentialBC(nodeSet='yplus_sideset', component=0),
            EssentialBC(nodeSet='yplus_sideset', component=1)
        ]

        constant_props = {
            'density': 1.0
        }
        self.mat_model = Neohookean_VariableProps.create_material_model_functions(constant_props, 'adagio')

        self.eq_settings = EquationSolver.get_settings(
            max_trust_iters=100,
            tr_size=0.25,
            min_tr_size=1e-15,
            tol=5e-8
        )

        # mesh
        self.input_mesh = './window.exo'
        origMesh = ReadExodusMesh.read_exodus_mesh(self.input_mesh)
        nodeSets = Mesh.create_nodesets_from_sidesets(origMesh)
        self.mesh = Mesh.mesh_with_nodesets(origMesh, nodeSets)
        self.index = (self.mesh.nodeSets['yplus_sideset'], 1)
        self.func_space = FunctionSpace.construct_function_space(self.mesh, self.quad_rule)
        self.dof_manager = DofManager(self.func_space, 2, self.ebcs)
        self.mech_funcs = Mechanics.create_mechanics_functions(self.func_space, mode2D='plane strain', materialModel=self.mat_model)

        self.plot_file = 'disp_control_response.npz'
        self.steps = 10
        self.maxDisp = -0.125

    def create_field(self, Uu, disp):
        def get_ubcs(disp):
            V = np.zeros(self.mesh.coords.shape)
            V = V.at[self.index].set(disp)
            return self.dof_manager.get_bc_values(V)

        return self.dof_manager.create_field(Uu, get_ubcs(disp))

    def import_parameters(self, materialProperties=[]):
        if not materialProperties:
            raise ValueError('Material properties were not passed to MaterialParameterizedSimulation import_parameters function.')

        if len(self.mesh.blocks) > 1:
            raise ValueError('Global element ID mapping is currently only set up for single block.')
        
        self.elementMap = onp.argsort(self.mesh.block_maps['Block1'])

        materialProperties = np.array(materialProperties)
        matPropConv = materialProperties

        props = matPropConv.at[self.elementMap].get()
        props = props.reshape((props.shape[0], 1))

        self.elementProperties = props

        self.stateNotStored = True
        self.state = []

    def run_simulation(self):
        # methods defined on the fly

        def energy_function_all_dofs(U, p):
            internal_variables = p[1]
            return self.mech_funcs.compute_strain_energy(U, internal_variables, self.elementProperties)

        def energy_function(Uu, p):
            U = self.create_field(Uu, p.bc_data)
            return energy_function_all_dofs(U, p)

        nodal_forces = jit(grad(energy_function_all_dofs, argnums=0))

        def assemble_sparse(Uu, p):
            U = self.create_field(Uu, p.bc_data)
            internal_variables = p.state_data
            element_stiffnesses = self.mech_funcs.compute_element_stiffnesses(U, internal_variables, self.elementProperties)
            return SparseMatrixAssembler.\
                assemble_sparse_stiffness_matrix(element_stiffnesses, self.func_space.mesh.conns, self.dof_manager)
    
        def store_force_displacement(Uu, dispval, force, disp):
            U = self.create_field(Uu, p.bc_data)
            f = nodal_forces(U, p)

            force.append( onp.abs(onp.sum(onp.array(f.at[self.index].get()))) )

            disp.append( onp.abs(dispval) )

            with open(self.plot_file,'wb') as f:
                np.savez(f, force=force, displacement=disp)

        def write_vtk_output(Uu, p, step):
            U = self.create_field(Uu, p.bc_data)
            plotName = 'output-'+str(step).zfill(3)
            writer = VTKWriter.VTKWriter(self.mesh, baseFileName=plotName)

            writer.add_nodal_field(name='displ', nodalData=U, fieldType=VTKWriter.VTKFieldType.VECTORS)

            energyDensities = self.mech_funcs.compute_output_energy_densities_and_stresses(U, p.state_data, self.elementProperties)[0]
            cellEnergyDensities = FunctionSpace.project_quadrature_field_to_element_field(self.func_space, energyDensities)
            writer.add_cell_field(name='strain_energy_density',
                                  cellData=cellEnergyDensities,
                                  fieldType=VTKWriter.VTKFieldType.SCALARS)
            writer.write()
        # problem set up
        Uu = self.dof_manager.get_unknown_values(np.zeros(self.mesh.coords.shape))
        ivs = self.mech_funcs.compute_initial_state()
        p = Objective.Params(bc_data=0., state_data=ivs)
        precond_strategy = Objective.PrecondStrategy(assemble_sparse)
        self.objective = Objective.Objective(energy_function, Uu, p, precond_strategy)

        # loop over load steps
        disp = 0.
        fd_force = []
        fd_disp = []

        store_force_displacement(Uu, disp, fd_force, fd_disp)
        if self.writeOutput:
          write_vtk_output(Uu, p, step=0)
        self.state.append((Uu, p))

        disp_inc = self.maxDisp / self.steps
        for step in range(1, self.steps+1):

            print('--------------------------------------')
            print('LOAD STEP ', step)
            disp += disp_inc
            p = Objective.param_index_update(p, 0, disp)
            Uu, solverSuccess = EquationSolver.nonlinear_equation_solve(self.objective, Uu, p, self.eq_settings)
            if solverSuccess == False:
                raise ValueError('Solver failed to converge.')

            store_force_displacement(Uu, disp, fd_force, fd_disp)
            self.state.append((Uu, p))

            if self.writeOutput:
              write_vtk_output(Uu, p, step + 1)

        self.stateNotStored = False

    def setup_energy_functions(self):
        def energy_function_all_dofs(U, p, props):
            ivs = p.state_data
            return self.mech_funcs.compute_strain_energy(U, ivs, props)

        def energy_function_props(Uu, p, props):
            U = self.create_field(Uu, p.bc_data)
            return energy_function_all_dofs(U, p, props)

        return EnergyFunctions(energy_function_props)

    def compute_strain_energy(self, Uu, p, props, energy_function_props):
        return energy_function_props(Uu, p, props)

    def get_objective(self):
        if self.stateNotStored:
            self.run_simulation()

        parameters = self.elementProperties
        energyFuncs = self.setup_energy_functions()

        endState = self.state[-1]

        val = self.compute_strain_energy(endState[0], endState[1], parameters, jit(energyFuncs.energy_function_props)) 
        return onp.array(self.scaleObjective * val).item()      

    def get_gradient(self):
        if self.stateNotStored:
            self.run_simulation()
        
        parameters = self.elementProperties
        energyFuncs = self.setup_energy_functions()

        endState = self.state[-1]

        gradient = grad(self.compute_strain_energy, argnums=2)(endState[0], endState[1], parameters, jit(energyFuncs.energy_function_props))
        return onp.array(self.scaleObjective * gradient, copy=False).flatten().tolist()



if __name__ == '__main__':
    sim = MaterialPropertiesOptimization()
    densityValue = 0.5 # import dummy parameters
    materialProperties = np.full((sim.mesh.conns.shape[0]), densityValue).tolist()
    sim.import_parameters(materialProperties)
    val = sim.get_objective()
    print(f"\n objective value: {val:e}")
    # grad = sim.get_gradient()
