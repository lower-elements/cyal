# cython: language_level=3

from . cimport alc
from .device cimport Device

cdef class HrtfExtension:
    cdef object __weakref__
    cdef readonly Device device

    # Function pointers
    cdef const alc.ALCchar *(*alc_get_string_i_soft)(alc.ALCdevice *device, alc.ALCenum paramName, alc.ALCsizei index)

    # Enum values
    cdef alc.ALCenum alc_hrtf_soft
    cdef alc.ALCenum alc_hrtf_id_soft
    cdef readonly alc.ALCenum DONT_CARE
    cdef alc.ALCenum alc_hrtf_status_soft
    cdef alc.ALCenum alc_num_hrtf_specifiers_soft
    cdef alc.ALCenum alc_hrtf_specifier_soft

    cdef readonly alc.ALCenum DISABLED
    cdef readonly alc.ALCenum ENABLED
    cdef readonly alc.ALCenum DENIED
    cdef readonly alc.ALCenum REQUIRED
    cdef readonly alc.ALCenum HEADPHONES_DETECTED
    cdef readonly alc.ALCenum UNSUPPORTED_FORMAT

    cpdef alc.ALCint find_model(self, str model)

cdef class HrtfModelIterator:
    cdef object __weakref__
    cdef readonly HrtfExtension hrtf
    cdef readonly alc.ALCsizei current_index
    cdef alc.ALCint num_specifiers
