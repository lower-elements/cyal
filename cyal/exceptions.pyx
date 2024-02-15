# cython: language_level=3

from . cimport al, alc

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

cdef class InvalidAlcEnumError(AlcError):
    def __cinit__(self, *args, str name=None, **kwargs):
        self.enum_name = name

    @property
    def errcode(self):
        return alc.ALC_INVALID_ENUM

    def __str__(self):
        s = "Invalid OpenAL context enum value"
        if self.enum_name is not None:
            s += f": '{self.enum_name}'"
        return s

cdef class InvalidAlcValueError(AlcError):
    @property
    def errcode(self):
        return alc.ALC_INVALID_VALUE

    def __str__(self):
        return "Invalid OpenAL context parameter value"

cdef class UnknownAlcError(AlcError):
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
        raise InvalidAlcEnumError()
    elif errcode == alc.ALC_INVALID_VALUE:
        raise InvalidAlcValueError()
    elif errcode == alc.ALC_OUT_OF_MEMORY:
        raise MemoryError("OpenAL is out of memory")
    else:
        raise UnknownAlcError(alc_errcode=errcode)

cdef class AlError(CyalError):
    pass

cdef class InvalidNameError(AlError):
    @property
    def errcode(self):
        return al.AL_INVALID_NAME

    def __str__(self):
        cdef const al.ALchar* string = al.alGetString(al.AL_INVALID_NAME)
        return string.decode() if string is not NULL else "Invalid OpenAL object name"

cdef class InvalidOperationError(AlError):
    @property
    def errcode(self):
        return al.AL_INVALID_OPERATION

    def __str__(self):
        cdef const al.ALchar* string = al.alGetString(al.AL_INVALID_OPERATION)
        return string.decode() if string is not NULL else "Invalid OpenAL operation"

cdef class InvalidAlEnumError(AlError):
    def __cinit__(self, *args, str name=None, **kwargs):
        self.enum_name = name

    def __init__(self, *args, name: str=None, **kwargs):
        super().__init__(*args, **kwargs)

    @property
    def errcode(self):
        return al.AL_INVALID_ENUM

    def __str__(self):
        cdef const al.ALchar* string = al.alGetString(al.AL_INVALID_ENUM)
        s = string.decode() if string is not NULL else "Invalid OpenAL enum value"
        if self.enum_name is not None:
            s += f": '{self.enum_name}'"
        return s

cdef class InvalidAlValueError(AlError):
    @property
    def errcode(self):
        return al.AL_INVALID_VALUE

    def __str__(self):
        cdef const al.ALchar* string = al.alGetString(al.AL_INVALID_VALUE)
        return string.decode() if string is not NULL else "Invalid OpenAL parameter value"

cdef class UnknownAlError(AlError):
    def __cinit__(self, *args, al_errcode, **kwargs):
        self.errcode = al_errcode

    def __init__(self, *args, alc_errcode, **kwargs):
        super().__init__(*args)

    def __str__(self):
        cdef const al.ALchar* string = al.alGetString(self.errcode)
        return string.decode() if string is not NULL else f"Unknown OpenAL error (code {self.errcode:X})"

cdef check_al_error():
    cdef al.ALenum errcode = al.alGetError()
    if errcode == al.AL_NO_ERROR:
        return # Fast path
    elif errcode == al.AL_INVALID_NAME:
        raise InvalidNameError()
    elif errcode == al.AL_INVALID_ENUM:
        raise InvalidAlEnumError()
    elif errcode == al.AL_INVALID_VALUE:
        raise InvalidAlValueError()
    elif errcode == al.AL_INVALID_OPERATION:
        raise InvalidOperationError()
    elif errcode == al.AL_OUT_OF_MEMORY:
        raise MemoryError()
    else:
        raise UnknownAlError(al_errcode=errcode)

cdef class UnsupportedExtensionError(CyalError):
    def __cinit__(self, ext_name):
        self.extension_name = ext_name

    def __str__(self):
        return f"Unsupported OpenAL extension: {self.extension_name}"
