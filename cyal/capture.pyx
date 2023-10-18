# cython: language_level=3

from contextlib import contextmanager

from .buffer cimport BufferFormat
from .exceptions cimport DeviceNotFoundError, UnsupportedExtensionError, check_alc_error
from .util cimport alc_string_to_list
from . cimport al, alc

cdef class CaptureExtension:
    def __cinit__(self):
        if alc.alcIsExtensionPresent(NULL, b"ALC_EXT_CAPTURE") == al.AL_FALSE:
            raise UnsupportedExtensionError("ALC_EXT_CAPTURE")
        self.DEFAULT_DEVICE_SPECIFIER = get_enum_value("ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER")
        self.DEVICE_SPECIFIER = get_enum_value("ALC_CAPTURE_DEVICE_SPECIFIER")
        self.SAMPLES = get_enum_value("ALC_CAPTURE_SAMPLES")

    @property
    def devices(self):
        cdef const alc.ALCchar* specs = alc.alcGetString(NULL, self.DEVICE_SPECIFIER)
        return alc_string_to_list(specs) if specs is not NULL else []

    @property
    def default_device(self):
        cdef const alc.ALCchar* spec = alc.alcGetString(NULL, self.DEFAULT_DEVICE_SPECIFIER)
        return spec if spec is not NULL else None

    def open_device(self, name=None, *, format=BufferFormat.MONO16, sample_rate=48000, buf_size=512):
        cdef alc.ALCdevice* dev = alc.alcCaptureOpenDevice(<const alc.ALCchar *>name if name is not None else NULL, sample_rate, int(format), buf_size)
        if dev is NULL:
            raise DeviceNotFoundError(device_name=name)

        cdef alc.ALCsizei bps
        if format == BufferFormat.MONO8: bps = 1
        elif format == BufferFormat.MONO16: bps = 2
        elif format == BufferFormat.STEREO8: bps = 2
        elif format == BufferFormat.STEREO16: bps = 4
        else: raise RuntimeError(f"Unknown frame size for format {format}")

        return CaptureDevice.from_device(self, dev, bps)

cdef class CaptureDevice:
    def __cinit__(self):
        pass

    @staticmethod
    cdef CaptureDevice from_device(CaptureExtension ext, alc.ALCdevice* dev, alc.ALCsizei bytes_per_sample):
        cdef CaptureDevice device = CaptureDevice.__new__(CaptureDevice)
        device.capture_extension = ext
        device._device = dev
        device.bytes_per_sample = bytes_per_sample
        return device

    def __dealloc__(self):
        alc.alcCaptureCloseDevice(self._device)

    def start(self):
        alc.alcCaptureStart(self._device)
        check_alc_error(self._device)

    def stop(self):
        alc.alcCaptureStop(self._device)
        check_alc_error(self._device)

    @contextmanager
    def capturing(self):
        alc.alcCaptureStart(self._device)
        check_alc_error(self._device)
        try:
            yield self
        finally:
            alc.alcCaptureStop(self._device)
            check_alc_error(self._device)

    def capture_samples(self, buf):
        cdef al.ALubyte[:] view = buf
        if view.size == 0: return
        alc.alcCaptureSamples(self._device, &view[0], view.size / self.bytes_per_sample)
        check_alc_error(self._device)

    @property
    def name(self):
        cdef const alc.ALCchar* spec = alc.alcGetString(self._device, self.capture_extension.DEVICE_SPECIFIER)
        return spec if spec is not NULL else None

    @property
    def available_samples(self):
        cdef al.ALint val
        alc.alcGetIntegerv(self._device, self.capture_extension.SAMPLES, 1, &val)
        return val

cdef alc.ALCenum get_enum_value(const alc.ALCchar* name):
    cdef alc.ALCenum val = alc.alcGetEnumValue(NULL, name)
    if val == al.AL_NONE:
        raise RuntimeError(f"Could not get enum value for {name}")
    return val
