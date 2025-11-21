include(${COMMON_SOURCE_CMAKE_DIR}/mpi_helpers.cmake)
include(${ANALYZE_SOURCE_UTILITIES_DIR}/openmp_helpers.cmake)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../one_load" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml )
Plato_direct_copy_test_files("${TEST_FILES}")

set(testFiles input-1-load.i input-2-load.i)
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket3d.exo")

set_num_threads_for_test( NUM_THREADS )

# Add test to run the one load case for comparison
set(TEST_FOR_COMPARISON "${TEST_NAME}_expected")
add_test(NAME ${TEST_FOR_COMPARISON} COMMAND plato input-1-load.i)
set_openmp_test_properties(TEST_NAME ${TEST_FOR_COMPARISON} NUM_THREADS ${NUM_THREADS})

# This is a parallel consistency check. The two load case uses two identical loads with half the aggregation values of the one load case.
# The gradient check should match when run in parallel.
set( NUM_RANKS 2 )

openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load.i" )

set( OUT_FILE "ROL_gradient_check_output_2_load.txt")
set( GOLD_FILE "ROL_gradient_check_output_1_load.txt")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 5e-5 )
Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_RANKS ${NUM_RANKS} NUM_THREADS ${NUM_THREADS})
