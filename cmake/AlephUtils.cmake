macro(aleph_extract_version)
  if(${ARGC} GREATER 0)
    set(name ${ARGV0})
  else()
    message(FATAL_ERROR "aleph_extract_version requires one or more arguments")
  endif()
  if(${ARGC} GREATER 1)
    set(ALEPH_VERSION_HEADER ${ARGV1})
  else()
    string(REPLACE "_" "/" a ${name})
    string(JOIN "" a ${CMAKE_CURRENT_SOURCE_DIR}/include/ ${a} ".hpp")
    set(ALEPH_VERSION_HEADER ${a})
  endif()
  set(ALEPH_VERSION_PREFIX "")
  if(${ARGC} GREATER 2)
    set(ALEPH_VERSION_PREFIX ${ARGV2})
  else()
    string(TOUPPER ${name} ALEPH_VERSION_PREFIX)
  endif()
  if(NOT EXISTS ${ALEPH_VERSION_HEADER})
    message(FATAL_ERROR "aleph_extract_version trys to read nonexistant version header ${ALEPH_VERSION_HEADER}.")
  endif()
  set(lines "")
  file(STRINGS "${ALEPH_VERSION_HEADER}" lines REGEX "#define ${ALEPH_VERSION_PREFIX}_VERSION_(MAJOR|MINOR|PATCH) ")
  foreach(ver ${lines})
    if(ver MATCHES "#define ${ALEPH_VERSION_PREFIX}_VERSION_(MAJOR|MINOR|PATCH) +([^ ]+)$")
      set(ALEPH_INFERRED_${CMAKE_MATCH_1} "${CMAKE_MATCH_2}")
    endif()
  endforeach()
  set(ALEPH_INFERRED_VERSION "${ALEPH_INFERRED_MAJOR}.${ALEPH_INFERRED_MINOR}.${ALEPH_INFERRED_PATCH}")
  string(REPLACE "." ";" a ${ALEPH_INFERRED_VERSION})
  list(LENGTH a a)
  if(NOT a EQUAL 3)
    message(FATAL_ERROR "aleph_extract_version inferred malformed version string ${ALEPH_INFERRED_VERSION}.")
  endif()
endmacro()

macro(aleph_default_project)
  aleph_extract_version(${ARGV})
  project(${ARGV0} VERSION ${ALEPH_INFERRED_VERSION})
endmacro()

macro(aleph_default_options)
  option(ALEPH_TEST "If ON, tests will be run." ON)
  option(ALEPH_INSTALL "If ON, will install." ON)
  option(ALEPH_PYTHON "If ON, will build python binding." ON)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "")
  set(CMAKE_CXX_STANDARD 17 CACHE STRING "")
  set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE BOOL "")
  set(CMAKE_C_STANDARD 11 CACHE STRING "")
  set(CMAKE_C_STANDARD_REQUIRED ON CACHE BOOL "")
  if(${ALEPH_PYTHON})
    set(PYBIND11_PYTHON_VERSION 3.7 CACHE STRING "")
    set(PYBIND11_CPP_STANDARD -std=c++1z CACHE STRING "")
    find_package(pybind11 CONFIG REQUIRED)
    find_package(Python3 REQUIRED COMPONENTS Interpreter Development NumPy)
  endif()
  find_program(CCACHE_PROGRAM ccache)
  if(CCACHE_PROGRAM)
    set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
    set(CMAKE_CUDA_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
  endif()
endmacro()

macro(aleph_default_target_lib)
  set(ALEPH_TARGET_LIB "${PROJECT_NAME}")
  add_library(${ALEPH_TARGET_LIB} "")
  target_include_directories(${ALEPH_TARGET_LIB}
    PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PUBLIC $<INSTALL_INTERFACE:include>)
endmacro()

macro(aleph_default_target_pyext)
  set(ALEPH_TARGET_PYEXT "_${PROJECT_NAME}")
  pybind11_add_module(${ALEPH_TARGET_PYEXT} "")
  target_link_libraries(${ALEPH_TARGET_PYEXT} PRIVATE ${ALEPH_TARGET_LIB})
  set_target_properties(${ALEPH_TARGET_PYEXT}
    PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/python)
endmacro()

macro(aleph_default_target_pypkg)
  add_custom_target(pydev
    COMMAND python3 setup.py develop --prefix=${CMAKE_INSTALL_PREFIX}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
  add_custom_target(pyundev
    COMMAND python3 setup.py develop --prefix=${CMAKE_INSTALL_PREFIX} -u
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
endmacro()

macro(aleph_default_targets)
  aleph_default_target_lib()
  set(ALEPH_EXPORT_TARGETS ${ALEPH_TARGET_LIB})
  if(${ALEPH_PYTHON})
    target_link_libraries(${ALEPH_TARGET_LIB} PUBLIC pybind11::module Python3::NumPy)
    aleph_default_target_pyext()
    aleph_default_target_pypkg()
  endif()
endmacro()

macro(aleph_default_test_and_install)
  if(${ALEPH_TEST})
    enable_testing()
    add_subdirectory(tests)
  endif()
  if(${ALEPH_INSTALL})
    include(GNUInstallDirs)
    include(CMakePackageConfigHelpers)
    set(ALEPH_CMAKE_FILES_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/${ALEPH_TARGET_LIB})
    set(ALEPH_TARGETS_EXPORT_NAME ${ALEPH_TARGET_LIB}-targets)
    set(ALEPH_VERSION_CONFIG ${ALEPH_TARGET_LIB}-version.cmake)
    set(ALEPH_PROJECT_CONFIG ${ALEPH_TARGET_LIB}-config.cmake)
    set(ALEPH_PROJECT_CONFIG_IN ${CMAKE_CURRENT_SOURCE_DIR}/config.cmake.in)
    write_basic_package_version_file("${ALEPH_VERSION_CONFIG}" COMPATIBILITY SameMinorVersion)
    configure_package_config_file(
      ${ALEPH_PROJECT_CONFIG_IN}
      ${ALEPH_PROJECT_CONFIG}
      INSTALL_DESTINATION ${ALEPH_CMAKE_FILES_INSTALL_DIR})
    install(TARGETS ${ALEPH_EXPORT_TARGETS} EXPORT ${ALEPH_TARGETS_EXPORT_NAME})
    export(EXPORT ${ALEPH_TARGETS_EXPORT_NAME})
    install(EXPORT ${ALEPH_TARGETS_EXPORT_NAME} DESTINATION ${ALEPH_CMAKE_FILES_INSTALL_DIR})
    install(FILES 
      ${CMAKE_CURRENT_BINARY_DIR}/${ALEPH_PROJECT_CONFIG}
      ${CMAKE_CURRENT_BINARY_DIR}/${ALEPH_VERSION_CONFIG} 
      DESTINATION ${ALEPH_CMAKE_FILES_INSTALL_DIR})
    install(DIRECTORY include/
      TYPE INCLUDE 
      FILES_MATCHING PATTERN "*.hpp")
    if(${ALEPH_PYTHON})
      aleph_get_python_package_name(ALEPH_TARGET_PYPKG)
      add_custom_target(pyinstall
        COMMAND python3 -m pip install -U --prefix=${CMAKE_INSTALL_PREFIX} .
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
      add_custom_target(pyuninstall
        COMMAND python3 -m pip uninstall ${ALEPH_TARGET_PYPKG} -y
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} VERBATIM)
    endif()
    if(NOT TARGET uninstall)
      configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)
      add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
    endif()
  endif()
endmacro()

function(aleph_enable_strict_warnings target_name)
  set(w_flags -Werror -Wall -Wextra -Wno-unused-parameter -Wno-reorder -Wpedantic -Wfatal-errors -Wno-sign-compare)
  list(APPEND w_flags -Wconversion)
  target_compile_options(${target_name} PRIVATE ${w_flags})
endfunction()

function(aleph_get_python_package_name OUTVAR)
  execute_process(COMMAND ${Python3_EXECUTABLE} setup.py --name
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE retval
    OUTPUT_VARIABLE retstr)
  if("${retval}" STREQUAL 0)
    string(STRIP ${retstr} retstr)
    set(${OUTVAR} ${retstr} PARENT_SCOPE)
  else()
    message(FATAL_ERROR "aleph: cannot get python package name")
  endif()
endfunction()
