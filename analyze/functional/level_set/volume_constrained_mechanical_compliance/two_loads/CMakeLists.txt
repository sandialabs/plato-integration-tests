

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../one_load" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml )
Plato_direct_copy_test_files("${TEST_FILES}")

set(testFiles input-1-load.i input-2-load.i)
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket3d.exo")

# Add test to run the one load case for comparison
set(TEST_FOR_COMPARISON "${TEST_NAME}_expected")
add_test(NAME ${TEST_FOR_COMPARISON} COMMAND plato input-1-load.i)

# This is a parallel consistency check. The two load case uses two identical loads with half the aggregation values of the one load case.
# The gradient check should match when run in parallel.
set( NUM_RANKS 2 )
set( ADDITIONAL_MPI_FLAGS "--bind-to none" )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load.i" )

set( OUT_FILE "ROL_gradient_check_output_2_load.txt")
set( GOLD_FILE "ROL_gradient_check_output_1_load.txt")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-5 )
Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_tests_properties( ${TEST_NAME} PROPERTIES DEPENDS ${TEST_FOR_COMPARISON} PROCESSORS ${NUM_RANKS})
