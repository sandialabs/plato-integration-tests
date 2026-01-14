# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles input.i 
              plato_analyze_compliance.xml
              plato_analyze_volume.xml
              ROL_gradient_check_output.txt.gold
              ROL_constraint_jacobian_adjoint_consistency_check_output.txt.gold
              ROL_constraint_jacobian_check_output.txt.gold
              )
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("rect.exo")
Plato_analyze_copy_test_data("rect_side.exo")
Plato_analyze_copy_test_data("rol_inputs_AL.xml")

# Add test to run problem
add_test(NAME ${TEST_NAME} COMMAND plato "input.i")
set_num_threads_for_test( NUM_THREADS )
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_THREADS ${NUM_THREADS})

# Add test check ROL gradient check output
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.txt.gold")
set( LAST_ROW 7 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_gradient_check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test to check ROL constraint jacobian adjoint consistency
set( JACOBIAN_CONSISTENCY_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_consistency_check" )
set( OUT_FILE "ROL_constraint_jacobian_adjoint_consistency_check_output.txt")
set( GOLD_FILE "ROL_constraint_jacobian_adjoint_consistency_check_output.txt.gold")
set( NUMDIFF_USE_ABSOLUTE TRUE )
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-8 )
Plato_add_numdiff_test(" " ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_ABSOLUTE_TOLERANCE})
set_tests_properties( ${JACOBIAN_CONSISTENCY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test check ROL constraint jacobian check output
set( JACOBIAN_CHECK_TEST_NAME "${TEST_NAME}_constraint_jacobian_check" )
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_constraint_jacobian_check_output.txt")
set( GOLD_FILE "ROL_constraint_jacobian_check_output.txt.gold")
set( LAST_ROW 7 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
add_test(NAME ${JACOBIAN_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${JACOBIAN_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
