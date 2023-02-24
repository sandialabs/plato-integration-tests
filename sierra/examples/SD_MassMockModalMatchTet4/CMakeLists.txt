Requires_features( ENABLE_PLATO_SERVICES ESP_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_input_deck.i;simple_mock.csm")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

# Set file names for diff
set( OUT_FILE "simple_mock_opt.csm")
set( GOLD_FILE "gold.csm")

# set tolerance for diff test
SET( NUMDIFF_USE_ABSOLUTE TRUE )
set( NUMDIFF_ABSOLUTE_TOLERANCE 1e-10 )


# Add the test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_ABSOLUTE_TOLERANCE} )
Plato_disable_test(${TEST_NAME} "Test needs to be updated for ESP changes")
