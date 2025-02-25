Requires_features( STK_ENABLED LEGACY_BUILD )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "amgx.json;interface.xml;plato_analyze_4_input_deck.xml;plato_krino_operations.xml;plato_main_operations.xml;sierra_sd_2_input_deck.i;bg_orig.exo;mpirun.source;plato_analyze_4_operations.xml;plato_main_input_deck.xml;rol_inputs.xml;sierra_sd_2_operations.xml;ROL_output.txt.gold")
Plato_add_test_files("${testFiles}")

# Set file names for diff
set( OUT_FILE "ROL_output.txt")
set( GOLD_FILE "ROL_output.txt.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

set( TEST_COMMAND "source mpirun.source")

# Add the test
Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
