from jax import grad
from jax import jit
from optimism import EquationSolver
from optimism import VTKWriter
from optimism import FunctionSpace
from optimism.inverse import AdjointFunctionSpace
from optimism import Interpolants
from optimism import Mechanics
from optimism import Mesh
from optimism import Objective
from optimism import QuadratureRule
from optimism import ReadExodusMesh
from optimism import SparseMatrixAssembler
from optimism.FunctionSpace import DofManager
from optimism.FunctionSpace import EssentialBC
from optimism.material import Neohookean
from collections import namedtuple

EnergyFunctions = namedtuple('EnergyFunctions',
                            ['energy_function_coords'])

import jax.numpy as np
import numpy as onp

class NodalCoordinateOptimization:

    def __init__(self):
        self.scaleObjective = -1.0 # -1.0 to maximize
        self.writeOutput = True

        self.stateNotStored = True

        self.quad_rule = QuadratureRule.create_quadrature_rule_on_triangle(degree=2)

        self.ebcs = [
            EssentialBC(nodeSet='yminus_sideset', component=0),
            EssentialBC(nodeSet='yminus_sideset', component=1),
            EssentialBC(nodeSet='yplus_sideset', component=0),
            EssentialBC(nodeSet='yplus_sideset', component=1)
        ]

        props = {
            'elastic modulus': 3. * 10.0 * (1. - 2. * 0.3),
            'poisson ratio': 0.3,
            'version': 'coupled'
        }
        self.mat_model = Neohookean.create_material_model_functions(props)

        self.eq_settings = EquationSolver.get_settings(
            use_incremental_objective=False,
            max_trust_iters=100,
            tr_size=0.25,
            min_tr_size=1e-15,
            tol=5e-8
        )

        self.input_mesh = './krino_cut_mesh.exo'
        self.plot_file = 'disp_control_response.npz'
        self.steps = 20
        self.maxDisp = 0.25 

    def create_field(self, Uu, disp):
        def get_ubcs(disp):
            V = np.zeros(self.mesh.coords.shape)
            V = V.at[self.index].set(disp)
            return self.dof_manager.get_bc_values(V)

        return self.dof_manager.create_field(Uu, get_ubcs(disp))

    def reload_mesh(self):
        origMesh = ReadExodusMesh.read_exodus_mesh(self.input_mesh)
        nodeSets = Mesh.create_nodesets_from_sidesets(origMesh)
        self.mesh = Mesh.mesh_with_nodesets(origMesh, nodeSets)

        self.index = (self.mesh.nodeSets['yplus_sideset'], 1)

        func_space = FunctionSpace.construct_function_space(self.mesh, self.quad_rule)
        self.dof_manager = DofManager(func_space, 2, self.ebcs)

        self.stateNotStored = True
        self.state = []

    def run_simulation(self):
        # setup
        func_space = FunctionSpace.construct_function_space(self.mesh, self.quad_rule)
        mech_funcs = Mechanics.create_mechanics_functions(func_space, mode2D='plane strain', materialModel=self.mat_model)

        def energy_function_all_dofs(U, p):
            internal_variables = p[1]
            return mech_funcs.compute_strain_energy(U, internal_variables)

        def energy_function(Uu, p):
            U = self.create_field(Uu, p.bc_data)
            return energy_function_all_dofs(U, p)

        nodal_forces = jit(grad(energy_function_all_dofs, argnums=0))

        def assemble_sparse(Uu, p):
            U = self.create_field(Uu, p.bc_data)
            internal_variables = p[1]
            element_stiffnesses = mech_funcs.compute_element_stiffnesses(U, internal_variables)
            return SparseMatrixAssembler.\
                assemble_sparse_stiffness_matrix(element_stiffnesses, func_space.mesh.conns, self.dof_manager)
    
        def store_force_displacement(Uu, dispval, force, disp):
            U = self.create_field(Uu, p.bc_data)
            f = nodal_forces(U, p)

            force.append( onp.sum(onp.array(f.at[self.index].get())) )
            disp.append( dispval )

            with open(self.plot_file,'wb') as f:
                np.savez(f, force=force, displacement=disp)

        def write_vtk_output(Uu, p, step):
            U = self.create_field(Uu, p.bc_data)
            plotName = 'output-'+str(step).zfill(3)
            writer = VTKWriter.VTKWriter(self.mesh, baseFileName=plotName)

            writer.add_nodal_field(name='displ', nodalData=U, fieldType=VTKWriter.VTKFieldType.VECTORS)

            energyDensities = mech_funcs.compute_output_energy_densities_and_stresses(U, p.state_data)[0]
            cellEnergyDensities = FunctionSpace.project_quadrature_field_to_element_field(func_space, energyDensities)
            writer.add_cell_field(name='strain_energy_density',
                                  cellData=cellEnergyDensities,
                                  fieldType=VTKWriter.VTKFieldType.SCALARS)
            writer.write()

        # problem set up
        Uu = self.dof_manager.get_unknown_values(np.zeros(self.mesh.coords.shape))
        ivs = mech_funcs.compute_initial_state()
        p = Objective.Params(0., ivs)
        precond_strategy = Objective.PrecondStrategy(assemble_sparse)
        objective = Objective.Objective(energy_function, Uu, p, precond_strategy)

        # loop over load steps
        disp = 0.
        fd_force = []
        fd_disp = []

        store_force_displacement(Uu, disp, fd_force, fd_disp)
        if self.writeOutput:
          write_vtk_output(Uu, p, step=0)

        for step in range(1, self.steps+1):

            print('--------------------------------------')
            print('LOAD STEP ', step)
            disp = disp - self.maxDisp / self.steps
            p = Objective.param_index_update(p, 0, disp)
            Uu, solverSuccess = EquationSolver.nonlinear_equation_solve(objective, Uu, p, self.eq_settings)
            if solverSuccess == False:
                raise ValueError('Solver failed to converge.')

            store_force_displacement(Uu, disp, fd_force, fd_disp)
            if self.writeOutput:
              write_vtk_output(Uu, p, step + 1)

        self.state = (Uu, p)
        self.stateNotStored = False

    def setup_energy_functions(self):
        shapeOnRef = Interpolants.compute_shapes(self.mesh.parentElement, self.quad_rule.xigauss)

        def energy_function_all_dofs(U, p, coords):
            adjoint_func_space = AdjointFunctionSpace.construct_function_space_for_adjoint(coords, shapeOnRef, self.mesh, self.quad_rule)
            mech_funcs = Mechanics.create_mechanics_functions(adjoint_func_space, mode2D='plane strain', materialModel=self.mat_model)
            ivs = p.state_data
            return mech_funcs.compute_strain_energy(U, ivs)

        def energy_function_coords(Uu, p, coords):
            U = self.create_field(Uu, p.bc_data)
            return energy_function_all_dofs(U, p, coords)

        return EnergyFunctions(energy_function_coords)

    def objective_function(self, coordinates, energy_function_coords):
        return energy_function_coords(self.state[0], self.state[1], coordinates)
    
    def get_objective(self):
        if self.stateNotStored:
            self.run_simulation()

        parameters = self.mesh.coords
        energyFuncs = self.setup_energy_functions()

        val = self.objective_function(parameters, jit(energyFuncs.energy_function_coords)) 
        return onp.array(self.scaleObjective * val).item()      

    def get_gradient(self):
        if self.stateNotStored:
            self.run_simulation()
        
        parameters = self.mesh.coords
        energyFuncs = self.setup_energy_functions()

        gradient = grad(self.objective_function, argnums=0)(parameters, jit(energyFuncs.energy_function_coords))
        return onp.array(self.scaleObjective * gradient, copy=False).flatten().tolist()

if __name__ == '__main__':
    nco = NodalCoordinateOptimization()
    nco.reload_mesh()
    val = nco.get_objective()
    print("\n objective value")
    print(val)
    grad = nco.get_gradient()
