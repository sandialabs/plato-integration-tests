# 0. decompose mesh if parallel

include(${CMAKE_UTILITIES_DIR}/runmeshdecomp.cmake)
runmeshdecomp(${SEACAS_DECOMP} ${NUM_PROCS} ${INPUT_MESH} ${RESTART_MESH})

# 1. Run the program and generate the exodus output

foreach(TEST_COMMAND ${TEST_COMMANDS})
  message("Running the command:")
  message(${TEST_COMMAND})
  execute_process(COMMAND bash "-c" "${TEST_COMMAND}" RESULT_VARIABLE HAD_ERROR)
endforeach()

if(HAD_ERROR)
  message(FATAL_ERROR "run failed")
endif()



# 2. Find and run epu if parallel

if(NOT ${OUTPUT_MESH} STREQUAL SKIP_EXODIFF)
  list(GET NUM_PROCS_LIST ${IO_COMM_INDEX} NUM_PARTS)

  if(${NUM_PARTS} MATCHES "1")
    message("EPU was skipped because there is only one file part.")
    if(EXISTS ${OUTPUT_MESH}.${NUM_PARTS}.0)
      file(RENAME ${OUTPUT_MESH}.${NUM_PARTS}.0 ${OUTPUT_MESH})
    endif()
  else()
    if (NOT SEACAS_EPU)
      message(FATAL_ERROR "Cannot find epu")
    endif()

    SET(EPU_COMMAND ${SEACAS_EPU} -auto ${OUTPUT_MESH}.${NUM_PARTS}.0)

    message("Running the command:")
    message("${EPU_COMMAND}")

    EXECUTE_PROCESS(COMMAND ${EPU_COMMAND} RESULT_VARIABLE HAD_ERROR)

    if(HAD_ERROR)
      message(FATAL_ERROR "epu failed")
    endif()
  endif()


  # 2. Find and run exodiff

  if (NOT SEACAS_EXODIFF)
    message(FATAL_ERROR "Cannot find exodiff")
  endif()

  SET(EXODIFF_TEST ${SEACAS_EXODIFF} -i -m -f ${EXODIFF_COMMAND_FILE} ${OUTPUT_MESH} ${EXODIFF_REFERENCE})

  message("Running the command:")
  message("${EXODIFF_TEST}")

  EXECUTE_PROCESS(COMMAND ${EXODIFF_TEST} OUTPUT_FILE exodiff.out RESULT_VARIABLE HAD_ERROR)

  if(HAD_ERROR)
    message(FATAL_ERROR "Test failed")
  endif()
endif()
