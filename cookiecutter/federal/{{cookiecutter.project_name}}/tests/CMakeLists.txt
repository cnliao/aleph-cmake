add_subdirectory(cpp)
add_test(NAME pytest
  COMMAND ${Python3_EXECUTABLE} -m pytest ${CMAKE_CURRENT_LIST_DIR}/python
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/python)
add_custom_target(pytest
  COMMAND ${Python3_EXECUTABLE}  -m pytest -s ${CMAKE_CURRENT_LIST_DIR}/python
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/python)
