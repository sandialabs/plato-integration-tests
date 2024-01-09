Requires_features( PYTHON_INTERPRETER_APP )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "window.csm;defines.xml;interface.xml;mpirun.source;plato_esp_input_deck.xml;plato_esp_operations.xml;plato_main_input_deck.xml;plato_main_operations.xml;plato_python_input_deck.xml;plato_python_operations.xml;NodalCoordinateOptimization.py;rol_inputs.xml;solution.csm.gold")
Plato_add_test_files("${testFiles}")

# Set file names for diff
set( OUT_FILE "window_opt.csm")
set( GOLD_FILE "solution.csm.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-8 )

# Add the test
set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )
Plato_add_numdiff_test(${RUN_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
