from {{ cookiecutter.project_name }} import get_version

def test_1():
    ver_tup = get_version()
    ver_str = "{}.{}.{}".format(*ver_tup)
    assert ver_str == "{{ cookiecutter.version }}"
