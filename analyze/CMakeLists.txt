include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )
include( ${CMAKE_CURRENT_SOURCE_DIR}/utilities/common_data.cmake )

set(ANALYZE_INTEGRATION_TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR})

Set_binaries()
Copy_cmake_utilities_to_binary_dir()

# Copy python scripts
set(COMMON_SOURCE_PYTHON_DIR "../utilities/python")
set(COMMON_SOURCE_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake")
set(BINARY_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}/utilities/python")
set(ANALYZE_SOURCE_UTILITIES_DIR "${CMAKE_CURRENT_SOURCE_DIR}/utilities")

Copy_utility_file_to_dir(
  ${COMMON_SOURCE_PYTHON_DIR} 
  "confirm_gradient_convergence_trend.py" 
  ${BINARY_PYTHON_DIR} 
  CONFIRM_GRADIENT_PYTHON_SCRIPT)

Copy_utility_file_to_dir(
  ${ANALYZE_SOURCE_UTILITIES_DIR}
  "grad_check.py" 
  ${BINARY_PYTHON_DIR} 
  GRADIENT_CHECK_PYTHON_SCRIPT)

include(${COMMON_SOURCE_CMAKE_DIR}/mpi_helpers.cmake)
include(${ANALYZE_SOURCE_UTILITIES_DIR}/openmp_helpers.cmake)

add_subdirectory(functional)
