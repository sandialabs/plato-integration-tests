Requires_features( LEGACY_BUILD )
# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "window.exo;input.i;plato-python-app-input.xml;MaterialPropertiesOptimization.py;ROL_Optimizer.txt.gold")
Plato_add_test_files("${testFiles}")

# Set file names for diff
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-6 )

# Add the test
set( RUN_COMMAND "plato input.i" )
Plato_add_numdiff_test(${RUN_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
