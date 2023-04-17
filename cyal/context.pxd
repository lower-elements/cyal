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
    #  Set source parameters.
    cdef void (*set_source_f)(al.ALuint id, al.ALenum param, al.ALfloat value)
    cdef void (*set_source_3f)(al.ALuint id, al.ALenum param, al.ALfloat value1, al.ALfloat value2, al.ALfloat value3)
    cdef void (*set_source_fv)(al.ALuint id, al.ALenum param, const al.ALfloat *values)
    cdef void (*set_source_i)(al.ALuint id, al.ALenum param, al.ALint value)
    cdef void (*set_source_3i)(al.ALuint id, al.ALenum param, al.ALint value1, al.ALint value2, al.ALint value3)
    cdef void (*set_source_iv)(al.ALuint id, al.ALenum param, const al.ALint *values)
    #  Get listener parameters.
    cdef void (*get_source_f)(al.ALuint id, al.ALenum param, al.ALfloat *value)
    cdef void (*get_source_3f)(al.ALuint id, al.ALenum param, al.ALfloat *value1, al.ALfloat* value2, al.ALfloat* value3)
    cdef void (*get_source_fv)(al.ALuint id, al.ALenum param, al.ALfloat *values)
    cdef void (*get_source_i)(al.ALuint id, al.ALenum param, al.ALint *value)
    cdef void (*get_source_3i)(al.ALuint id, al.ALenum param, al.ALint *value1, al.ALint* value2, al.ALint* value3)
    cdef void (*get_source_iv)(al.ALuint id, al.ALenum param, al.ALint *values)

cdef class ContextAttrs:
    cdef alc.ALCint[:] _attrs
    cdef Device _dev
