###############################################################################
## Sets variables pointing to executables
## Paths to these binaries are expected to be set via `spack load`
###############################################################################
function( Set_binaries )
  set(NUMDIFF_COMMAND "numdiff" PARENT_SCOPE)
  set(SEACAS_EPU "epu" PARENT_SCOPE)
  set(SEACAS_EXODIFF "exodiff" PARENT_SCOPE)
  set(SEACAS_DECOMP "decomp" PARENT_SCOPE)
  set(PLATOMAIN_BINARY "PlatoMain" PARENT_SCOPE)
  set(PLATOESP_BINARY "PlatoESP" PARENT_SCOPE)
  set(Python3_EXECUTABLE "python3" PARENT_SCOPE)
endfunction()

###############################################################################
## Use this function to copy a utility script to a specified binary directory.
## FILE_OUT_VAR will contain the path to the copied file.
###############################################################################
function( Copy_utility_file_to_dir UTILITY_PATH FILE_NAME COPY_DIR FILE_OUT_VAR)
  configure_file("${UTILITY_PATH}/${FILE_NAME}" "${COPY_DIR}/${FILE_NAME}" COPYONLY)
  set(${FILE_OUT_VAR} "${COPY_DIR}/${FILE_NAME}" PARENT_SCOPE)
endfunction()

###############################################################################
## Use this function to find the reference diff file in the
## current source directory.
## Assumes that the reference diff file has extension .ref.diff
###############################################################################
function( Set_diff_reference_files DIFF_REFERENCE )
  file( GLOB DIFF_REFERENCE_LOCAL RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.ref.diff)
  set( ${DIFF_REFERENCE} ${DIFF_REFERENCE_LOCAL} PARENT_SCOPE )
endfunction()

###############################################################################
## Use this function to find the exodiff command file and reference file in the
## current source directory.
## Assumes that the exodiff command file has extension .exodiff_commands and
## the reference file has the extension .ref.exo
##
###############################################################################
function( Set_exodiff_files EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )
  file( GLOB EXODIFF_COMMAND_FILE_LOCAL RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.exodiff_commands)
  file( GLOB EXODIFF_REFERENCE_LOCAL RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.ref.exo)
  set( ${EXODIFF_COMMAND_FILE} ${EXODIFF_COMMAND_FILE_LOCAL} PARENT_SCOPE )
  set( ${EXODIFF_REFERENCE} ${EXODIFF_REFERENCE_LOCAL} PARENT_SCOPE )
endfunction()

###############################################################################
## Use this macro to exit file processing early if not all flags exist.
## Requires_features( 
##    FLAGS == Variable list of feature flags to check
## )
###############################################################################
macro( Requires_features )
  set(arg_list "${ARGN}")
  set(have_all_features "true")
  set(unset_flags "")
  foreach(flag IN LISTS arg_list)
    if(NOT ${flag})
      set(have_all_features "false")
      set(unset_flags "${flag}\n${unset_flags}")
    endif()
  endforeach()
  if(NOT have_all_features)
    set(CUR_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    cmake_path(GET CUR_PATH FILENAME TEST_DIR)
    message(STATUS "${TEST_DIR} test not included because following flags are missing or off:\n${unset_flags}")
    return()
  endif()
endmacro( Requires_features )


###############################################################################
## Use this macro to exit file processing early if ANY of the flags exist.
## Disable_test_on_any_flag( 
##    FLAGS == Variable list of feature flags to check 
## )
###############################################################################
macro(Disable_test_on_any_flag)
  set(arg_list "${ARGN}")
  set(have_any_features "false")
  set(set_flags "")
  foreach(flag IN LISTS arg_list)
    if( ${flag})
      set(have_any_features "true")
      set(set_flags "${flag}\n${set_flags}")
    endif()
  endforeach()
  if(have_any_features)
    set(CUR_PATH ${CMAKE_CURRENT_SOURCE_DIR})
    cmake_path(GET CUR_PATH FILENAME TEST_DIR)
    message(STATUS "${TEST_DIR} test not included because following flags are on:\n${set_flags}")
    return()
  endif()
endmacro(Disable_test_on_any_flag)

###############################################################################
## Copy_cmake_utilities_to_binary_dir 
###############################################################################

macro( Copy_cmake_utilities_to_binary_dir )
  set(SOURCE_CMAKE_UTILITIES_DIR "../utilities/cmake")
  set(BINARY_CMAKE_UTILITIES_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities")
  file(COPY ${SOURCE_CMAKE_UTILITIES_DIR} DESTINATION ${BINARY_CMAKE_UTILITIES_DIR})
  set(BINARY_CMAKE_UTILITIES_DIR "${BINARY_CMAKE_UTILITIES_DIR}/cmake")
endmacro( Copy_cmake_utilities_to_binary_dir )

###############################################################################
## Plato_add_test_files( 
##    FILE_LIST    == List of files to copy into build.
## )
###############################################################################

function( Plato_add_test_files FILE_LIST )
  
  foreach( testFile ${FILE_LIST} )
  
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${testFile} 
                   ${CMAKE_CURRENT_BINARY_DIR}/${testFile} COPYONLY)

  endforeach(testFile)

endfunction(Plato_add_test_files )

###############################################################################
## Plato_direct_copy_test_files( 
##    FILE_LIST    == List of files to copy into build. File names/paths are 
##                    assumed relative to CMAKE_CURRENT_SOURCE_DIR and directly 
##                    copied to CMAKE_CURRENT_BINARY_DIR, removing any directory 
##                    structure.
## )
###############################################################################

function( Plato_direct_copy_test_files FILE_LIST )
  
  foreach( testFile ${FILE_LIST} )
    set( FULL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/${testFile} )
    cmake_path( GET FULL_PATH FILENAME filename )
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${testFile} 
                   ${CMAKE_CURRENT_BINARY_DIR}/${filename} COPYONLY)
  endforeach(testFile)
    
endfunction(Plato_direct_copy_test_files)

###############################################################################
## Plato_add_test( 
##    TESTED_CODE    == code to be tested
##    TEST_NAME      == test name
##    N_PROCS        == number of processors to use for test
##    INPUT_FILE     == input file name
##    EXODIFF_COMMAND_FILE == file containing exodiff commands
##    EXODIFF_REFERENCE  == reference file for exodiff
##    INPUT_MESH     == input mesh file name
##    OUTPUT_MESH    == output mesh file name
##   [RESTART_MESH]  == restart mesh file name (optional)
## )
###############################################################################

function( Plato_add_test RUN_COMMANDS TEST_NAME NUM_PROCS IO_COMM_INDEX EXODIFF_COMMAND_FILE EXODIFF_REFERENCE INPUT_MESH OUTPUT_MESH )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source "${RUN_COMMANDS}")

    set(OptionalArgs ${ARGN})
    list(LENGTH OptionalArgs NumOptionalArgs)
    if(NumOptionalArgs GREATER 0)
        list(GET OptionalArgs 0 RESTART_MESH)
    else()
        unset(RESTART_MESH)
    endif()

    add_test(NAME ${TEST_NAME}
      COMMAND ${CMAKE_COMMAND}
      "-DTEST_COMMANDS=${RUN_COMMANDS}"
      -DTEST_NAME=${TEST_NAME}
      -DNUM_PROCS=${NUM_PROCS}
      -DSEACAS_EPU=${SEACAS_EPU}
      -DSEACAS_EXODIFF=${SEACAS_EXODIFF}
      -DSEACAS_DECOMP=${SEACAS_DECOMP}
      -DEXODIFF_COMMAND_FILE=${EXODIFF_COMMAND_FILE}
      -DEXODIFF_REFERENCE=${EXODIFF_REFERENCE}
      -DIO_COMM_INDEX=${IO_COMM_INDEX}
      -DINPUT_MESH=${INPUT_MESH}
      -DOUTPUT_MESH=${OUTPUT_MESH}
      -DRESTART_MESH=${RESTART_MESH}
      -DCMAKE_UTILITIES_DIR=${BINARY_CMAKE_UTILITIES_DIR}
      -P ${BINARY_CMAKE_UTILITIES_DIR}/runtest.cmake)

endfunction( Plato_add_test )

###############################################################################
## Plato_add_numdiff_test
## Optional argument: Options for ndselect, so that rows or columns of the 
## file to compare can be removed.
###############################################################################

function( Plato_add_numdiff_test RUN_COMMAND TEST_NAME NUMDIFF_COMMAND NUMDIFF_ABSOLUTE NUMDIFF_TOLERANCE )

    set(OptionalArgs ${ARGN})
    list(LENGTH OptionalArgs NumOptionalArgs)
    if(NumOptionalArgs GREATER 0)
        list(GET OptionalArgs 0 NDSELECT_OPTIONS)
    else()
        unset(NDSELECT_OPTIONS)
    endif()

    add_test( NAME ${TEST_NAME}
              COMMAND ${CMAKE_COMMAND} 
              -DTEST_COMMAND=${RUN_COMMAND}
              -DOUT_FILE=${OUT_FILE} 
              -DGOLD_FILE=${GOLD_FILE} 
              -DNUMDIFF_COMMAND=${NUMDIFF_COMMAND}
              -DNUMDIFF_ABSOLUTE=${NUMDIFF_ABSOLUTE}
              -DNUMDIFF_TOLERANCE=${NUMDIFF_TOLERANCE}
              -DNDSELECT_OPTIONS=${NDSELECT_OPTIONS}
              -P ${BINARY_CMAKE_UTILITIES_DIR}/runnumdifftest.cmake )

endfunction( Plato_add_numdiff_test )

###############################################################################
## Plato_add_serial_test( 
## )
###############################################################################

function( Plato_add_serial_test RUN_COMMAND TEST_NAME OUTPUT_MESH EXODIFF_COMMAND_FILE EXODIFF_REFERENCE )

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DTEST_NAME=${TEST_NAME} 
           -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
           -DOUTPUT_MESH=${OUTPUT_MESH}
           -DEXODIFF_COMMAND_FILE=${EXODIFF_COMMAND_FILE}
           -DEXODIFF_REFERENCE=${EXODIFF_REFERENCE}
           -DSEACAS_EXODIFF=${SEACAS_EXODIFF} 
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runtest_serial.cmake)

endfunction( Plato_add_serial_test )

###############################################################################
## Plato_new_test( 
##    TEST_NAME      == test name
## )
###############################################################################

function( Plato_new_test TEST_NAME )

  cmake_path(GET CMAKE_CURRENT_SOURCE_DIR FILENAME DIR_NAME)
  cmake_path(GET CMAKE_CURRENT_SOURCE_DIR PARENT_PATH FIRST_PARENT_DIR)
  cmake_path(GET FIRST_PARENT_DIR FILENAME TEST_TYPE_NAME)
  cmake_path(GET FIRST_PARENT_DIR PARENT_PATH SECOND_PARENT_DIR)
  cmake_path(GET SECOND_PARENT_DIR FILENAME INTEGRATION_CODE_NAME)
  set( ${TEST_NAME} "${INTEGRATION_CODE_NAME}_${TEST_TYPE_NAME}_${DIR_NAME}" PARENT_SCOPE )

endfunction( Plato_new_test )

###############################################################################
## Plato_disable_test
###############################################################################

function( Plato_disable_test TEST_NAME REASON )
    set_property(TEST ${TEST_NAME} APPEND PROPERTY DISABLED TRUE)
    message(STATUS "${TEST_NAME} test disabled, reason: ${REASON}")
endfunction( Plato_disable_test)
