Plato_new_test(TEST_NAME)

set( testFiles "octet_hex.xml;octet_tet.xml" )
Plato_add_test_files( "${testFiles}" )

set( COMMAND1 "${COGENT_BINARY} --input=octet_hex.xml --output=model_hex.vtk" )
set( COMMAND2 "${COGENT_BINARY} --input=octet_tet.xml --output=model_tet.vtk" )
set( COMMANDS "${COMMAND1};${COMMAND2}" )

add_test(
  NAME ${TEST_NAME}
  COMMAND ${CMAKE_COMMAND}
  -DCOMMANDS=${COMMANDS}
  -P ${BINARY_CMAKE_UTILITIES_DIR}/run.cmake
)
set_property(TEST ${TEST_NAME} PROPERTY LABELS "medium")
