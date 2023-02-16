include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )

Set_binaries()
Copy_cmake_utilities_to_binary_dir()

set(COGENT_SOURCE_PYTHON_DIR "${CMAKE_CURRENT_SOURCE_DIR}/utilities")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")

Copy_utility_file_to_dir(
  ${COGENT_SOURCE_PYTHON_DIR} 
  "computeCogentVolume.py" 
  ${BINARY_PYTHON_DIR} 
  COGENT_VOLUME_PYTHON_SCRIPT)

add_subdirectory(regression)

