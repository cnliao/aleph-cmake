find_package(doctest REQUIRED)

add_executable(main main.cpp lib.cpp)
target_link_libraries(main PRIVATE ${ALEPH_TARGET_LIB} doctest::doctest)
aleph_enable_strict_warnings(main)

add_test(NAME main COMMAND main)
