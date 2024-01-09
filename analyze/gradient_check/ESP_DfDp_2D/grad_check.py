import sys
import os
import exodus
import PlatoServices
import PlatoPython
import PythonPlatoESP

# boilerplate that dynamically loads the mpi library required by PlatoPython.Analyze
import ctypes
ctypes.CDLL("libmpi.so",mode=ctypes.RTLD_GLOBAL)

# specify sensitivity tolerance
sensitivityTol = float(sys.argv[1])

# specify geometry name and parameter values
model = "parallelogram"
Lx = 3.0
Ly = 2.0

# specify performer xml files
enginePerformerInput = "plato_main_input_deck.xml"
enginePerformerOperations = "plato_main_operations.xml"
analyzePerformerInput = "plato_analyze_input_deck.xml"
analyzePerformerOperations = "plato_analyze_operations.xml"
espPerformerInput = "plato_esp_input_deck.xml"
espPerformerOperations = "plato_esp_operations.xml"

# use esp to create mesh
espCommand = "plato-cli geometry esp"
espCommand += " --input " + model + ".csm"
espCommand += " --output-model " + model + "_opt.csm"
espCommand += " --output-mesh " + model + ".exo"
espCommand += " --tesselation " + model + ".eto"
espCommand += " --workflow aflr2"
espCommand += " --parameters " + str(Lx) + " " +  str(Ly)
os.system(espCommand)

# read in mesh
mesh = exodus.ExodusDB()
mesh.read(model + ".exo")

# get mesh data
numDims = len(mesh.coordinates)
numNodes = len(mesh.coordinates[0])

# create plato engine instance
platoEngine = PlatoServices.Services(enginePerformerInput, enginePerformerOperations, "plato engine instance")
platoEngine.initialize()

# create plato analyze instance
platoAnalyze = PlatoPython.Analyze(analyzePerformerInput, analyzePerformerOperations, "plato analyze instance")
platoAnalyze.initialize()

# create plato esp instances
platoESP0 = PythonPlatoESP.PlatoESP(espPerformerInput, espPerformerOperations, "plato esp instance")
platoESP0.initialize()
platoESP0.importData("Parameter Index", "SCALAR PARAMETER", [0.0])

platoESP1 = PythonPlatoESP.PlatoESP(espPerformerInput, espPerformerOperations, "plato esp instance")
platoESP1.initialize()
platoESP1.importData("Parameter Index", "SCALAR PARAMETER", [1.0])

# import parameter data
params = [Lx, Ly]
platoAnalyze.importData("Parameters", "SCALAR", params)

# compute objective value
platoAnalyze.compute("Compute Objective Value")
val = platoAnalyze.exportData("Objective Value", "SCALAR")

# compute Df_DX
platoAnalyze.compute("Compute Objective Gradient")
DfDX = platoAnalyze.exportData("GradientX", "SCALAR", numDims*numNodes)

# compute DX_Dp
platoESP0.compute("Compute Parameter Sensitivity On Change")
DXDp0 = platoESP0.exportData("Parameter Sensitivity", "SCALAR")

platoESP1.compute("Compute Parameter Sensitivity On Change")
DXDp1 = platoESP1.exportData("Parameter Sensitivity", "SCALAR")

# compute Df_Dp
platoEngine.importData("Parameter Sensitivity 0", "SCALAR", DXDp0)
platoEngine.importData("Parameter Sensitivity 1", "SCALAR", DXDp1)
platoEngine.importData("DFDX", "SCALAR", DfDX)
platoEngine.compute("Chain Rule")
grad = platoEngine.exportData("Full Gradient", "SCALAR")

# finalize
platoAnalyze.finalize()
platoESP0.finalize()
platoESP1.finalize()

# check gradient values
relError0 = abs(grad[0] - Ly) / (Ly)
relError1 = abs(grad[1] - Lx) / (Lx)
outFile = open("errors.out","w")
outFile.write("Relative Error Param 0 (Lx): %3.4E \n" % relError0)
outFile.write("Relative Error Param 1 (Ly): %3.4E \n" % relError1)
outFile.close()

gradients_match = 1
if (abs(relError0) > sensitivityTol or abs(relError1) > sensitivityTol):
    gradients_match = 0

if(gradients_match):
    print("\n Success: Sensitivity values match gold")
    sys.exit(0)
else:
    print("\n Failure: Sensitivity values do not match gold")
    sys.exit(1)
