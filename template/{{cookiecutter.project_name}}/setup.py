from setuptools import setup, find_namespace_packages
import sys
from glob import glob

setup(
    name="aleph.common",
    version="0.1.0",
    package_dir={"": "python"},
    packages=find_namespace_packages(where="python"),
    data_files=[
        (
            f"lib/python{sys.version_info.major}.{sys.version_info.minor}/site-packages",
            list(glob("python/*.so")),
        )
    ],
)
