Requires_features( PLATOANALYZE_ROL_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB EXODIFF_COMMAND_FILE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.exodiff_commands)
file( GLOB EXODIFF_REFERENCE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.ref.exo)
set( testFiles "plato_input_deck.i;${EXODIFF_COMMAND_FILE};${EXODIFF_REFERENCE}")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("cantilever.exo")

# Specify which comm will provide the output for comparison
set( IO_COMM_INDEX 0 )

# Set number of processors for PlatoMain comm 
set( PLATOMAIN_NP 1 )

# Set number of processors for Performer comms
set( ANALYZE_NP 1 )

# Create list of comm sizes 
set( NUM_PROCS "${PLATOMAIN_NP} ${ANALYZE_NP}" )

# set mesh for epu at end
set(OUTPUT_MESH platomain.exo.1.0)
set(XMLGEN_COMMAND "XMLGenerator plato_input_deck.i")

set( SKIP_EXODIFF 0 )

# Run test
Plato_add_xmlgen_test(${TEST_NAME} ${XMLGEN_COMMAND} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} 
  ${NUM_PROCS} ${IO_COMM_INDEX} ${OUTPUT_MESH} ${SKIP_EXODIFF})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
Plato_disable_test(${TEST_NAME} "Until steady_state_thermomechanics is enabled")
