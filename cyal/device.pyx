from .exceptions import DeviceNotFoundError

from . cimport al, alc

cdef class Device:
    def __cinit__(self, name = None):
        self._device = alc.alcOpenDevice(<const alc.ALCchar *>name if name is not None else NULL)
        if self._device is NULL:
            raise DeviceNotFoundError(device_name=name)
    
    def __dealloc__(self):
        if self._device is not NULL:
            alc.alcCloseDevice(self._device)

    @property
    def name(self):
        return <bytes>alc.alcGetString(self._device, alc.ALC_DEVICE_SPECIFIER)

    cpdef get_supported_extensions(self):
        return (<bytes>alc.alcGetString(self._device, alc.ALC_EXTENSIONS)).split(b' ')

    def is_extension_present(self, ext):
        return alc.alcIsExtensionPresent(self._device, <const alc.ALCchar *>ext) == al.AL_TRUE
