Requires_features(PLATOANALYZE_STK_ENABLED)

#grab only the xml, input deck, mpirun, and csm files... no cmakelists
#file(GLOB COMMON_TEST_FILES
#  "${CMAKE_CURRENT_BINARY_DIR}/../common/*.xml"
#  "${CMAKE_CURRENT_BINARY_DIR}/../common/*.i"
#  "${CMAKE_CURRENT_BINARY_DIR}/../common/*.source"
#)

#file(COPY ${COMMON_TEST_FILES} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "amgx.json;bg_orig.exo;interface.xml;mpirun.source;plato_analyze_2_input_deck.xml;plato_analyze_2_operations.xml;plato_main_input_deck.xml;plato_main_operations.xml;rol_inputs.xml;plato_krino_operations.xml;ROL_gradient_check_output.gold.txt")
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
