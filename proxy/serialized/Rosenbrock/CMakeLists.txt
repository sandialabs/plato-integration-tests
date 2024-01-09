# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.xml *.source )
Plato_add_test_files("${testFiles}")

file(READ ./mpirun_save.source SAVE_RUN_COMMAND)
file(READ ./mpirun_load.source LOAD_RUN_COMMAND)

# Add the test
add_test( NAME ${TEST_NAME}
          COMMAND ${CMAKE_COMMAND} 
          "-DTEST_COMMAND_SAVE=${SAVE_RUN_COMMAND}"
          "-DTEST_COMMAND_LOAD=${LOAD_RUN_COMMAND}"
          -DRESULT_FILE="ROL_output.txt" 
          -DRESULT_FILE_SAVE="ROL_output_save.txt" 
          -P ${BINARY_CMAKE_UTILITIES_DIR}/load_save_comparison.cmake )

set_property(TEST ${TEST_NAME} PROPERTY LABELS "small")
