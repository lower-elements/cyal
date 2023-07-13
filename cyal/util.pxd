# cython: language_level=3

from . cimport al, alc

cdef list alc_string_to_list(const alc.ALCchar* str)

cdef class V3f:
    cdef float[3] data

cdef al.ALenum get_al_enum(str name)
