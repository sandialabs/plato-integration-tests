Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

set( BASE_TEST_FILE_PATH "../l_bracket" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml ${BASE_TEST_FILE_PATH}/ROL_constraint_linearity_check_output.txt.gold )
Plato_direct_copy_test_files("${TEST_FILES}")

# Copy Input files from source to binary dir
set(testFiles "input.i;ROL_Optimizer.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket.exo")

# Add test to run problem and check ROL optimization output
set( PLATO_TEST_COMMAND "plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

# Add test check ROL constraint linearity check output
set( LINEARITY_CHECK_TEST_NAME "${TEST_NAME}_constraint_linearity_check" )
set( OUT_FILE "ROL_constraint_linearity_check_output.txt")
set( GOLD_FILE "ROL_constraint_linearity_check_output.txt.gold")
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-14 )
set( DIFF_ARGS ${OUT_FILE} ${GOLD_FILE} -a ${NUMDIFF_ABSOLUTE_TOLERANCE})
add_test(NAME ${LINEARITY_CHECK_TEST_NAME} COMMAND numdiff ${DIFF_ARGS})
set_tests_properties( ${LINEARITY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
