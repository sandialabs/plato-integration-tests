Disable_test_on_any_flag(BUILD_WITH_SANITIZER_FLAGS)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

set(testFiles input.i
              modal.i
              ROL_Optimizer.txt.gold)

Plato_add_test_files("${testFiles}")
Plato_sierra_copy_test_data("shelf.exo")
Plato_sierra_copy_test_data("shelf_wedge.exo")

# Add test to run problem and check ROL constraint jacobian adjoint consistency
set( NUM_RANKS 2 )
set( NUM_THREADS 1 )

openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )

set( PLATO_TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE TRUE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-1 )

Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_tests_properties(${TEST_NAME} PROPERTIES PROCESSORS ${NUM_RANKS})
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_THREADS "1")
