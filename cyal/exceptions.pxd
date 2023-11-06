# cython: language_level=3

from . cimport al, alc

cdef class CyalError(Exception):
    pass

# ALC_* errors

cdef class AlcError(CyalError):
    pass

cdef class DeviceNotFoundError(AlcError):
    cdef readonly bytes device_name

cdef class InvalidDeviceError(AlcError):
    pass

cdef class InvalidContextError(AlcError):
    pass

cdef class InvalidAlcEnumError(AlcError):
    cdef readonly str enum_name

cdef class InvalidAlcValueError(AlcError):
    pass

cdef class UnknownAlcError(AlcError):
    cdef readonly alc.ALCenum errcode

cdef check_alc_error(alc.ALCdevice* dev)

# AL_* errors

cdef class AlError(CyalError):
    pass

cdef class InvalidNameError(AlError):
    pass

cdef class InvalidOperationError(AlError):
    pass

cdef class InvalidAlEnumError(AlError):
    cdef readonly str enum_name

cdef class InvalidAlValueError(AlError):
    pass

cdef class UnknownAlError(AlError):
    cdef readonly al.ALenum errcode

cdef check_al_error()

# Cyal-specific errors

cdef class UnsupportedExtensionError(CyalError):
    cdef readonly str extension_name
