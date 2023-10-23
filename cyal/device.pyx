# cython: language_level=3

from contextlib import contextmanager

from .context cimport ContextAttrs
from .exceptions cimport DeviceNotFoundError, UnsupportedExtensionError, check_alc_error
from . cimport al, alc

cdef class Device:
    def __cinit__(self, name=None, *, pause_noop=False, emulate_enumerate_all=True):
        cdef bytes name_bytes = name.encode("utf8") if name is not None else b''
        self._device = alc.alcOpenDevice(<const alc.ALCchar*>name_bytes if name is not None else NULL)
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
        self.alc_reset_device_soft = <alc.ALCboolean (*)(alc.ALCdevice*, alc.ALCint*)>self.get_alc_proc_address(b"alcResetDeviceSOFT")
        self.alc_reopen_device_soft = <alc.ALCboolean (*)(alc.ALCdevice*, const alc.ALCchar*, alc.ALCint*)>self.get_alc_proc_address(b"alcReopenDeviceSOFT")

        # Flags for extension emulation
        self.emulate_enumerate_all = emulate_enumerate_all
    
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
        return alc.alcGetString(self._device, alc.ALC_DEVICE_SPECIFIER).decode("utf8")

    @property
    def output_name(self):
        cdef alc.ALCenum enum_val = alc.alcGetEnumValue(NULL, b"ALC_ALL_DEVICES_SPECIFIER")
        cdef const alc.ALCchar *spec
        if enum_val != al.AL_NONE:
            spec = alc.alcGetString(self._device, enum_val)
            return spec.decode("utf8")
        elif self.emulate_enumerate_all:
            return self.name
        else:
            raise UnsupportedExtensionError("ALC_ENUMERATE_ALL_EXT")

    @property
    def version(self):
        cdef alc.ALCint major, minor
        alc.alcGetIntegerv(self._device, alc.ALC_MAJOR_VERSION, 1, &major)
        alc.alcGetIntegerv(self._device, alc.ALC_MINOR_VERSION, 1, &minor)
        return (major, minor)

    def reset(self, **kwargs):
        if self.alc_reopen_device_soft is NULL:
            raise UnsupportedExtensionError("ALC_SOFT_HRTF or ALC_SOFT_OUTPUT_LIMITER")
        cdef ContextAttrs attrs = ContextAttrs.from_kwargs(self, **kwargs)
        cdef alc.ALCboolean res = self.alc_reset_device_soft(self._device, &attrs._attrs[0])
        if res != al.AL_TRUE:
            check_alc_error(self._device)

    def reopen(self, name=None, **kwargs):
        if self.alc_reopen_device_soft is NULL:
            raise UnsupportedExtensionError("ALC_SOFT_REOPEN_DEVICE")
        cdef bytes name_bytes = name.encode("utf8") if name is not None else b''
        cdef ContextAttrs attrs = ContextAttrs.from_kwargs(self, **kwargs)
        cdef alc.ALCboolean res = self.alc_reopen_device_soft(self._device, <const alc.ALCchar*>name_bytes, &attrs._attrs[0])
        if res != al.AL_TRUE:
            check_alc_error(self._device)

    cpdef list get_supported_extensions(self):
        return alc.alcGetString(self._device, alc.ALC_EXTENSIONS).decode("utf8").split(' ')

    def is_extension_present(self, ext):
        return alc.alcIsExtensionPresent(self._device, <const alc.ALCchar *>ext) == al.AL_TRUE

    cdef alc.ALCenum get_enum_value(self, const alc.ALCchar* name):
        cdef alc.ALCenum val = alc.alcGetEnumValue(self._device, name)
        if val == al.AL_NONE:
            raise RuntimeError(f"Could not get enum value for {name}")
        return val

cdef void no_pause_device_ext(alc.ALCdevice* dev):
    raise UnsupportedExtensionError("ALC_SOFT_PAUSE_DEVICE")

cdef void do_nothing_with_device(alc.ALCdevice* dev): pass
