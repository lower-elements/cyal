# Cyal - Cython Wrapper for OpenAL

Cyal is a [Python][python] wrapper for [OpenAL][openal], a cross platform, 3D audio API built by Creative Labs. This
project aims to be compatible with any conforming OpenAL 1.1 implementation, but receives the most testing on [OpenAL
Soft][openal-soft]. It is written in [Cython][cython].

[python]: <https://python.org>
[openal]: <https://openal.org>
[openal-soft]: <https://openal-soft.org>
[cython]: <https://cython.org>

## Building from source

**Note**: Both the source Cython code (.pyx, .pxd files) and the Cython-generated code (.c files) are included in a
source distribution of this library, in order to facilitate building the library on systems without [Cython][cython]
installed. Be aware that if you do not have Cython installed, the generated .c files will instead be compiled).

Manual installation:

```bash
# Clone the repository
git clone https://git.sr.ht/~Thefake-vip/cyal
cd cyal
# Build the extension modules
python setup.py build_ext
# Create a binary distribution wheel
python setup.py bdist_wheel
# Run pip install with the generated .whl file in the dist directory
```

## Contributing

[This project][project-page] is hosted on [Sourcehut][srht]. Feel free to [submit a ticket][bug-tracker] if you find a
bug, or drop by our [mailing list][mailing-list] <~thefake-vip/cyal@lists.sr.ht> to discuss the project, or send
patches.

Never submitted patches via email before? Check out [Sourcehut's guide to using git send-email][git-send-email]!

[project-page]: <https://sr.ht/~thefake-vip/Cyal>
[srht]: <https://sr.ht>
[bug-tracker]: <https://todo.sr.ht/~thefake-vip/Cyal>
[mailing-list]: <https://lists.sr.ht/~thefake-vip/cyal>
[git-send-email]: <https://git-send-email.io>

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
