#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}.hpp>

namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }} {

    void get_version(int* major, int* minor, int* patch) {
        *major = {{ cookiecutter.project_name|upper }}_VERSION_MAJOR;
        *minor = {{ cookiecutter.project_name|upper }}_VERSION_MINOR;
        *patch = {{ cookiecutter.project_name|upper }}_VERSION_PATCH;
    }

} // namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}