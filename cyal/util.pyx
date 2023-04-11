# cython: language_level=3

from libc.stddef cimport size_t
from libc.string cimport strlen

from . cimport alc

cdef list alc_string_to_list(const alc.ALCchar* str):
    cdef:
        list specs = []
        size_t length
    while True:
        length = strlen(str)
        if length == 0:
            return specs
        specs.append(<bytes>str[:length])
        str += length + 1

def get_device_specifiers():
    cdef const alc.ALCchar* specs = alc.alcGetString(NULL, alc.ALC_DEVICE_SPECIFIER)
    return alc_string_to_list(specs) if specs is not NULL else []

def get_supported_extensions():
    cdef const alc.ALCchar* exts = alc.alcGetString(NULL, alc.ALC_EXTENSIONS)
    return (<bytes>exts).split(b' ') if exts is not NULL else []

def get_version():
    cdef alc.ALCint major, minor
    alc.alcGetIntegerv(NULL, alc.ALC_MAJOR_VERSION, 1, &major)
    alc.alcGetIntegerv(NULL, alc.ALC_MINOR_VERSION, 1, &minor)
    return (major, minor)
