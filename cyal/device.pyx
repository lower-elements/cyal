# cython: language_level=3

from contextlib import contextmanager

from .exceptions import DeviceNotFoundError
from . cimport al, alc

cdef class Device:
    def __cinit__(self, name=None, *, pause_noop=False):
        self._device = alc.alcOpenDevice(<const alc.ALCchar *>name if name is not None else NULL)
        if self._device is NULL:
            raise DeviceNotFoundError(device_name=name)
        self.get_al_proc_address = <al.ALvoid*(*)(const al.ALchar*)>self.get_alc_proc_address("alGetProcAddress")
        if alc.alcIsExtensionPresent(self._device, "ALC_SOFT_PAUSE_DEVICE") == al.AL_TRUE:
            self.pause_soft = <void (*)(alc.ALCdevice*)>self.get_alc_proc_address("alcDevicePauseSOFT")
            self.resume_soft = <void (*)(alc.ALCdevice*)>self.get_alc_proc_address("alcDeviceResumeSOFT")
        elif pause_noop:
            self.pause_soft = do_nothing_with_device
            self.resume_soft = do_nothing_with_device
        else:
            self.pause_soft = no_pause_device_ext
            self.resume_soft = no_pause_device_ext
    
    def __dealloc__(self):
        if self._device is not NULL:
            alc.alcCloseDevice(self._device)

    def pause(self):
        self.pause_soft(self._device)

    def resume(self):
        self.resume_soft(self._device)

    @contextmanager
    def paused(self):
        self.pause_soft(self._device)
        try:
            yield self
        finally:
            self.resume_soft(self._device)

    @contextmanager
    def playing(self):
        self.resume_soft(self._device)
        try:
            yield self
        finally:
            self.pause_soft(self._device)

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

    cdef alc.ALCenum get_enum_value(self, const alc.ALCchar* name):
        cdef alc.ALCenum val = alc.alcGetEnumValue(self._device, name)
        if val == al.AL_NONE:
            raise RuntimeError(f"Could not get enum value for {name}")
        return val

cdef void no_pause_device_ext(alc.ALCdevice* dev):
    raise RuntimeError("`ALC_SOFT_PAUSE_DEVICE` extension not implemented")

cdef void do_nothing_with_device(alc.ALCdevice* dev): pass
