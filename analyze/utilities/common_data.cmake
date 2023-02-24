function( Plato_analyze_test_data_path FILE_NAME FULL_PATH )
  set( FULL_PATH "${ANALYZE_INTEGRATION_TEST_DIR}/data/${FILE_NAME}" PARENT_SCOPE)
endfunction()

function ( Plato_analyze_copy_test_data FILE_NAME )
  Plato_analyze_test_data_path(${FILE_NAME} FULL_PATH)
  configure_file(${FULL_PATH} "${CMAKE_CURRENT_BINARY_DIR}/${FILE_NAME}" COPYONLY)
endfunction()
