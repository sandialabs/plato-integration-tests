include(${COMMON_SOURCE_CMAKE_DIR}/mpi_helpers.cmake)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../l_bracket" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml ${BASE_TEST_FILE_PATH}/*.gold )
Plato_direct_copy_test_files("${TEST_FILES}")

set( TWO_LOAD_TEST_FILES "input-2-load.i" )
Plato_add_test_files("${TWO_LOAD_TEST_FILES}")

Plato_analyze_copy_test_data("lbracket.exo")

set( NUM_RANKS 2 )
set( NUM_THREADS 1 )
if(PLATOANALYZE_ENABLE_OPENMP)
    set( NUM_THREADS 8 )
endif()
openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load.i" )
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
total_processors(${NUM_RANKS} ${NUM_THREADS} NUM_PROCESSORS)
set_tests_properties( ${TEST_NAME} PROPERTIES PROCESSORS ${NUM_PROCESSORS} ENVIRONMENT "OMP_NUM_THREADS=${NUM_THREADS}")

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_gradient_check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
