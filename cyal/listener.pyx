# cython: language_level=3

from .context cimport Context
from .util cimport V3f
from . cimport al

cdef class Listener:
    def __cinit__(self, Context ctx):
        self.context = ctx

    @property
    def position(self):
        cdef float x, y, z
        al.alGetListener3f(al.AL_POSITION, &x, &y, &z)
        return V3f(x, y, z)

    @position.setter
    def position(self, pos):
        al.alListener3f(al.AL_POSITION, pos[0], pos[1], pos[2])

    @property
    def velocity(self):
        cdef float x, y, z
        al.alGetListener3f(al.AL_VELOCITY, &x, &y, &z)
        return V3f(x, y, z)

    @velocity.setter
    def velocity(self, val):
        al.alListener3f(al.AL_VELOCITY, val[0], val[1], val[2])

    @property
    def gain(self):
        cdef float val
        al.alGetListenerf(al.AL_GAIN, &val)
        return val

    @gain.setter
    def gain(self, val):
        al.alListenerf(al.AL_GAIN, val)

    @property
    def orientation(self):
        cdef float[6] data
        al.alGetListenerfv(al.AL_ORIENTATION, data)
        return (V3f(data[0], data[1], data[2]), V3f(data[3], data[4], data[5]))

    @orientation.setter
    def orientation(self, val):
        cdef float[6] data
        if len(val) == 2:
            data = [val[0][0], val[0][1], val[0][2], val[1][0], val[1][1], val[1][2]]
        elif len(val) >= 6:
            data = [val[0], val[1], val[2], val[3], val[4], val[5]]
        else:
            raise ValueError("Invalid length for 'orientation'")
        al.alListenerfv(al.AL_ORIENTATION, data)
