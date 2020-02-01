#include <{{ cookiecutter.project_name }}/{{ cookiecutter.project_name }}.hpp>

namespace {{ cookiecutter.project_name }} {

    void get_version(int* major, int* minor, int* patch) {
        *major = {{ cookiecutter.project_name|upper }}_VERSION_MAJOR;
        *minor = {{ cookiecutter.project_name|upper }}_VERSION_MINOR;
        *patch = {{ cookiecutter.project_name|upper }}_VERSION_PATCH;
    }

} // namespace {{ cookiecutter.project_name }}
