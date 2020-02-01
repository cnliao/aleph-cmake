from setuptools import setup, find_packages
import sys
from glob import glob

setup(
    name="{{ cookiecutter.project_name }}",
    version="{{ cookiecutter.version }}",
    package_dir={"": "python"},
    packages=find_packages(where="python"),
    data_files=[
        (
            f"lib/python{sys.version_info.major}.{sys.version_info.minor}/site-packages",
            list(glob("python/*.so")),
        )
    ],
)
