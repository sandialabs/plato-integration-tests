Requires_features( PLATOANALYZE_STK_ENABLED )

# Name the test with the directory name
Plato_new_test(TEST_NAME)

# Copy Input files from source to binary dir
set(testFiles "input.i;input-2-load.i;plato_analyze_to.xml;plato_analyze_vol.xml;rol_inputs.xml;ROL_Optimizer.txt.gold")
Plato_add_test_files("${testFiles}")
Plato_analyze_copy_test_data("lbracket.exo")

set( PLATO_TEST_COMMAND "plato input.i")
set( OUT_FILE "ROL_Optimizer.txt")
set( GOLD_FILE "ROL_Optimizer.txt.gold")
set( NUMDIFF_USE_ABSOLUTE FALSE)
set( NUMDIFF_RELATIVE_TOLERANCE 1e-4 )

Plato_add_numdiff_test(${PLATO_TEST_COMMAND} ${TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})

# Test using two identical loads, but with aggregation weights halved
set( TWO_LOAD_TEST_NAME "${TEST_NAME}_2Load" )
set( NUM_RANKS 2 )
set( TWO_LOAD_TEST_COMMAND "${MPIEXEC_EXECUTABLE} ${MPIEXEC_NUMPROC_FLAG} ${NUM_RANKS} plato input-2-load.i" )
Plato_add_numdiff_test(${TWO_LOAD_TEST_COMMAND} ${TWO_LOAD_TEST_NAME} ${NUMDIFF_COMMAND} ${NUMDIFF_USE_ABSOLUTE} ${NUMDIFF_RELATIVE_TOLERANCE})
