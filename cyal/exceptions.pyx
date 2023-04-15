# cython: language_level=3

from . cimport alc

cdef class CyalError(Exception):
    pass

cdef class AlcError(CyalError):
    pass

cdef class DeviceNotFoundError(AlcError):
    def __cinit__(self, *args, **kwargs):
        self.device_name = kwargs.get("device_name", None)

    def __init__(self, *args, **kwargs):
        super().__init__(*args)

    def __str__(self):
        if self.device_name is None:
            return "No OpenAL devices found"
        else:
            return f"OpenAL device {self.device_name} not found"

cdef class InvalidDeviceError(AlcError):
    @property
    def errcode(self):
        return alc.ALC_INVALID_DEVICE

    def __str__(self):
        return "Invalid OpenAL device"

cdef class InvalidContextError(AlcError):
    @property
    def errcode(self):
        return alc.ALC_INVALID_CONTEXT

    def __str__(self):
        return "Invalid OpenAL context"

cdef class InvalidEnumError(AlcError):
    @property
    def errcode(self):
        return alc.ALC_INVALID_ENUM

    def __str__(self):
        return "Invalid OpenAL enum value"

cdef class InvalidValueError(AlcError):
    @property
    def errcode(self):
        return alc.ALC_INVALID_VALUE

    def __str__(self):
        return "Invalid OpenAL parameter value"

cdef class UnknownContextError(AlcError):
    def __cinit__(self, *args, alc_errcode, **kwargs):
        self.errcode = alc_errcode

    def __init__(self, *args, alc_errcode, **kwargs):
        super().__init__(*args)

    def __str__(self):
        return f"Unknown OpenAL context error (code {self.errcode:X})"

cdef check_alc_error(alc.ALCdevice *dev):
    cdef alc.ALCenum errcode = alc.alcGetError(dev)
    if errcode == alc.ALC_NO_ERROR:
        return # Fast path
    elif errcode == alc.ALC_INVALID_DEVICE:
        raise InvalidDeviceError()
    elif errcode == alc.ALC_INVALID_CONTEXT:
        raise InvalidContextError()
    elif errcode == alc.ALC_INVALID_ENUM:
        raise InvalidEnumError()
    elif errcode == alc.ALC_INVALID_VALUE:
        raise InvalidValueError()
    elif errcode == alc.ALC_OUT_OF_MEMORY:
        raise MemoryError()
    else:
        raise UnknownContextError(alc_errcode=errcode)
