import sys
import os
import exodus
import PlatoPython
import finite_difference_utils as fd

# boilerplate that dynamically loads the mpi library required by PlatoPython.Analyze
import ctypes
ctypes.CDLL("libmpi.so",mode=ctypes.RTLD_GLOBAL)

# specify sensitivity check parameters
model = "two_block_tensile_hole"

nodeSets = {"cylinder"}

iniStepSize = float(sys.argv[1])
numSteps    = int(sys.argv[2])

# specify performer xml files
analyzePerformerInput = "plato_analyze_input_deck.xml"
analyzePerformerOperations = "plato_analyze_operations.xml"

# create plato analyze instance
platoAnalyze = PlatoPython.Analyze(analyzePerformerInput, analyzePerformerOperations, "plato analyze instance")
platoAnalyze.initialize()

# compute objective value
platoAnalyze.compute("Reinitialize")
platoAnalyze.compute("Compute Objective Value")
fval = platoAnalyze.exportData("Objective Value", "SCALAR")

# compute Df_DX
platoAnalyze.compute("Compute Objective Gradient")
gradx = platoAnalyze.exportData("GradientX@0", "SCALAR_FIELD")
grady = platoAnalyze.exportData("GradientX@1", "SCALAR_FIELD")
gradz = platoAnalyze.exportData("GradientX@2", "SCALAR_FIELD")

# save original mesh
meshName = model + ".exo"
originalMeshName = fd.save_original_mesh(meshName)

# function: get node set nodes
def getNodeSetNodes(nodesets):
    tNodes = []
    tFound = False
    for nodeset in nodesets:

        for tNodeSet in mesh.NodeSets:
            if tNodeSet.name == nodeset:
                for node in tNodeSet.nodes:
                    tNodes.append(node)
                tFound = True

        if tFound == False:
            raise Exception("Node set '" + nodeset + "' not found")

        if len(tNodes) == 0:
            raise Exception("Found empty node set")

    return tNodes

# function: inner product
def inner_product(vec1,vec2):
    if len(vec1) != len(vec2):
        raise Exception("Vectors for inner product have different lengths!")
    
    result = 0
    for ord in range(0,len(vec1)):
        result += vec1[ord] * vec2[ord]

    return result

# function: get nodal errors with finite difference comparison
def get_nodal_errors(outFile):

    vector = fd.build_direction_vector(mesh.numNodes, nodeSetNodes)
    fd_val = fd.forward_difference(platoAnalyze, fval, originalMeshName, meshName, stepSize, vector)

    inner_prod = 0
    inner_prod += inner_product(vector[0::3], gradx)
    inner_prod += inner_product(vector[1::3], grady)
    inner_prod += inner_product(vector[2::3], gradz)

    error = abs(inner_prod - fd_val)

    # write to file
    outFile.write("%3.6E \t" % inner_prod)
    outFile.write("%3.6E \t" % fd_val)
    outFile.write("%3.6E \n" % error)

# loop through different FD step sizes
stepSize = iniStepSize

outFile = open("gradient_check.out","w")
outFile.write("Step Size \t grad'*dir \t FD Approx \t abs(Error) \n")
outFile.write("--------- \t --------- \t --------- \t ---------- \n")

# get node set nodes
mesh = exodus.ExodusDB()
mesh.read(originalMeshName)
nodeSetNodes = getNodeSetNodes(nodeSets)

for step in range(0,numSteps):

    # compute FD approximation for gradients of all nodes
    outFile.write("%3.4E \t" % stepSize)

    get_nodal_errors(outFile)

    # copy back original mesh
    copyStr = "cp " + originalMeshName + " " + meshName
    os.system(copyStr)

    stepSize *= 1.0e-1

# finalize
outFile.close()
platoAnalyze.finalize()

