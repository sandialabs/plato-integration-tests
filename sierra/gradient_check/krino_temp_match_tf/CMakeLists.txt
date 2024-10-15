Requires_features(STK_ENABLED)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

set( testFiles "aria1_orig.exo;gold.exo;mpirun.source;plato_main_operations.xml;interface.xml;plato_krino_operations.xml;rol_inputs.xml;aria1_opt.i;inverseInput.xml;plato_main_input_deck.xml;sierra_tf_2_operations.xml;ROL_gradient_check_output.gold.txt")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "echo 'skipping XMLGenerator and using ready made files'")

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.gold.txt")
set( LAST_ROW 7 )


SET(CUSTOM_COMMAND "python ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW}")


# Add the test
Plato_add_xmlgen_custom_command_test(${TEST_NAME} ${XMLGEN_COMMAND} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
