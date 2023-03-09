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
  set(ANALYZE_BINARY "analyze_MPMD" PARENT_SCOPE)
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
    
endfunction(Plato_add_test_files)

###############################################################################
## Plato_create_test
#     RUN_COMMAND       == beginning of mpirun statement for MPMD configuration
#     PLATOMAIN_BINARY  == PlatoMain executable
#     PLATOMAIN_NPROCS  == number of processes for PlatoMain
#     INTERFACE_FILE    == Plato interface file
#     APPFILE           == PlatoMain applicaiton file
#     INPUTFILE         == PlatoMain input file
###############################################################################

function( Plato_create_test RUN_COMMAND PLATOMAIN_BINARY PLATOMAIN_NPROCS INTERFACE_FILE APPFILE INPUTFILE )

  set( ${RUN_COMMAND} 
       "mpirun -np ${PLATOMAIN_NPROCS} --oversubscribe -x PLATO_PERFORMER_ID=0 -x PLATO_INTERFACE_FILE=${INTERFACE_FILE} -x PLATO_APP_FILE=${APPFILE} ${PLATOMAIN_BINARY} ${INPUTFILE}" PARENT_SCOPE )

endfunction( Plato_create_test )

###############################################################################
## Plato_create_simple_test
#     RUN_COMMAND       == beginning of mpirun statement for MPMD configuration
#     PLATOMAIN_BINARY  == PlatoMain executable
#     PLATOMAIN_NPROCS  == number of processes for PlatoMain
#     INTERFACE_FILE    == Plato interface file
###############################################################################

function( Plato_create_simple_test RUN_COMMAND PLATOMAIN_BINARY PLATOMAIN_NPROCS INTERFACE_FILE )

  set( ${RUN_COMMAND} 
       "mpirun -np ${PLATOMAIN_NPROCS} --oversubscribe -x PLATO_PERFORMER_ID=0 -x PLATO_INTERFACE_FILE=${INTERFACE_FILE} ${PLATOMAIN_BINARY}" PARENT_SCOPE )

endfunction( Plato_create_simple_test )

###############################################################################
## Plato_add_performer
#     RUN_COMMAND        == mpirun statement for MPMD configuration
#     PERFORMER_BINARY   == Performer executable
#     PERFORMER_NPROCS   == number of processes for this Performer
#     LOCAL_PERFORMER_ID == Performer ID for this performer
#     INTERFACE_FILE     == Plato interface file
#     APPFILE            == Performer applicaiton file
#     INPUTFILE          == Performer input file
###############################################################################

function( Plato_add_performer RUN_COMMAND PERFORMER_BINARY PERFORMER_NPROCS LOCAL_PERFORMER_ID INTERFACE_FILE APPFILE INPUTFILE )

  set( ${RUN_COMMAND} "${${RUN_COMMAND}} : -np ${PERFORMER_NPROCS} --oversubscribe -x PLATO_PERFORMER_ID=${LOCAL_PERFORMER_ID} -x PLATO_INTERFACE_FILE=${INTERFACE_FILE} -x PLATO_APP_FILE=${APPFILE} ${PERFORMER_BINARY} ${INPUTFILE}" PARENT_SCOPE )

endfunction( Plato_add_performer )

###############################################################################
## Plato_add_simple_performer
#     RUN_COMMAND        == mpirun statement for MPMD configuration
#     PERFORMER_BINARY   == Performer executable
#     PERFORMER_NPROCS   == number of processes for this Performer
#     LOCAL_PERFORMER_ID == Performer ID for this performer
#     INTERFACE_FILE     == Plato interface file
###############################################################################

function( Plato_add_simple_performer RUN_COMMAND PERFORMER_BINARY PERFORMER_NPROCS LOCAL_PERFORMER_ID INTERFACE_FILE )

  set( ${RUN_COMMAND} "${${RUN_COMMAND}} : -np ${PERFORMER_NPROCS} --oversubscribe -x PLATO_PERFORMER_ID=${LOCAL_PERFORMER_ID} -x PLATO_INTERFACE_FILE=${INTERFACE_FILE} ${PERFORMER_BINARY}" PARENT_SCOPE )

endfunction( Plato_add_simple_performer )

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
## Plato_add_xmlgen_test( 
## )
###############################################################################

function( Plato_add_xmlgen_test TEST_NAME XMLGEN_COMMAND EXODIFF_COMMAND_FILE EXODIFF_REFERENCE NUM_PROCS IO_COMM_INDEX OUTPUT_MESH SKIP_EXODIFF )

#    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source ${RUN_COMMAND})
  set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DTEST_NAME=${TEST_NAME} 
           -DNUM_PROCS=${NUM_PROCS}
           -DXMLGEN_COMMAND=${XMLGEN_COMMAND}
           -DEXODIFF_COMMAND_FILE=${EXODIFF_COMMAND_FILE}
           -DEXODIFF_REFERENCE=${EXODIFF_REFERENCE}
           -DSKIP_EXODIFF=${SKIP_EXODIFF}
           -DSEACAS_EPU=${SEACAS_EPU} 
           -DSEACAS_EXODIFF=${SEACAS_EXODIFF} 
           -DSEACAS_DECOMP=${SEACAS_DECOMP}
           -DIO_COMM_INDEX=${IO_COMM_INDEX}
           -DOUTPUT_MESH=${OUTPUT_MESH}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runxmlgentest.cmake)

endfunction( Plato_add_xmlgen_test )

###############################################################################
## Plato_add_single_test( 
##    TEST_NAME    == test name
##    TEST_COMMAND == command string to be passed to shell
## )
###############################################################################

function( Plato_add_single_test RUN_COMMAND TEST_NAME )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source ${RUN_COMMAND})

    add_test( NAME ${TEST_NAME}
              COMMAND ${CMAKE_COMMAND}
              -DTEST_COMMAND=${RUN_COMMAND}
              -P ${BINARY_CMAKE_UTILITIES_DIR}/runsingletest.cmake )

endfunction( Plato_add_single_test )

###############################################################################
## Plato_add_simple_test( 
##    TEST_NAME      == test name
##    NUM_PROCS      == number of processors to use for test
##    IO_COMM_INDEX  == io communicator index
## )
###############################################################################

function( Plato_add_simple_test RUN_COMMAND TEST_NAME NUM_PROCS IO_COMM_INDEX )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source "${RUN_COMMAND}")

    add_test( NAME ${TEST_NAME}
              COMMAND ${CMAKE_COMMAND} 
              "-DTEST_COMMAND=${RUN_COMMAND}"
              -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
              -DOUT_FILE=${OUT_FILE} 
              -DGOLD_FILE=${GOLD_FILE} 
              -P ${BINARY_CMAKE_UTILITIES_DIR}/runsimpletest.cmake )

endfunction( Plato_add_simple_test )


###############################################################################
## Plato_add_custom_command_test( 
## )
###############################################################################

function( Plato_add_custom_command_test RUN_COMMAND TEST_NAME NUM_PROCS IO_COMM_INDEX CUSTOM_COMMAND )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source "${RUN_COMMAND}")

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
           -DOUT_FILE=${OUT_FILE} 
           -DGOLD_FILE=${GOLD_FILE} 
           -DCUSTOM_COMMAND=${CUSTOM_COMMAND}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runcustomcommandtest.cmake )

endfunction( Plato_add_custom_command_test )


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
## Plato_add_xmlgen_numdiff_test( 
## )
###############################################################################

function( Plato_add_xmlgen_numdiff_test TEST_NAME XMLGEN_COMMAND NUMDIFF_COMMAND NUMDIFF_ABSOLUTE NUMDIFF_TOLERANCE )

  set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DXMLGEN_COMMAND=${XMLGEN_COMMAND}
           -DOUT_FILE=${OUT_FILE} 
           -DGOLD_FILE=${GOLD_FILE} 
           -DNUMDIFF_COMMAND=${NUMDIFF_COMMAND}
           -DNUMDIFF_ABSOLUTE=${NUMDIFF_ABSOLUTE}
           -DNUMDIFF_TOLERANCE=${NUMDIFF_TOLERANCE}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runxmlgennumdifftest.cmake)

endfunction( Plato_add_xmlgen_numdiff_test )

###############################################################################
## Plato_add_parallel_numdiff_test( 
##    TEST_NAME      == test name
## )
###############################################################################

function( Plato_add_parallel_numdiff_test RUN_COMMAND TEST_NAME NUMDIFF_COMMAND NUMDIFF_ABSOLUTE NUMDIFF_TOLERANCE NUM_PROCS IO_COMM_INDEX INPUT_MESH )
    # Check for RESTART_MESH
    set(OptionalArgs ${ARGN})
    list(LENGTH OptionalArgs NumOptionalArgs)
    if(NumOptionalArgs GREATER 0)
        list(GET OptionalArgs 0 RESTART_MESH)
    endif()

    add_test( NAME ${TEST_NAME}
              COMMAND ${CMAKE_COMMAND} 
              -DTEST_COMMAND=${RUN_COMMAND}
              -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
              -DOUT_FILE=${OUT_FILE} 
              -DGOLD_FILE=${GOLD_FILE} 
              -DNUMDIFF_COMMAND=${NUMDIFF_COMMAND}
              -DNUMDIFF_ABSOLUTE=${NUMDIFF_ABSOLUTE}
              -DNUMDIFF_TOLERANCE=${NUMDIFF_TOLERANCE}
              -DNUM_PROCS=${NUM_PROCS}
              -DSEACAS_DECOMP=${SEACAS_DECOMP}
              -DINPUT_MESH=${INPUT_MESH}
              -DRESTART_MESH=${RESTART_MESH}
              -DIO_COMM_INDEX=${IO_COMM_INDEX}
              -DSOURCE_DIR=${CMAKE_SOURCE_DIR}
              -P ${BINARY_CMAKE_UTILITIES_DIR}/runparallelnumdifftest.cmake )

endfunction( Plato_add_parallel_numdiff_test )

###############################################################################
## Plato_add_xmlgen_custom_command_test( 
## )
###############################################################################

function( Plato_add_xmlgen_custom_command_test TEST_NAME XMLGEN_COMMAND CUSTOM_COMMAND )

  set( RUN_COMMAND "source ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source" )

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DXMLGEN_COMMAND=${XMLGEN_COMMAND}
           -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
           -DOUT_FILE=${OUT_FILE} 
           -DGOLD_FILE=${GOLD_FILE} 
           -DCUSTOM_COMMAND=${CUSTOM_COMMAND}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runxmlgencustomcommandtest.cmake)

endfunction( Plato_add_xmlgen_custom_command_test )


###############################################################################
## Plato_add_xmlgen_no_run_custom_command_test( 
## )
###############################################################################

function( Plato_add_xmlgen_no_run_custom_command_test TEST_NAME XMLGEN_COMMAND CUSTOM_COMMAND )

  set( RUN_COMMAND "cat mpirun.source defines.xml plato_main_operations.xml interface.xml > xmlout.tmp" )

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DXMLGEN_COMMAND=${XMLGEN_COMMAND}
           -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
           -DOUT_FILE=${OUT_FILE} 
           -DGOLD_FILE=${GOLD_FILE} 
           -DCUSTOM_COMMAND=${CUSTOM_COMMAND}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/runxmlgencustomcommandtest.cmake)

endfunction( Plato_add_xmlgen_no_run_custom_command_test )

###############################################################################
## Plato_add_awk_test( 
##    TEST_NAME      == test name
##    NUM_PROCS      == number of processors to use for test
##    IO_COMM_INDEX  == io communicator index
## )
###############################################################################

function( Plato_add_awk_test RUN_COMMAND TEST_NAME NUM_PROCS IO_COMM_INDEX )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source ${RUN_COMMAND})

    add_test( NAME ${TEST_NAME}
              COMMAND ${CMAKE_COMMAND} 
              -DTEST_COMMAND=${RUN_COMMAND}
              -DDATA_DIR=${CMAKE_CURRENT_SOURCE_DIR} 
              -DOUT_FILE=${OUT_FILE} 
              -DGOLD_FILE=${GOLD_FILE} 
              -DAWK_FILE=${AWK_FILE} 
              -P ${BINARY_CMAKE_UTILITIES_DIR}/runawktest.cmake )

endfunction( Plato_add_awk_test )

###############################################################################
## Plato_add_diff( 
## )
###############################################################################

function( Plato_add_diff RUN_COMMAND TEST_NAME NUM_PROCS INPUT_MESH DIFF_FILE )

    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/mpirun.source ${RUN_COMMAND})

    add_test(NAME ${TEST_NAME}
           COMMAND ${CMAKE_COMMAND} 
           -DTEST_COMMAND=${RUN_COMMAND}
           -DTEST_NAME=${TEST_NAME} 
           -DNUM_PROCS=${NUM_PROCS}
           -DSEACAS_EPU=${SEACAS_EPU} 
           -DSEACAS_DECOMP=${SEACAS_DECOMP}
           -DINPUT_MESH=${INPUT_MESH}
           -DDIFF_FILE=${DIFF_FILE}
           -P ${BINARY_CMAKE_UTILITIES_DIR}/rundiff.cmake)

endfunction( Plato_add_diff )

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
## Plato_add_output_exists_test 
## The purpose of this test is to check for the existence of a file after
## another test has been run. 
##   TEST_NAME      == Main test name, which should produce an expected output
##                     file
##   FILE_NAME      == The file to check
##    
###############################################################################
function( Plato_add_output_exists_test TEST_NAME FILE_NAME )
    set(TEST_NAME_OUTPUT_EXISTS ${TEST_NAME}_output_exists)
    add_test(NAME ${TEST_NAME_OUTPUT_EXISTS} COMMAND test -f ${FILE_NAME})
    set_tests_properties( ${TEST_NAME_OUTPUT_EXISTS} PROPERTIES DEPENDS ${TEST_NAME})
    set_property(TEST ${TEST_NAME_OUTPUT_EXISTS} PROPERTY LABELS "small")

endfunction( Plato_add_output_exists_test )

###############################################################################
## Plato_disable_test
###############################################################################

function( Plato_disable_test TEST_NAME REASON )
    set_property(TEST ${TEST_NAME} APPEND PROPERTY DISABLED TRUE)
    message(STATUS "${TEST_NAME} test disabled, reason: ${REASON}")
endfunction( Plato_disable_test)
