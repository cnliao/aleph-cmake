#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}.hpp>
#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}/python.hpp>
PYBIND11_MODULE(_{{ cookiecutter.project_name }}, m) {
    ALEPH_INIT_NUMPY_ARRAY_API;
    {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python::init_module(m);
}
