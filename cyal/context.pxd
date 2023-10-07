# cython: language_level=3

from .device cimport Device
from .listener cimport Listener
from . cimport al, alc

cdef class Context:
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device
    cdef readonly Listener listener
    cdef bint emulate_direct_channels
    cdef bint emulate_direct_channels_remix

    # AL_SOFT_deferred_updates extension
    cdef void (*al_defer_updates_soft)()
    cdef void (*al_process_updates_soft)()

cdef class ContextAttrs:
    cdef alc.ALCint[:] _attrs
    cdef Device _dev
