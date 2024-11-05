Requires_features( PYTHON_INTERPRETER_APP )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "window.exo;;interface.xml;mpirun.source;plato_main_input_deck.xml;plato_main_operations.xml;plato_python_input_deck.xml;plato_python_operations.xml;MaterialPropertiesOptimization.py;rol_inputs.xml;ROL_output.txt.gold")
Plato_add_test_files("${testFiles}")

# Set file names for diff
set( OUT_FILE "ROL_output.txt")
set( GOLD_FILE "ROL_output.txt.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-6 )

# Add the test
set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )
Plato_add_numdiff_test(${RUN_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
