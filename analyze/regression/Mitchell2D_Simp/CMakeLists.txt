Requires_features(PLATOANALYZE_ENABLE_PYTHON PLATOANALYZE_ENABLE_GEOMETRY)

file( GLOB EXODIFF_COMMAND_FILE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.exodiff_commands)
file( GLOB EXODIFF_REFERENCE RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.ref.exo)
set( testFiles "opt.py;platoApp.xml;platoMain.xml;mitchell_tri.exo;analyzeApp.xml;mitchell_tri.xml;${EXODIFF_COMMAND_FILE};${EXODIFF_REFERENCE}")
Plato_add_test_files( "${testFiles}" )

Plato_new_test(TEST_NAME)

set( TEST_COMMAND "${Python3_EXECUTABLE} opt.py" )
set( OUTPUT_MESH "Mitchell2D.exo" )

Plato_add_serial_test( ${TEST_COMMAND} ${TEST_NAME} ${OUTPUT_MESH} ${EXODIFF_COMMAND_FILE} ${EXODIFF_REFERENCE} )
