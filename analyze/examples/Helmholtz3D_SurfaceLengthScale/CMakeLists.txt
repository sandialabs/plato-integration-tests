# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( GOLD_FILE "plato_optimality_criteria_diagnostics.txt.gold")
set( testFiles "plato_input_deck.i;beam.exo;${GOLD_FILE}")
Plato_add_test_files("${testFiles}")

set( OUT_FILE "plato_optimality_criteria_diagnostics.txt")

set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

# Run test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
