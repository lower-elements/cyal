# cython: language_level=3

from . cimport al, alc

cdef class Device:
    cdef alc.ALCdevice* _device
    cdef al.ALvoid* (*get_al_proc_address)(const al.ALchar*)
    cdef void (*pause_soft)(alc.ALCdevice*)
    cdef void (*resume_soft)(alc.ALCdevice*)

    cdef alc.ALCenum get_enum_value(self, const alc.ALCchar* name)
    cdef inline alc.ALCvoid* get_alc_proc_address(self, const alc.ALCchar *funcname):
        return alc.alcGetProcAddress(self._device, funcname)

    cpdef list get_supported_extensions(self)
