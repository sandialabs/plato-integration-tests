import sys
import os
import exodus
import PlatoPython
import esp_fd_utils as fd

# boilerplate that dynamically loads the mpi library required by PlatoPython.Analyze
import ctypes
ctypes.CDLL("libmpi.so",mode=ctypes.RTLD_GLOBAL)

# specify sensitivity check parameters
sensitivityTol = float(sys.argv[1])
stepSize = float(sys.argv[2])

# specify geometry name and parameter values
model = "cuboid"
Lx = 3.0
Ly = 2.0
Lz = 4.0

# specify performer xml files
analyzePerformerInput = "plato_analyze_input_deck.xml"
analyzePerformerOperations = "plato_analyze_operations.xml"

# use esp to create mesh
espCommand = "plato-cli geometry esp"
espCommand += " --input " + model + ".csm"
espCommand += " --output-model " + model + "_opt.csm"
espCommand += " --output-mesh " + model + ".exo"
espCommand += " --tesselation " + model + ".eto"
espCommand += " --parameters " + str(Lx) + " " +  str(Ly) + " " + str(Lz)
os.system(espCommand)
    
# create plato analyze instance
platoAnalyze = PlatoPython.Analyze(analyzePerformerInput, analyzePerformerOperations, "plato analyze instance")
platoAnalyze.initialize()

# compute Df_DX
platoAnalyze.compute("Compute Objective Gradient")
gradx = platoAnalyze.exportData("GradientX@0", "SCALAR_FIELD")
grady = platoAnalyze.exportData("GradientX@1", "SCALAR_FIELD")
gradz = platoAnalyze.exportData("GradientX@2", "SCALAR_FIELD")

# get number of nodes
meshName = model + ".exo"
mesh = exodus.ExodusDB()
mesh.read(meshName)
numNodes = mesh.numNodes

# finite difference checks
def get_nodal_errors(dim,gradVals):
    errorVals = []
    for nodeID in range(numNodes):
        fd_val = fd.central_difference(platoAnalyze,meshName,dim,nodeID,stepSize)
        relError = 0
        if (abs(fd_val) > 1.0E-8):
            relError = (gradVals[nodeID] - fd_val) / fd_val

        errorVals.append(abs(relError))

    return errorVals

# compute FD approximation for gradients of all nodes
errorsX = get_nodal_errors(0,gradx)
errorsY = get_nodal_errors(1,grady)
errorsZ = get_nodal_errors(2,gradz)

# finalize
platoAnalyze.finalize()

# write out errors for posterity
maxErrorX = max(errorsX)
maxErrorY = max(errorsY)
maxErrorZ = max(errorsZ)
outFile = open("errors.out","w")
outFile.write("Maximum Relative Error X: %3.4E \n" % maxErrorX)
outFile.write("Maximum Relative Error Y: %3.4E \n" % maxErrorY)
outFile.write("Maximum Relative Error Z: %3.4E \n" % maxErrorZ)
outFile.close()

maxError = max((maxErrorX, maxErrorY, maxErrorZ))

if (maxError <= sensitivityTol):
    print("\n Success: Sensitivity values match finite difference")
    sys.exit(0)
else:
    print("\n Failure: Sensitivity values do not match finite difference to desired tolerance")
    sys.exit(1)
