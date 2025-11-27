
Disable_test_on_any_flag(BUILD_WITH_SANITIZER_FLAGS)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

set(testFiles plato_input.i
              aria.i
              inverseInput.xml
              temperature-data.txt
              gradient_check_regression.txt)

Plato_add_test_files("${testFiles}")
Plato_sierra_copy_test_data("background.exo")
Plato_sierra_copy_test_data("startup.exo")

# Set input file names for custom command
set( NUM_RANKS 2 )
set( NUM_THREADS 1 )

openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )
string(REPLACE " " ";" ADDITIONAL_MPI_FLAG_LIST ${ADDITIONAL_MPI_FLAGS} )
add_test(NAME ${TEST_NAME} COMMAND ${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAG_LIST} ${MPIEXEC_PREFLAGS} plato plato_input.i)
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_RANKS ${NUM_RANKS} NUM_THREADS ${NUM_THREADS})

set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "gradient_check.txt")
set( GOLD_FILE "gradient_check_regression.txt")
set( LAST_ROW 7 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_Gradient_Check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
