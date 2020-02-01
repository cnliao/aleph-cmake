from setuptools import setup, find_namespace_packages
import sys
from glob import glob

setup(
    name="{{ cookiecutter.a_parent }}.{{ cookiecutter.a_child }}",
    version="{{ cookiecutter.version }}",
    package_dir={"": "python"},
    packages=find_namespace_packages(where="python"),
    data_files=[
        (
            f"lib/python{sys.version_info.major}.{sys.version_info.minor}/site-packages",
            list(glob("python/*.so")),
        )
    ],
)
