Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles "input.i;plato_analyze_to.xml;plato_analyze_vol.xml;rol_inputs.xml;ROL_Optimizer.txt.gold;ROL_gradient_check_output.txt.gold;ROL_constraint_linearity_check_output.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket.exo")

set( PLATO_TEST_COMMAND "plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_Gradient_Check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

set( CONSTRAINT_CHECK_TEST_NAME "${TEST_NAME}_Constraint_Linearity_Check" )
set( PLATO_TEST_COMMAND "pwd")
set( OUT_FILE "ROL_constraint_linearity_check_output.txt")
set( GOLD_FILE "ROL_constraint_linearity_check_output.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${CONSTRAINT_CHECK_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})