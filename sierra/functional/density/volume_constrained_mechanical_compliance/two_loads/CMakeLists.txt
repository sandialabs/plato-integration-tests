Disable_test_on_any_flag(BUILD_WITH_SANITIZER_FLAGS)

include(${COMMON_SOURCE_CMAKE_DIR}/mpi_helpers.cmake)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../one_load" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml ${BASE_TEST_FILE_PATH}/*.gold )
Plato_direct_copy_test_files("${TEST_FILES};${BASE_TEST_FILE_PATH}/salinas_input.i")

set( TWO_LOAD_TEST_FILES "input-2-load.i" "input-2-load-serial.i" )
Plato_add_test_files("${TWO_LOAD_TEST_FILES}")

Plato_sierra_copy_test_data("multiblock_Lbracket.exo")

set( NUM_RANKS 4 )
set( NUM_THREADS 1 )
openmpi_process_map_argument(${NUM_RANKS} ${NUM_THREADS} ADDITIONAL_MPI_FLAGS )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load.i" )
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "large")
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_RANKS ${NUM_RANKS} NUM_THREADS ${NUM_THREADS})

# Run with 1 rank so that the objectives are run on the same process.
# This was causing a crash in SD due to caching.
set( NUM_RANKS 1 )
set( TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} ${ADDITIONAL_MPI_FLAGS} ${MPIEXEC_PREFLAGS} plato input-2-load-serial.i" )
Plato_add_numdiff_test(${TEST_COMMAND} "${TEST_NAME}_Serial" ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_tests_properties( "${TEST_NAME}_Serial" PROPERTIES DEPENDS ${TEST_NAME})

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check.txt")
set( GOLD_FILE "ROL_gradient_check.txt.gold")
set( LAST_ROW 7 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_Gradient_Check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
