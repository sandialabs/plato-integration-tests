Requires_features( STK_ENABLED )
Disable_test_on_any_flag(BUILD_WITH_SANITIZER_FLAGS)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

set(testFiles plato_input.i
              sd_modal.i
              ROL_gradient_check.txt.gold)

Plato_add_test_files("${testFiles}")

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check.txt")
set( GOLD_FILE "ROL_gradient_check.txt.gold")
set( LAST_ROW 7 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_Gradient_Check" )
add_test(NAME ${TEST_NAME} COMMAND plato plato_input.i)
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
