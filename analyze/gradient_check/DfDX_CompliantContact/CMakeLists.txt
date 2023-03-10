Requires_features( PLATOANALYZE_ENABLE_AMGX)

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( testFiles "plato_analyze_input_deck.xml;plato_analyze_operations.xml")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("two_block_tensile_hole.exo")

# Create dummy input 
set( NUM_PROCS 1 )
set( IO_COMM_INDEX 0 )

# Set input file names for running finite difference computations through python
set( INITIAL_FINITE_DIFFERENCE_STEP 1e-1 )
set( FINITE_DIFFERENCE_STEPS 10 )

# Set input file names for running comparison with gold
set( INFNORM_IGNORE_ROWS 1 )
set( INFNORM_RELATIVE_TOLERANCE 1e-1 )
set( OUT_FILE "gradient_check.out")
set( GOLD_FILE "gradient_check.gold.out")
set( LAST_ROW 5 )

# create test command
SET(TEST_COMMAND "python ${GRADIENT_CHECK_PYTHON_SCRIPT} ${INITIAL_FINITE_DIFFERENCE_STEP} ${FINITE_DIFFERENCE_STEPS}\\\; python ${CONFIRM_GRADIENT_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${CMAKE_CURRENT_SOURCE_DIR}/${GOLD_FILE} ${LAST_ROW}")
SET(CUSTOM_COMMAND "echo test has run")

# Add the test
Plato_add_custom_command_test(${TEST_COMMAND} ${TEST_NAME} ${NUM_PROCS} ${IO_COMM_INDEX} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
