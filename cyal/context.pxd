# cython: language_level=3

from .device cimport Device
from . cimport alc

cdef class Context:
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device

cdef class ContextAttrs:
    cdef alc.ALCint[:] _attrs
    cdef Device _dev
