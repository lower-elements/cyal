# cython: language_level=3

from .buffer cimport Buffer
from .context cimport Context
from . cimport al

cdef class Source:
    cdef readonly Context context
    cdef Buffer _buf
    cdef dict _queued_bufs
    cdef readonly al.ALuint id

    @staticmethod
    cdef Source from_id(Context ctx, al.ALuint id)
