Requires_features(PLATOANALYZE_ENABLE_PYTHON )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "block_hole.i;block_hole.csm;ROL_constraint_check_output.gold.txt")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("rect.exo")

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator block_hole.i")

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 5e-1 )
set( OUT_FILE "ROL_constraint_check_output.txt")
set( GOLD_FILE "ROL_constraint_check_output.gold.txt")
set( LAST_ROW 8 )

SET(CUSTOM_COMMAND "python ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/${GOLD_FILE} ${LAST_ROW}")

# Add the test
Plato_add_xmlgen_custom_command_test(${TEST_NAME} ${XMLGEN_COMMAND} ${CUSTOM_COMMAND})

