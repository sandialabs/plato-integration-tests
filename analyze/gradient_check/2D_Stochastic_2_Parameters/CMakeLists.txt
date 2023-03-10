Requires_features()

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "interface.xml;defines.xml;plato_analyze_2_input_deck.xml;plato_analyze_2_operations.xml;plato_main_input_deck.xml;plato_main_operations.xml")
set( testFiles "${testFiles};rol_inputs.xml;distributions.xml;ROL_gradient_check_output.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("mitchell_tri.exo")

# Set number of processors for PlatoMain comm
set( PLATOMAIN_NP 1 )

# Set number of processors for Performer comms
set( ANALYZE_NP 1 )

# Create list of comm sizes 
set( NUM_PROCS "${PLATOMAIN_NP} ${ANALYZE_NP}" )

# Specify which comm will provide the output for comparison
set( IO_COMM_INDEX 0 )

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Create the test and define the PlatoMain performer
set(APP_FILE plato_main_operations.xml)
set(INPUT_FILE plato_main_input_deck.xml)
Plato_create_test(PLATO_NEW_TEST ${PLATOMAIN_BINARY} ${PLATOMAIN_NP} ${INTERFACE_FILE} ${APP_FILE} ${INPUT_FILE})

# Define/add a performer
set( LOCAL_COMM_ID 1 )
set(APP_FILE plato_analyze_2_operations.xml)
set(INPUT_FILE --input-config=plato_analyze_2_input_deck.xml)
Plato_add_performer(PLATO_NEW_TEST ${ANALYZE_BINARY} ${ANALYZE_NP} ${LOCAL_COMM_ID} ${INTERFACE_FILE} ${APP_FILE} ${INPUT_FILE})

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.txt.gold")
set( LAST_ROW 5 )

SET(CUSTOM_COMMAND "python ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW}")

# Add the test
Plato_add_custom_command_test(${PLATO_NEW_TEST} ${TEST_NAME} ${NUM_PROCS} ${IO_COMM_INDEX} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
