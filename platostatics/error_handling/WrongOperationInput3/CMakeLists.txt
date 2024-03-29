# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.xml *.gen *.diff)
Plato_add_test_files("${testFiles}")

# Set number of processors for PlatoMain comm
set( PLATOMAIN_NP 3 )

# Set number of processors for Performer comms
set( PLATOSTATICS_NP 4 )

# Create list of comm sizes 
set( NUM_PROCS "${PLATOMAIN_NP} ${PLATOSTATICS_NP} ${PLATOSTATICS_NP}" )

# Specify which comm will provide the output for comparison
set( IO_COMM_INDEX 0 )

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Create the test and define the PlatoMain performer
set(APP_FILE platoApp.xml)
set(INPUT_FILE platomain.xml)
Plato_create_test(PLATO_NEW_TEST $<TARGET_FILE:PlatoMain> ${PLATOMAIN_NP} ${INTERFACE_FILE} ${APP_FILE} ${INPUT_FILE})

# Define/add a performer
set( LOCAL_COMM_ID 1 )
set(APP_FILE localApp1.xml)
set(INPUT_FILE lightmp1.xml)
Plato_add_performer(PLATO_NEW_TEST $<TARGET_FILE:PlatoStatics> ${PLATOSTATICS_NP} ${LOCAL_COMM_ID} ${INTERFACE_FILE} ${APP_FILE} ${INPUT_FILE})

# Define/add a performer
set( LOCAL_COMM_ID 2 )
set(APP_FILE localApp2.xml)
set(INPUT_FILE lightmp2.xml)
Plato_add_performer(PLATO_NEW_TEST $<TARGET_FILE:PlatoStatics> ${PLATOSTATICS_NP} ${LOCAL_COMM_ID} ${INTERFACE_FILE} ${APP_FILE} ${INPUT_FILE})

# Add the test
set(INPUT_MESH unsmesh.gen)
Set_diff_reference_files(DIFF_FILE)
Plato_add_diff(${PLATO_NEW_TEST} ${TEST_NAME} ${NUM_PROCS} ${INPUT_MESH} ${DIFF_FILE})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")

