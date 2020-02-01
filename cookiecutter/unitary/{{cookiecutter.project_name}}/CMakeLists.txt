cmake_minimum_required(VERSION 3.14)
cmake_policy(VERSION 3.14)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/share/aleph/cmake)
include(AlephUtils)

aleph_default_project({{ cookiecutter.project_name }} "${CMAKE_CURRENT_SOURCE_DIR}/include/{{ cookiecutter.project_name }}/{{ cookiecutter.project_name }}.hpp")
aleph_default_options()
aleph_default_targets()

find_package(aleph_common CONFIG REQUIRED)
target_link_libraries(${ALEPH_TARGET_LIB} PUBLIC aleph_common)
aleph_enable_strict_warnings(${ALEPH_TARGET_LIB})

add_subdirectory(src)

aleph_default_test_and_install()
