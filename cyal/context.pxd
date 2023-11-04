# cython: language_level=3

from .device cimport Device
from .listener cimport Listener
from . cimport al, alc

cdef class Context:
    cdef object __weakref__
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device
    cdef readonly Listener listener

    # Flags for extension emulation
    cdef bint emulate_direct_channels
    cdef bint emulate_direct_channels_remix
    cdef bint emulate_source_spatialize
    cdef bint emulate_disconnect
    cdef bint emulate_buffer_length_query

    # Extension enum values

    # From ALC_EXT_DISCONNECT
    cdef al.ALenum alc_connected
    
    # From AL_SOFT_buffer_length_query
    cdef al.ALenum al_byte_length_soft
    cdef al.ALenum al_sample_length_soft
    cdef al.ALenum al_sec_length_soft

    # Extension function pointers

    # From AL_SOFT_deferred_updates
    cdef void (*al_defer_updates_soft)()
    cdef void (*al_process_updates_soft)()

cdef class ContextAttrs:
    cdef object __weakref__
    cdef alc.ALCint[:] _attrs
    cdef Device _dev
