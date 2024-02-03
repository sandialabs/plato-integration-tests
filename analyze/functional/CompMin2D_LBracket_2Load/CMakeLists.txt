Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../CompMin2D_LBracket" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml ${BASE_TEST_FILE_PATH}/*.gold )
Plato_direct_copy_test_files("${TEST_FILES}")

set( TWO_LOAD_TEST_FILES "input-2-load.i" )
Plato_add_test_files("${TWO_LOAD_TEST_FILES}")

Plato_analyze_copy_test_data("lbracket.exo")

set( NUM_RANKS 2 )
set( ADDITIONAL_MPI_FLAGS "--bind-to none" )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load.i" )
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
