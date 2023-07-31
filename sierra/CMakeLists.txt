include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )

set(SIERRA_INTEGRATION_TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR})

Set_binaries()
Copy_cmake_utilities_to_binary_dir()

# Copy python scripts
set(COMMON_SOURCE_PYTHON_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../utilities/python")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")

Copy_utility_file_to_dir(
  ${COMMON_SOURCE_PYTHON_DIR}
  "confirm_gradient_convergence_trend.py"
  ${BINARY_PYTHON_DIR}
  CONFIRM_GRADIENT_PYTHON_SCRIPT)

add_subdirectory(examples)
add_subdirectory(gradient_check)
