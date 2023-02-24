function(Apply_ndselect FILE_NAME OPTIONS)
  set(OUT_FILE_TMP "${FILE_NAME}.tmp")
  execute_process(COMMAND bash "-c" "mv ${FILE_NAME} ${OUT_FILE_TMP}")
  execute_process(COMMAND bash "-c" "ndselect ${OPTIONS} ${OUT_FILE_TMP} > ${FILE_NAME}" RESULT_VARIABLE HAD_ERROR)
  execute_process(COMMAND bash "-c" "rm ${OUT_FILE_TMP}")
  if(HAD_ERROR)
    message(FATAL_ERROR "ndselect failed")
  endif()
endfunction()

# 1. Run the program and generate the exodus output

message("Running the command:")
message("${TEST_COMMAND}")
execute_process(COMMAND bash "-c" "echo ${TEST_COMMAND}" RESULT_VARIABLE HAD_ERROR)
execute_process(COMMAND bash "-c" "${TEST_COMMAND}" RESULT_VARIABLE HAD_ERROR)

if(HAD_ERROR)
  message(FATAL_ERROR "run failed")
endif()

if(NUMDIFF_ABSOLUTE)
  set(NUMDIFF_FLAG -a)
else()
  set(NUMDIFF_FLAG -r)
endif()

# 2. Run ndselect if options were specified
if(NDSELECT_OPTIONS)
  message(STATUS "Running ndselect with options: ${NDSELECT_OPTIONS}")
  Apply_ndselect(${OUT_FILE} ${NDSELECT_OPTIONS})
  Apply_ndselect(${GOLD_FILE} ${NDSELECT_OPTIONS})
endif()

# 3. Run numdiff command
SET(DIFF_TEST "${NUMDIFF_COMMAND} ${NUMDIFF_FLAG} ${NUMDIFF_TOLERANCE} ${OUT_FILE} ${GOLD_FILE}")

message("Running unix-diff command:")
message("${DIFF_TEST}")

#EXECUTE_PROCESS(COMMAND ${DIFF_TEST} RESULT_VARIABLE HAD_ERROR)
execute_process(COMMAND bash "-c" "${DIFF_TEST}" RESULT_VARIABLE HAD_ERROR)

if(HAD_ERROR)
  message(FATAL_ERROR "Test failed")
endif()
