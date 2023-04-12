# cython: language_level=3

from . cimport alc

cdef class CyalError(Exception):
    pass

cdef class DeviceNotFoundError(CyalError):
    cdef readonly bytes device_name

cdef class InvalidDeviceError(CyalError):
    pass

cdef class InvalidContextError(CyalError):
    pass

cdef class InvalidEnumError(CyalError):
    pass

cdef class InvalidValueError(CyalError):
    pass

cdef class UnknownContextError(CyalError):
    cdef readonly alc.ALCenum errcode

cdef raise_alc_error(alc.ALCdevice* dev)
