#define NO_IMPORT_ARRAY
#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}.hpp>
#include <{{ cookiecutter.a_parent }}/{{ cookiecutter.a_child }}/python.hpp>

namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python {
    void init_module(py::module& m) {
        m.def("get_version", [](){
            int major = -1, minor = -1, patch = -1;
            get_version(&major, &minor, &patch);
            return py::make_tuple(major, minor, patch);
        });
    }
} // namespace {{ cookiecutter.a_parent }}::{{ cookiecutter.a_child }}::python