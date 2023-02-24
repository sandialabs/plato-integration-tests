Requires_features(PLATOANALYZE_ENABLE_PYTHON PLATOANALYZE_ENABLE_GEOMETRY)

file( GLOB testFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.py *.xml *.exo *.exodiff_commands)
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( TEST_COMMAND "${Python3_EXECUTABLE} computeGradientX.py" )
set( OUTPUT_MESH "result.exo" )

Set_exodiff_files( EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )
Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE})
