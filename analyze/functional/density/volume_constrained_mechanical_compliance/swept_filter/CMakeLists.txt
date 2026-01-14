# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles input.i
              plato_analyze_compliance.xml
              plato_analyze_volume.xml
              ROL_Optimizer.txt.gold
              ROL_gradient_check_output.txt.gold
              ROL_constraint_linearity_check_output.txt.gold)

Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("rect.exo")
Plato_analyze_copy_test_data("rect_side.exo")

# Add test to run problem and check ROL optimization output
set( PLATO_TEST_COMMAND "plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_num_threads_for_test( NUM_THREADS )
set_openmp_test_properties(TEST_NAME ${TEST_NAME} NUM_THREADS ${NUM_THREADS})

# Add test check ROL gradient check output
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.txt.gold")
set( LAST_ROW 5 )
set( PYTHON_ARGS ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW})
set( GRADIENT_CHECK_TEST_NAME "${TEST_NAME}_gradient_check" )
add_test(NAME ${GRADIENT_CHECK_TEST_NAME} COMMAND python ${PYTHON_ARGS})
set_tests_properties( ${GRADIENT_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})

# Add test check ROL constraint linearity check output
set( LINEARITY_CHECK_TEST_NAME "${TEST_NAME}_constraint_linearity_check" )
set( OUT_FILE "ROL_constraint_linearity_check_output.txt")
set( GOLD_FILE "ROL_constraint_linearity_check_output.txt.gold")
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-12 )
set( DIFF_ARGS ${OUT_FILE} ${GOLD_FILE} -a ${NUMDIFF_ABSOLUTE_TOLERANCE})
add_test(NAME ${LINEARITY_CHECK_TEST_NAME} COMMAND numdiff ${DIFF_ARGS})
set_tests_properties( ${LINEARITY_CHECK_TEST_NAME} PROPERTIES DEPENDS ${TEST_NAME})
