from libc.stddef cimport size_t
from libc.string cimport strlen
from . cimport al, alc

cdef class Device:
    cdef alc.ALCdevice* _device
    
    def __cinit__(self, name = None):
        self._device = alc.alcOpenDevice(<const alc.ALCchar *>name if name is not None else NULL)
        if self._device is NULL:
            raise RuntimeError("Could not create ALCdevice")
    
    def __dealloc__(self):
        if self._device is not NULL:
            alc.alcCloseDevice(self._device)

    @property
    def name(self):
        return <bytes>alc.alcGetString(self._device, alc.ALC_DEVICE_SPECIFIER)

    cpdef get_supported_extensions(self):
        return (<bytes>alc.alcGetString(self._device, alc.ALC_EXTENSIONS)).split(b' ')

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
