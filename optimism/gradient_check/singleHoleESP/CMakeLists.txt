Requires_features( PYTHON_INTERPRETER_APP )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.csm *.xml *.py *.source *.txt )
Plato_add_test_files("${testFiles}")

# Set input file names for custom command
set( INFNORM_IGNORE_ROWS 2 )
set( INFNORM_RELATIVE_TOLERANCE 1e-2 )
set( OUT_FILE "ROL_gradient_check_output.txt")
set( GOLD_FILE "ROL_gradient_check_output.gold.txt")
set( LAST_ROW 7 )

set(CUSTOM_COMMAND "python ${GRADIENT_CHECK_PYTHON_SCRIPT} ${INFNORM_IGNORE_ROWS} ${INFNORM_RELATIVE_TOLERANCE} ${OUT_FILE} ${GOLD_FILE} ${LAST_ROW}")

# Add the test
set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )
Plato_add_custom_command_test_given_mpirun(${RUN_COMMAND} ${TEST_NAME} ${CUSTOM_COMMAND})
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
