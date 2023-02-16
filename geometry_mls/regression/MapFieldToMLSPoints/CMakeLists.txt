Requires_features( PLATO_ENABLE_SERVICES_PYTHON EXPY )

Set_exodiff_files( EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )
set( testFiles "mapFieldToMLSPoints.py;platoApp.xml;platoMain.xml;square_tet_bc.exo;analyzeApp.xml;amgx.json;square_tet_bc.xml;${EXODIFF_COMMAND_FILE};${EXODIFF_REFERENCE}")
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( TEST_COMMAND "${Python3_EXECUTABLE} mapFieldToMLSPoints.py" )
set( OUTPUT_MESH "MLS_Field.exo" )

Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
