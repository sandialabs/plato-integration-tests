# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles input.i
              plato_analyze_compliance.xml
              ROL_gradient_check.txt.gold
              ROL_constraint_jacobian_adjoint_consistency_check.txt.gold
              ROL_constraint_jacobian_check.txt.gold
              ROL_constraint_linearity_check.txt.gold)
              
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("square_mesh_refined_bg.exo")

# Add run problem
set( PLATO_RUN_COMMAND "plato")
set( PLATO_INPUT "input.i")
add_test(${TEST_NAME} ${PLATO_RUN_COMMAND} ${PLATO_INPUT})

set_num_threads_for_test( NUM_THREADS )
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_THREADS ${NUM_THREADS})

# Add test check ROL gradient check output
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check.txt")
set( GOLD_FILE "ROL_gradient_check.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_gradient_check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test to run problem and check ROL constraint jacobian adjoint consistency
set( JACOBIAN_CONSISTENCY_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_consistency_check" )
set( OUT_FILE "ROL_constraint_jacobian_adjoint_consistency_check.txt")
set( GOLD_FILE "ROL_constraint_jacobian_adjoint_consistency_check.txt.gold")
set( NUMDIFF_USE_ABSOLUTE TRUE )
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-8 )
Plato_add_numdiff_test(" " ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_ABSOLUTE_TOLERANCE})
set_tests_properties( ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test check ROL constraint jacobian check output
set( JACOBIAN_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_check" )
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_constraint_jacobian_check.txt")
set( GOLD_FILE "ROL_constraint_jacobian_check.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
add_test(NAME ${JACOBIAN_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${JACOBIAN_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test check ROL constraint linearity check output is empty
set( LINEARITY_CHECK_TEST_NAME "${TEST_NAME}_constraint_linearity_check" )
set( OUT_FILE "ROL_constraint_linearity_check.txt")
set( GOLD_FILE "ROL_constraint_linearity_check.txt.gold")
set( DIFF_ARGS ${OUT_FILE} ${GOLD_FILE})
add_test(NAME ${LINEARITY_CHECK_TEST_NAME} COMMAND diff ${DIFF_ARGS})
set_tests_properties( ${LINEARITY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
