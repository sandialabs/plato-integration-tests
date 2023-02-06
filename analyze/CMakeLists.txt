include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/utilities/common_data.cmake )

set(ANALYZE_INTEGRATION_TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# Set executables
# Expected to be set via `spack load`
set(NUMDIFF_COMMAND "numdiff")
set(SEACAS_EPU "epu")
set(SEACAS_EXODIFF "exodiff")
set(SEACAS_DECOMP "decomp")
set(PLATOMAIN_BINARY "PlatoMain")
set(PLATOESP_BINARY "PlatoESP" )
set(ANALYZE_BINARY "analyze_MPMD")
set(Python3_EXECUTABLE "python3")

Copy_cmake_utilities_to_binary_dir()

# Copy python scripts
set(COMMON_SOURCE_PYTHON_DIR "../utilities/python")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")

set(CONFIRM_GRADIENT_PYTHON_SCRIPT "confirm_gradient_convergence_trend.py")
configure_file("${COMMON_SOURCE_PYTHON_DIR}/${CONFIRM_GRADIENT_PYTHON_SCRIPT}" "${BINARY_PYTHON_DIR}/${CONFIRM_GRADIENT_PYTHON_SCRIPT}" COPYONLY)
set(CONFIRM_GRADIENT_PYTHON_SCRIPT "${BINARY_PYTHON_DIR}/${CONFIRM_GRADIENT_PYTHON_SCRIPT}")

set(ANALYZE_SOURCE_PYTHON_DIR "./utilities")
set(GRADIENT_CHECK_PYTHON_SCRIPT "grad_check.py")
configure_file("${ANALYZE_SOURCE_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}" "${BINARY_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}" COPYONLY)
set(GRADIENT_CHECK_PYTHON_SCRIPT "${BINARY_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}")

set(FINITE_DIFFERENCE_PYTHON_SCRIPT "finite_difference_utils.py")
configure_file("${ANALYZE_SOURCE_PYTHON_DIR}/${FINITE_DIFFERENCE_PYTHON_SCRIPT}" "${BINARY_PYTHON_DIR}/${FINITE_DIFFERENCE_PYTHON_SCRIPT}" COPYONLY)

set(FULL_REGRESSION_PYTHON_SCRIPT "full_regression_test.py")
configure_file("${ANALYZE_SOURCE_PYTHON_DIR}/${FULL_REGRESSION_PYTHON_SCRIPT}" "${BINARY_PYTHON_DIR}/${FULL_REGRESSION_PYTHON_SCRIPT}" COPYONLY)
set(FULL_REGRESSION_PYTHON_SCRIPT "/${BINARY_PYTHON_DIR}/${FULL_REGRESSION_PYTHON_SCRIPT}")

add_subdirectory(examples)
add_subdirectory(gradient_check)
add_subdirectory(regression)
add_subdirectory(serialized)
