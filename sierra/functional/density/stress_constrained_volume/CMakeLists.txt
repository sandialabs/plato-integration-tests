Disable_test_on_any_flag(BUILD_WITH_SANITIZER_FLAGS)
# Name the test with the directory name
Plato_new_test(TEST_NAME)

set(testFiles plato-input.i
              salinas-input.i
              constraint_jacobian_adjoint_consistency_check.txt.gold
              constraint_jacobian_check.txt.gold)

Plato_add_test_files("${testFiles}")

Plato_sierra_copy_test_data("multiblock_Lbracket.exo")

set( NUM_RANKS 1 )
set( NUM_THREADS 1 )

openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )

set( PLATO_TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato plato-input.i")
set( JACOBIAN_CONSISTENCY_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_consistency_check" )
set( OUT_FILE "constraint_jacobian_adjoint_consistency_check.txt")
set( GOLD_FILE "constraint_jacobian_adjoint_consistency_check.txt.gold")
set( NUMDIFF_USE_ABSOLUTE TRUE )
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-9 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_ABSOLUTE_TOLERANCE})
set_tests_properties(${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} PROPERTIES PROCESSORS ${NUM_RANKS})
set_openmp_test_properties(TEST_NAME ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} NUM_THREADS "${NUM_THREADS}")

set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( LAST_ROW 5 )
set( JACOBIAN_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_check" )
set( OUT_FILE "constraint_jacobian_check.txt")
set( GOLD_FILE "constraint_jacobian_check.txt.gold")
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
add_test(NAME ${JACOBIAN_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${JACOBIAN_CHECK_TEST_NAME} PROPERTIES DEPENDS ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME})
