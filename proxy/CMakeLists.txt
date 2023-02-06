include( ${CMAKE_CURRENT_SOURCE_DIR}/../utilities/cmake/tools.cmake )

Copy_cmake_utilities_to_binary_dir()

# Copy python utilities to binary directory
set(SOURCE_PYTHON_DIR "../utilities/python")
set(BINARY_PYTHON_DIR "utilities/python")

set(GRADIENT_CHECK_PYTHON_SCRIPT "confirm_gradient_convergence_trend.py")
configure_file("${SOURCE_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}" "${BINARY_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}" COPYONLY)
set(GRADIENT_CHECK_PYTHON_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/${BINARY_PYTHON_DIR}/${GRADIENT_CHECK_PYTHON_SCRIPT}")

add_subdirectory(gradient_check)
add_subdirectory(regression)
add_subdirectory(serialized)
