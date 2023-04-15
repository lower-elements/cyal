# cython: language_level=3

from .context cimport Context
from . cimport al

cdef class Listener:
    cdef readonly Context context
    #  Set listener parameters.
    cdef void (*set_f)(al.ALenum param, al.ALfloat value)
    cdef void (*set_3f)(al.ALenum param, al.ALfloat value1, al.ALfloat value2, al.ALfloat value3)
    cdef void (*set_fv)(al.ALenum param, const al.ALfloat *values)
    cdef void (*set_i)(al.ALenum param, al.ALint value)
    cdef void (*set_3i)(al.ALenum param, al.ALint value1, al.ALint value2, al.ALint value3)
    cdef void (*set_iv)(al.ALenum param, const al.ALint *values)
    #  Get listener parameters.
    cdef void (*get_f)(al.ALenum param, al.ALfloat *value)
    cdef void (*get_3f)(al.ALenum param, al.ALfloat *value1, al.ALfloat* value2, al.ALfloat* value3)
    cdef void (*get_fv)(al.ALenum param, al.ALfloat *values)
    cdef void (*get_i)(al.ALenum param, al.ALint *value)
    cdef void (*get_3i)(al.ALenum param, al.ALint *value1, al.ALint* value2, al.ALint* value3)
    cdef void (*get_iv)(al.ALenum param, al.ALint *values)
