# cython: language_level=3

from .buffer cimport Buffer
from .context cimport Context
from .efx cimport Filter
from . cimport al

cdef class Source:
    cdef object __weakref__
    cdef readonly Context context
    cdef Buffer _buf
    cdef dict _queued_bufs
    cdef Filter _direct_filter
    cdef readonly al.ALuint id

    @staticmethod
    cdef Source from_id(Context ctx, al.ALuint id)
