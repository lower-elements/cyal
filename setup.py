#!/usr/bin/env python

from os import path
import sys

from setuptools import Extension, find_packages, setup

try:
    from Cython.Distutils import build_ext

    use_cython = True
except ImportError:
    from setuptools.command.build_ext import build_ext

    use_cython = False

ext = ".pyx" if use_cython else ".c"
ext_modules = [
    Extension("cyal.context", ["cyal/context" + ext]),
    Extension("cyal.device", ["cyal/device" + ext]),
    Extension("cyal.exceptions", ["cyal/exceptions" + ext]),
    Extension("cyal.listener", ["cyal/listener" + ext]),
    Extension("cyal.util", ["cyal/util" + ext]),
]

# Link to OpenAL
match sys.platform:
    case "linux":
        import pkgconfig

        for ex in ext_modules:
            pkgconfig.configure_extension(ex, "openal")
    case platform:
        printf(
            f"WARNING: Unimplemented platform {platform}, you'll need to link OpenAL yourself via CFLAGS and friends"
        )

here = path.abspath(path.dirname(__file__))

with open(path.join(here, "README.md"), encoding="utf-8") as f:
    long_description = "\n" + f.read()

about = {}
about_path = path.join(here, "cyal", "about.py")
with open(about_path) as f:
    exec(f.read(), about)

setup(
    name="cyal",
    version=about["__version__"],
    description=about["__doc__"],
    long_description=long_description,
    long_description_content_type="text/markdown",
    author=about["__author__"],
    author_email=about["__author_email__"],
    url="https://github.com/mcb2003/cyal",
    packages=find_packages(),
    package_data={
        "": ["LICENSE"],
    },
    cmdclass={"build_ext": build_ext},
    ext_modules=ext_modules,
    python_requires=">=3.10",
    zip_safe=False,
    setup_requires=[],
    install_requires=[],
    extras_require={},
    include_package_data=True,
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Operating System :: OS Independent",
    ],
)
