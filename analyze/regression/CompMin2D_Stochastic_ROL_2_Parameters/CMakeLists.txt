Requires_features()

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "interface.xml;defines.xml;plato_analyze_2_input_deck.xml;plato_analyze_2_operations.xml;plato_main_input_deck.xml;plato_main_operations.xml")
set( testFiles "${testFiles};rol_inputs.xml;distributions.xml;ROL_output.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("mitchell_tri.exo")

# Set number of processors for PlatoMain comm
set( PLATOMAIN_NP 1 )

# Set number of processors for Performer comms
set( ANALYZE_NP 1 )

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

# Files and tolerances
set( OUT_FILE "ROL_output.txt")
set( GOLD_FILE "ROL_output.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
# Add the test
Plato_add_numdiff_test(${PLATO_NEW_TEST} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "large")
