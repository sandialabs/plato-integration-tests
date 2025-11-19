# Generates the map-by command line argument used by mpiexec to give the process mapping for mixed MPI and OpenMP environments
#  NUM_RANKS: The number of MPI ranks used in the test.
#  NUM_THREADS: The number of openmp threads used in the test.
#  OUT_MAP_ARGUMENT: The cmake variable that, on return, will contain the command line argument string.
function(openmpi_process_map_argument NUM_RANKS NUM_THREADS OUT_MAP_ARGUMENT)

set(${OUT_MAP_ARGUMENT} "--map-by ppr:${NUM_RANKS}:socket:PE=${NUM_THREADS}" PARENT_SCOPE)

endfunction(openmpi_process_map_argument)

# Computes the total number of processors used by a test
#  NUM_RANKS: The number of MPI ranks used in the test.
#  NUM_THREADS: The number of openmp threads used in the test.
#  OUT_NUM_PROCESSORS: The cmake variable that, on return, will contain the total number of processors
function(total_processors NUM_RANKS NUM_THREADS OUT_NUM_PROCESSORS)

math(EXPR NUM_PROCESSORS "${NUM_RANKS} * ${NUM_THREADS}")
set( ${OUT_NUM_PROCESSORS} "${NUM_PROCESSORS}" PARENT_SCOPE)

endfunction(total_processors)
