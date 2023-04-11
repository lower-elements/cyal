# cython: language_level=3

from . cimport alc

cdef list alc_string_to_list(const alc.ALCchar* str)
