# cython: language_level=3

from . cimport alc

cdef class Device:
    cdef alc.ALCdevice* _device
    cpdef get_supported_extensions(self)
