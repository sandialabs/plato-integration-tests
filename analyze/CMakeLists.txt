include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/utilities/common_data.cmake )

set(ANALYZE_INTEGRATION_TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR})

Set_binaries()
Copy_cmake_utilities_to_binary_dir()

# Copy python scripts
set(COMMON_SOURCE_PYTHON_DIR "../utilities/python")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")
set(ANALYZE_SOURCE_PYTHON_DIR "${CMAKE_CURRENT_SOURCE_DIR}/utilities")

Copy_utility_file_to_dir(
  ${COMMON_SOURCE_PYTHON_DIR} 
  "confirm_gradient_convergence_trend.py" 
  ${BINARY_PYTHON_DIR} 
  CONFIRM_GRADIENT_PYTHON_SCRIPT)

Copy_utility_file_to_dir(
  ${ANALYZE_SOURCE_PYTHON_DIR} 
  "grad_check.py" 
  ${BINARY_PYTHON_DIR} 
  GRADIENT_CHECK_PYTHON_SCRIPT)

Copy_utility_file_to_dir(
  ${ANALYZE_SOURCE_PYTHON_DIR} 
  "finite_difference_utils.py" 
  ${BINARY_PYTHON_DIR} 
  FINITE_DIFFERENCE_PYTHON_SCRIPT)

Copy_utility_file_to_dir(
  ${ANALYZE_SOURCE_PYTHON_DIR} 
  "full_regression_test.py" 
  ${BINARY_PYTHON_DIR} 
  FULL_REGRESSION_PYTHON_SCRIPT)

add_subdirectory(constraint_check)
add_subdirectory(examples)
add_subdirectory(gradient_check)
add_subdirectory(regression)
add_subdirectory(serialized)
