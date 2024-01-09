Requires_features(ESP_ENABLED)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "brick_opt.gold.csm;targets.xml;salinas_input.i;rol_inputs.xml;plato_main_operations.xml;plato_main_input_deck.xml;plato_esp_operations.xml;plato_esp_input_deck.xml;mpirun.source;defines.xml;brick.csm;interface.xml;weights.xml;")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "echo 'skipping XMLGenerator and using ready made files'")

# Set file names for diff
set( OUT_FILE "brick_opt.csm")
set( GOLD_FILE "brick_opt.gold.csm")

# set tolerance for diff test
SET( NUMDIFF_USE_ABSOLUTE FALSE )
set( NUMDIFF_TOLERANCE 1e-2 )

# Add the test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_TOLERANCE} )
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
