# cython: language_level=3

from .context cimport Context
from . cimport al

cdef class Listener:
    def __cinit__(self, Context ctx):
        pass
