from {{ cookiecutter.a_parent }}.{{ cookiecutter.a_child }} import get_version

def test_1():
    ver_tup = get_version()
    ver_str = "{}.{}.{}".format(*ver_tup)
    assert ver_str == "{{ cookiecutter.version }}"