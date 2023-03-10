Requires_features(PLATOANALYZE_ENABLE_PYTHON )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_input_deck.i;mesh.exo;ROL_gradient_check_output.gold.txt")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.gold.txt")
set( LAST_ROW 5 )

SET(CUSTOM_COMMAND "python ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW}")

# Add the test
Plato_add_xmlgen_custom_command_test(${TEST_NAME} ${XMLGEN_COMMAND} ${CUSTOM_COMMAND})
Plato_disable_test(${TEST_NAME} "Reason unclear, possibly issues with ESP 1.21")

