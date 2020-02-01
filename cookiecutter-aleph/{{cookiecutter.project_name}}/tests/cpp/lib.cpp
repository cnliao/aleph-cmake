#include <doctest/doctest.h>
#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}.hpp>

namespace {

using namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }};

TEST_SUITE_BEGIN("{{ cookiecutter.project_name }}");

TEST_CASE("get_version") {

    int major = -1, minor = -1, patch = -1;
    get_version(&major, &minor, &patch);
    CHECK(fmt::format("{}.{}.{}", major, minor, patch) == "{{ cookiecutter.version }}");
}

TEST_SUITE_END();  // aleph_common

}  // namespace
