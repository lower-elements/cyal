# cython: language_level=3

from . cimport alc

cdef class CyalError(Exception):
    pass

cdef class AlcError(CyalError):
    pass

cdef class DeviceNotFoundError(AlcError):
    cdef readonly bytes device_name

cdef class InvalidDeviceError(AlcError):
    pass

cdef class InvalidContextError(AlcError):
    pass

cdef class InvalidEnumError(AlcError):
    pass

cdef class InvalidValueError(AlcError):
    pass

cdef class UnknownContextError(AlcError):
    cdef readonly alc.ALCenum errcode

cdef check_alc_error(alc.ALCdevice* dev)
