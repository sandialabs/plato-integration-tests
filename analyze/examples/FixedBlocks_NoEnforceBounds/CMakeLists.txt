Requires_features( PLATOANALYZE_ROL_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "FixedBlocks.i" "ROL_output.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("FixedBlocks.exo")

set( OUT_FILE "ROL_output.txt")
set( GOLD_FILE "ROL_output.txt.gold")

set(XMLGEN_COMMAND "XMLGenerator FixedBlocks.i")

set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

# Run test
Plato_add_xmlgen_numdiff_test(${TEST_NAME} ${XMLGEN_COMMAND} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
