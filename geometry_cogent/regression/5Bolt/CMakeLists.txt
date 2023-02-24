Requires_features(PLATO_ENABLE_SERVICES_PYTHON EXPY)

set( testFiles "5Bolt.exodiff_commands;5Bolt.ref.exo;platoApp.xml;platoMain.xml;background.gen;5bolt.cogent")
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( TEST_COMMAND "${Python3_EXECUTABLE} ${COGENT_VOLUME_PYTHON_SCRIPT}" )
set( OUTPUT_MESH "volume_grad.exo" )

Set_exodiff_files( EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )
Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
