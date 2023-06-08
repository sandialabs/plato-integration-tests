Requires_features( PLATOANALYZE_PE_SERVICES PLATOANALYZE_ENABLE_ESP ) 

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
file( GLOB_RECURSE testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.source *.xml *.exo *.csm *.i *.gold )
Plato_add_test_files("${testFiles}")

# Set the name of the interface file
set( INTERFACE_FILE interface.xml )

# Set file names for diff
set( OUT_FILE "dakota_multi_dimensional_parameter_study.dat")
set( GOLD_FILE "solution.txt.gold")

# set relative tolerance for diff test
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-3 )

set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )

# Add the test
Plato_add_numdiff_test(${RUN_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

