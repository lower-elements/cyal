from . cimport alc

cdef class Device:
    cdef alc.ALCdevice* _device
    cpdef get_supported_extensions(self)

cdef list alc_string_to_list(const alc.ALCchar* str)
