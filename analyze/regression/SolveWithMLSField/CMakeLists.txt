Requires_features(PLATOANALYZE_ENABLE_PYTHON PLATOANALYZE_ENABLE_GEOMETRY)

Plato_new_test(TEST_NAME)

Set_exodiff_files( EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )
set( testFiles "solveWithMLSField.py;platoApp.xml;platoMain.xml;square_tet_bc.exo;analyzeApp.xml;square_tet_bc.xml;${EXODIFF_COMMAND_FILE};${EXODIFF_REFERENCE}")
Plato_add_test_files( "${testFiles}" )

set( TEST_COMMAND "${Python3_EXECUTABLE} solveWithMLSField.py" )
set( OUTPUT_MESH "MLS_Field.exo" )

Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
