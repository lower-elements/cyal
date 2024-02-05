# Cyal - Cython Wrapper for OpenAL

[![PyPI version](https://badge.fury.io/py/cyal.svg)](https://badge.fury.io/py/cyal)
[![Build](https://github.com/lower-elements/cyal/actions/workflows/release.yml/badge.svg)](https://github.com/lower-elements/cyal/actions/workflows/release.yml)

Cyal is a [Python][python] wrapper for [OpenAL][openal], a cross platform, 3D audio API built by Creative Labs. This
project aims to be compatible with any conforming OpenAL 1.1 implementation, but receives the most testing on [OpenAL
Soft][openal-soft]. It is written in [Cython][cython].

[python]: <https://python.org>
[openal]: <https://openal.org>
[openal-soft]: <https://openal-soft.org>
[cython]: <https://cython.org>

## Installation


Install with pip, just as you would any Python package.

```sh
pip install cyal
```

Binary distributions are available for Windows, macOS and Linux, and include a bundled version of OpenAL Soft.

## Building from source

When building from source, CMake will try to detect an existing OpenAL implementation on your system, and will use that
if it finds one. If an OpenAL implementation isn't found, OpenAL Soft will be downloaded, compiled, and bundled with
Cyal.

Manual installation:

```bash
# Clone the repository
git clone https://github.com/lower-elements/cyal
cd cyal
# Install a simple wheel build tool
pip install build
# Build both the sdist and bdist (see the options to build if you only want to build one)
python -m build .
# Install the .whl file in the dist directory
```

## Contributing

[This project][project-page] is hosted on [Github][github]. Feel free to [submit an issue][issues] if you find a bug,
open a [pull request][pr] to contribute, or join our Matrix room, [#cyal:lowerelements.club][[matrix-room] for Cyal
discussion and support.

[project-page]: <https://github.com/lower-elements/cyal>
[github]: <https://github.com>
[issues]: <https://github.com/lower-elements/cyal/issues/new>
[pr]: <https://github.com/lower-elements/cyal/pull/new>
[matrix-room]: <https://matrix.to/#/#cyal:lowerelements.club>

## License

Cyal is licensed under the MIT License.

    MIT License

    Copyright (c) 2023 Michael Connor Buchan <mikey@blindcomputing.org>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
