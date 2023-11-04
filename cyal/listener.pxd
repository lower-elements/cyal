# cython: language_level=3

from .context cimport Context
from . cimport al

cdef class Listener:
    cdef object __weakref__
    cdef readonly Context context
