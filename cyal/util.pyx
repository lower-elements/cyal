# cython: language_level=3

from libc.stddef cimport size_t
from libc.string cimport strlen
from libc cimport math

from . cimport al, alc
from .exceptions cimport InvalidAlEnumError

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
    cdef bytes e_name = b"AL_" + name.upper().encode("utf8")
    cdef al.ALenum val = al.alGetEnumValue(<const al.ALchar *>e_name)
    if val == al.AL_NONE:
        raise InvalidAlEnumError()
    return val
