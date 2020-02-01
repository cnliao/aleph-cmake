#pragma once
#include <aleph/common/python.hpp>

namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python {
    namespace py = pybind11;
    void init_module(py::module& m);
} // {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python