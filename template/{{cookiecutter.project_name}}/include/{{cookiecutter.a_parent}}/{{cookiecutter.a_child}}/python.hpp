#pragma once
#include <aleph/common/python.hpp>

namspace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python {
    namespace py = pybind11;
    init_module(py::module& m);
} // {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python