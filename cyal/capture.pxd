# cython: language_level=3

from . cimport alc

cdef class CaptureExtension:
    cdef object __weakref__
    cdef alc.ALCenum DEFAULT_DEVICE_SPECIFIER
    cdef alc.ALCenum DEVICE_SPECIFIER
    cdef alc.ALCenum SAMPLES

cdef class CaptureDevice:
    cdef object __weakref__
    cdef readonly CaptureExtension capture_extension
    cdef alc.ALCdevice* _device
    cdef alc.ALCsizei bytes_per_sample

    @staticmethod
    cdef CaptureDevice from_device(CaptureExtension, alc.ALCdevice*, alc.ALCsizei)
