# cython: language_level=3

from .context cimport Context
from . cimport al, alc

cdef class Source:
    def __cinit__(self):
        pass

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef Source from_id(Context ctx, al.ALuint id):
        cdef Source src = Source.__new__(Source)
        src.context = ctx
        src.id = id
        return src

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.context._ctx)
        self.context.al_delete_sources(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)
