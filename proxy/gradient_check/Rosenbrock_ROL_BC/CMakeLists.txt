Requires_features( EXPY )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "interface.xml;rol_inputs.xml;ROL_gradient_check_output.gold.txt")
Plato_add_test_files("${testFiles}")

# Set number of processors for PlatoMain comm
set( PLATOMAIN_NP 1 )

# Set number of processors for Performer comms
set( PROXY_NP 1 )

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.gold.txt")
set( LAST_ROW 6 )

# Create simple regression test and define the PlatoMain performer
Plato_create_simple_test(PLATO_NEW_TEST ${PLATOMAIN_BINARY} ${PLATOMAIN_NP} ${INTERFACE_FILE})

# Define/add a performer
set( LOCAL_COMM_ID 1 )
Plato_add_simple_performer(PLATO_NEW_TEST $<TARGET_FILE:RosenbrockProxy> ${PROXY_NP} ${LOCAL_COMM_ID} ${INTERFACE_FILE})

SET(CUSTOM_COMMAND "python ${GRADIENT_CHECK_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW}")

# Add the test
Plato_add_custom_command_test(${PLATO_NEW_TEST} ${TEST_NAME} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
