Requires_features( ESP_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_input_deck.i;gold_brick-out.exo;part_brick.csm;auxiliary_mesh.exo;solution.csm.gold")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

# Set file names for diff
set( OUT_FILE "part_brick_opt.csm")
set( GOLD_FILE "solution.csm.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-2 )

# Add the test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
