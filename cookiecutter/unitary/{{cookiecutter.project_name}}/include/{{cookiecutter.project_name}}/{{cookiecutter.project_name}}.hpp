#pragma once
#define {{ cookiecutter.project_name|upper }}_VERSION_MAJOR {{ cookiecutter.version.split('.')[0] }}
#define {{ cookiecutter.project_name|upper }}_VERSION_MINOR {{ cookiecutter.version.split('.')[1] }}
#define {{ cookiecutter.project_name|upper }}_VERSION_PATCH {{ cookiecutter.version.split('.')[2] }}

#include <aleph/common.hpp>

namespace {{ cookiecutter.project_name }} {

    void get_version(int* major, int* minor, int* patch);

} // namespace {{ cookiecutter.project_name }}
