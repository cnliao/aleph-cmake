#define NO_IMPORT_ARRAY
#include <{{ cookiecutter.project_name }}/{{ cookiecutter.project_name }}.hpp>
#include <{{ cookiecutter.project_name }}/python.hpp>

namespace {{ cookiecutter.project_name }}::python {
    void init_module(py::module& m) {
        m.def("get_version", [](){
            int major = -1, minor = -1, patch = -1;
            get_version(&major, &minor, &patch);
            return py::make_tuple(major, minor, patch);
        });
    }
} // namespace {{ cookiecutter.project_name }}::python
