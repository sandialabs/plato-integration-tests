Requires_features()

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_input_deck.i;xml_comparison_files.txt;serialize_comparison_files.txt;numdiff_comparison_files.txt;")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("design_vol.exo")

file(COPY        ${CMAKE_CURRENT_SOURCE_DIR}/gold
     DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Set input file names for custom command
set( IN_FILE "xml_comparison_files.txt serialize_comparison_files.txt numdiff_comparison_files.txt")
set( NUMDIFF_TOLERANCE 1e-3 ) 

SET(CUSTOM_COMMAND "python ${FULL_REGRESSION_PYTHON_SCRIPT} ${NUMDIFF_TOLERANCE} ${IN_FILE}")

# Add the test
Plato_add_xmlgen_custom_command_test(${TEST_NAME} ${XMLGEN_COMMAND} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY ENVIRONMENT "PLATO_SAVE_TO_XML=1")

set_property(TEST ${TEST_NAME} PROPERTY LABELS "large")
