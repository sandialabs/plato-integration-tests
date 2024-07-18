Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set( BASE_TEST_FILE_PATH "../CompMin2D_LBracket" )
file( GLOB TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${BASE_TEST_FILE_PATH}/*.xml )
Plato_direct_copy_test_files("${TEST_FILES}")

set(KERNEL_TEST_FILES "input-kernel-filter.i;ROL_Optimizer.txt.gold")
Plato_add_test_files("${KERNEL_TEST_FILES}")

Plato_analyze_copy_test_data("lbracket.exo")

# Add test to run problem and check ROL optimization output
set( PLATO_TEST_COMMAND "plato input-kernel-filter.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )
Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
