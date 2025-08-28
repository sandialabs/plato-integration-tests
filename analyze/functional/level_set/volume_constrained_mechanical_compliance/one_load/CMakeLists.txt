

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles input.i 
              plato_analyze_compliance.xml
              plato_analyze_volume.xml
              rol_inputs_AL.xml)
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket3d.exo")

# Add test to run problem and check ROL optimization output
set( PLATO_TEST_COMMAND "plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-2 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
Plato_disable_test(${TEST_NAME} "GC is very strange and convergence is very difficult to achieve")

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
Plato_disable_test(${GRADIENT_CHECK_TEST_NAME} "GC is very strange and convergence is very difficult to achieve")
