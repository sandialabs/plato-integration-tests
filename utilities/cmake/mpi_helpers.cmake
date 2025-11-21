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

# Sets the OpenMP environment variables for a test
function(set_openmp_test_properties)

set(OPTIONS "")
set(ONE_VALUE_ARGS TEST_NAME NUM_RANKS NUM_THREADS)
set(MULTI_VALUE_ARGS "")
cmake_parse_arguments(PARSE_ARGV 0 ARG "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}")

if(NOT ARG_NUM_RANKS)
    set(ARG_NUM_RANKS 1)
endif()
if(NOT ARG_NUM_THREADS)
    set(ARG_NUM_THREADS 1)
endif()

total_processors(${ARG_NUM_RANKS} ${ARG_NUM_THREADS} NUM_PROCESSORS)
set_tests_properties( ${ARG_TEST_NAME} PROPERTIES PROCESSORS ${NUM_PROCESSORS} ENVIRONMENT "OMP_NUM_THREADS=${ARG_NUM_THREADS};OMP_PROC_BIND=close;OMP_PLACES=threads")

endfunction(set_openmp_test_properties)
