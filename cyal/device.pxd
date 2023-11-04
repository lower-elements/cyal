# cython: language_level=3

from . cimport al, alc

cdef class Device:
    cdef object __weakref__
    cdef alc.ALCdevice* _device
    cdef al.ALvoid* (*get_al_proc_address)(const al.ALchar*)
    cdef void (*pause_soft)(alc.ALCdevice*)
    cdef void (*resume_soft)(alc.ALCdevice*)
    cdef alc.ALCboolean (*alc_reset_device_soft)(alc.ALCdevice* device, const alc.ALCint* attribs)
    cdef alc.ALCboolean (*alc_reopen_device_soft)(alc.ALCdevice* device, const alc.ALCchar* name, const alc.ALCint* attribs)

    # Flags for extension emulation
    cdef bint emulate_enumerate_all

    cdef alc.ALCenum get_enum_value(self, const alc.ALCchar* name)
    cdef inline alc.ALCvoid* get_alc_proc_address(self, const alc.ALCchar *funcname):
        return alc.alcGetProcAddress(self._device, funcname)

    cpdef list get_supported_extensions(self)
