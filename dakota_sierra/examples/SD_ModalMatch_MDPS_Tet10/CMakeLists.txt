Requires_features( ESP_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_input_deck.i;gold_brick-out.exo;whole_brick.csm;auxiliary_mesh.exo;solution.txt.gold")
Plato_add_test_files("${testFiles}")

# Set xml generator command
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

# Set file names for diff
set( OUT_FILE "dakota_multi_dimensional_parameter_study.dat")
set( GOLD_FILE "solution.txt.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-3 )

# Add the test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
