#pragma once
#include <aleph/common/python.hpp>

namespace {{ cookiecutter.project_name }}::python {
    namespace py = pybind11;
    void init_module(py::module& m);
} // {{ cookiecutter.project_name }}::python
