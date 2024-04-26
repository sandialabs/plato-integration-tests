Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles "input.i;plato_analyze_to.xml;plato_analyze_p_norm.xml;rol_inputs.xml;ROL_constraint_linearity_check_output.txt.gold;ROL_constraint_jacobian_check_output.txt.gold;ROL_constraint_jacobian_adjoint_consistency_check_output.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket.exo")

# Add test to run problem and check ROL constraint jacobian adjoint consistency
set( PLATO_TEST_COMMAND "plato input.i")
set( JACOBIAN_CONSISTENCY_CHECK_TEST_NAME "${TEST_NAME}_Constraint_Jacobian_Consistency_Check" )
set( OUT_FILE "ROL_constraint_jacobian_adjoint_consistency_check_output.txt")
set( GOLD_FILE "ROL_constraint_jacobian_adjoint_consistency_check_output.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-6 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

# Add test check ROL constraint jacobian check output
set( JACOBIAN_CHECK_TEST_NAME "${TEST_NAME}_Constraint_Jacobian_Check" )
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_constraint_jacobian_check_output.txt")
set( GOLD_FILE "ROL_constraint_jacobian_check_output.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
add_test(NAME ${JACOBIAN_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${JACOBIAN_CHECK_TEST_NAME} PROPERTIES DEPENDS ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME})

# Add test check ROL constraint linearity check output is empty
set( LINEARITY_CHECK_TEST_NAME "${TEST_NAME}_Constraint_Linearity_Check" )
set( OUT_FILE "ROL_constraint_linearity_check_output.txt")
set( GOLD_FILE "ROL_constraint_linearity_check_output.txt.gold")
set( DIFF_ARGS ${OUT_FILE} ${GOLD_FILE})
add_test(NAME ${LINEARITY_CHECK_TEST_NAME} COMMAND diff ${DIFF_ARGS})
set_tests_properties( ${LINEARITY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME})