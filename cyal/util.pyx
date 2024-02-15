# cython: language_level=3

from libc.stddef cimport size_t
from libc.string cimport strlen
from libc cimport math

from weakref import WeakKeyDictionary

from . cimport al, alc
from .exceptions cimport InvalidAlEnumError, UnsupportedExtensionError

class DefaultWeakKeyDictionary(WeakKeyDictionary):
    __slots__ = ["default_factory"]

    def __init__(self, default_factory, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.default_factory = default_factory
        
    def __getitem__(self, key):
        try:
            return super().__getitem__(key)
        except KeyError:
            new_val = self.default_factory()
            self[key] = new_val
            return new_val

cdef list alc_string_to_list(const alc.ALCchar* str):
    cdef:
        list specs = []
        size_t length
    while True:
        length = strlen(str)
        if length == 0:
            return specs
        specs.append(str[:length].decode("utf8"))
        str += length + 1

def get_device_specifiers():
    cdef const alc.ALCchar* specs = alc.alcGetString(NULL, alc.ALC_DEVICE_SPECIFIER)
    return alc_string_to_list(specs) if specs is not NULL else []

def get_default_device_specifier():
    cdef const alc.ALCchar* spec = alc.alcGetString(NULL, alc.ALC_DEFAULT_DEVICE_SPECIFIER)
    return spec.decode("utf8")

def get_all_device_specifiers(*, emulate=True):
    cdef alc.ALCenum enum_val = alc.alcGetEnumValue(NULL, b"ALC_ALL_DEVICES_SPECIFIER")
    cdef const alc.ALCchar *specs
    if enum_val != al.AL_NONE:
        specs = alc.alcGetString(NULL, enum_val)
        return alc_string_to_list(specs) if specs is not NULL else []
    elif emulate:
        return get_device_specifiers()
    else:
        raise UnsupportedExtensionError("ALC_ENUMERATE_ALL_EXT")

def get_default_all_device_specifier(*, emulate=True):
    cdef alc.ALCenum enum_val = alc.alcGetEnumValue(NULL, b"ALC_DEFAULT_ALL_DEVICES_SPECIFIER")
    cdef const alc.ALCchar *spec
    if enum_val != al.AL_NONE:
        spec = alc.alcGetString(NULL, enum_val)
        return spec.decode("utf8")
    elif emulate:
        return get_default_device_specifier()
    else:
        raise UnsupportedExtensionError("ALC_ENUMERATE_ALL_EXT")

def get_supported_extensions():
    cdef const alc.ALCchar* exts = alc.alcGetString(NULL, alc.ALC_EXTENSIONS)
    return exts.decode("utf8").split(' ') if exts is not NULL else []

def get_version():
    cdef alc.ALCint major, minor
    alc.alcGetIntegerv(NULL, alc.ALC_MAJOR_VERSION, 1, &major)
    alc.alcGetIntegerv(NULL, alc.ALC_MINOR_VERSION, 1, &minor)
    return (major, minor)

cdef class V3f:
    def __cinit__(self, x, y, z):
        self.data[0] = x
        self.data[1] = y
        self.data[2] = z

    def __repr__(self):
        return f"({self.data[0]}, {self.data[1]}, {self.data[2]})"

    def __getitem__(self, idx):
        if idx > 2:
            raise IndexError("vector index out of range")
        return self.data[idx]

    def __setitem__(self, idx, val):
        if idx > 2:
            raise IndexError("vector assignment index out of range")
        self.data[idx] = val

    @property
    def length(self):
        return math.hypot(math.hypot(self.data[0], self.data[1]), self.data[2])

    @property
    def x(self):
        return self.data[0]

    @x.setter
    def x(self, val):
        self.data[0] = val

    @property
    def y(self):
        return self.data[1]

    @y.setter
    def y(self, val):
        self.data[1] = val

    @property
    def z(self):
        return self.data[2]

    @z.setter
    def z(self, val):
        self.data[2] = val

cdef al.ALenum get_al_enum(str name):
    cdef str e_name = "AL_" + name.upper()
    cdef bytes e_name_bytes = e_name.encode("utf8")
    cdef al.ALenum val = al.alGetEnumValue(<const al.ALchar *>e_name_bytes)
    if val == al.AL_NONE:
        raise InvalidAlEnumError(name=e_name)
    return val
