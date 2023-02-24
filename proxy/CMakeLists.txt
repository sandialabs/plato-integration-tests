include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )

Set_binaries()
Copy_cmake_utilities_to_binary_dir()

# Copy python utilities to binary directory
set(SOURCE_PYTHON_DIR "../utilities/python")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")

Copy_utility_file_to_dir(
  ${SOURCE_PYTHON_DIR} 
  "confirm_gradient_convergence_trend.py" 
  ${BINARY_PYTHON_DIR} 
  GRADIENT_CHECK_PYTHON_SCRIPT)

add_subdirectory(gradient_check)
add_subdirectory(regression)
add_subdirectory(serialized)
