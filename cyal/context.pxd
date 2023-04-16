# cython: language_level=3

from .device cimport Device
from .listener cimport Listener
from . cimport al, alc

cdef class Context:
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device
    cdef readonly Listener listener
    # Source functions
    cdef void (*al_gen_sources)(al.ALsizei, al.ALuint*)
    cdef void (*al_delete_sources)(al.ALsizei, al.ALuint*)

cdef class ContextAttrs:
    cdef alc.ALCint[:] _attrs
    cdef Device _dev
