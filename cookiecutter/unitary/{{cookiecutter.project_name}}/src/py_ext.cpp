#include <{{ cookiecutter.project_name }}/{{ cookiecutter.project_name }}.hpp>
#include <{{ cookiecutter.project_name }}/python.hpp>
PYBIND11_MODULE(_{{ cookiecutter.project_name }}, m) {
    ALEPH_INIT_NUMPY_ARRAY_API;
    {{ cookiecutter.project_name }}::python::init_module(m);
}
