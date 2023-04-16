# cython: language_level=3

from .context cimport Context
from . cimport al

cdef class Source:
    cdef readonly Context context
    cdef readonly al.ALuint id

    @staticmethod
    cdef Source from_id(Context ctx, al.ALuint id)
