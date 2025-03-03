Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../l_bracket" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml ${BASE_TEST_FILE_PATH}/*.gold )
Plato_direct_copy_test_files("${TEST_FILES}")

set( TWO_BLOCK_TEST_FILES "input-2-block.i;plato_analyze_vol_2_block.xml;plato_analyze_to_2_block.xml" )
Plato_add_test_files("${TWO_BLOCK_TEST_FILES}")

Plato_analyze_copy_test_data("lbracket-two-block.exo")

set( TEST_COMMAND "plato input-2-block.i" )
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

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
