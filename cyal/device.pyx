# cython: language_level=3

from .exceptions import DeviceNotFoundError

from . cimport al, alc

cdef class Device:
    def __cinit__(self, name = None):
        self._device = alc.alcOpenDevice(<const alc.ALCchar *>name if name is not None else NULL)
        if self._device is NULL:
            raise DeviceNotFoundError(device_name=name)
        self.get_al_proc_address = <al.ALvoid*(*)(const al.ALchar*)>self.get_alc_proc_address("alGetProcAddress")
    
    def __dealloc__(self):
        if self._device is not NULL:
            alc.alcCloseDevice(self._device)

    @property
    def name(self):
        return <bytes>alc.alcGetString(self._device, alc.ALC_DEVICE_SPECIFIER)

    @property
    def version(self):
        cdef alc.ALCint major, minor
        alc.alcGetIntegerv(self._device, alc.ALC_MAJOR_VERSION, 1, &major)
        alc.alcGetIntegerv(self._device, alc.ALC_MINOR_VERSION, 1, &minor)
        return (major, minor)

    cpdef list get_supported_extensions(self):
        return (<bytes>alc.alcGetString(self._device, alc.ALC_EXTENSIONS)).split(b' ')

    def is_extension_present(self, ext):
        return alc.alcIsExtensionPresent(self._device, <const alc.ALCchar *>ext) == al.AL_TRUE
