cmake_minimum_required(VERSION 3.24)

project(${SKBUILD_PROJECT_NAME}
	VERSION ${SKBUILD_PROJECT_VERSION}
	LANGUAGES C
	)

find_package(Python COMPONENTS Interpreter Development.Module REQUIRED)
find_program(CYTHON "cython")

include(FetchContent)

# Download the OpenAL Soft external project if a system version isn't found
FetchContent_Declare(OpenAL
	URL https://openal-soft.org/openal-releases/openal-soft-1.23.1.tar.bz2
	TLS_VERIFY ON
	DOWNLOAD_EXTRACT_TIMESTAMP true
	install_command ""
	FIND_PACKAGE_ARGS NAMES OpenAL
)
# OpenAL build options
set(ALSOFT_UTILS OFF CACHE INTERNAL "ALSOFT_UTILS")
set(ALSOFT_NO_CONFIG_UTIL ON CACHE INTERNAL "ALSOFT_NO_CONFIG_UTIL")
set(ALSOFT_EXAMPLES OFF CACHE INTERNAL "ALSOFT_EXAMPLES")
set(ALSOFT_INSTALL OFF CACHE INTERNAL "ALSOFT_INSTALL")
set(ALSOFT_INSTALL_CONFIG OFF CACHE INTERNAL "ALSOFT_INSTALL_CONFIG")
set(ALSOFT_INSTALL_HRTF_DATA OFF CACHE INTERNAL "ALSOFT_INSTALL_HRTF_DATA")
set(ALSOFT_INSTALL_AMBDEC_PRESETS OFF CACHE INTERNAL "ALSOFT_INSTALL_AMBDEC_PRESETS")
FetchContent_MakeAvailable(OpenAL)


foreach(module buffer capture context device efx exceptions listener source util)
    # Transpile Cython to C
add_custom_command(
	OUTPUT ${module}.c
	DEPENDS ${SKBUILD_PROJECT_NAME}/${module}.pyx
  VERBATIM
  COMMAND "${CYTHON}" "${CMAKE_CURRENT_SOURCE_DIR}/${SKBUILD_PROJECT_NAME}/${module}.pyx" --output-file
  "${CMAKE_CURRENT_BINARY_DIR}/${module}.c")
  # Compile the C to a shared library
python_add_library(${module} MODULE WITH_SOABI "${CMAKE_CURRENT_BINARY_DIR}/${module}.c")
target_link_libraries(${module} PRIVATE OpenAL::OpenAL)

# If we're building bundled OpenAL Soft, set the rpath correctly
if(TARGET OpenAL)
    if(LINUX)
    set_target_properties(${module} PROPERTIES INSTALL_RPATH "$ORIGIN")
elseif(APPLE)
    set_target_properties(${module} PROPERTIES INSTALL_RPATH "@loader_path")
endif()
endif()

install(TARGETS ${module} LIBRARY DESTINATION ${SKBUILD_PROJECT_NAME})
endforeach()

if(TARGET OpenAL)
install(TARGETS OpenAL DESTINATION ${SKBUILD_PROJECT_NAME})
endif()
