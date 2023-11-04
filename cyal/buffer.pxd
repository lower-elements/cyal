# cython: language_level=3

from .context cimport Context
from . cimport al

cdef class Buffer:
    cdef object __weakref__
    cdef readonly Context context
    cdef readonly al.ALuint id

    @staticmethod
    cdef Buffer from_id(Context ctx, al.ALuint id)

cpdef enum BufferFormat:
        MONO8 = al.AL_FORMAT_MONO8
        MONO16 = al.AL_FORMAT_MONO16
        STEREO8 = al.AL_FORMAT_STEREO8
        STEREO16 = al.AL_FORMAT_STEREO16
