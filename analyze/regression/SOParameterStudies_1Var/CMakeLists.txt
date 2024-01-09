Requires_features( PLATOANALYZE_ENABLE_ESP )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.csm *.xml *.gold *.txt *.source)
Plato_add_test_files("${testFiles}")

set( OUT_FILE "diag.txt")
set( GOLD_FILE "diag.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
set( TEST_COMMAND "source mpirun.source")
# Add the test
Plato_add_numdiff_test(${TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
