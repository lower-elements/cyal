# cython: language_level=3

from .context cimport Context
from .util cimport V3f
from . cimport al

cdef class Listener:
    def __cinit__(self, Context ctx):
        self.context = ctx
        self.set_f = <void (*)(al.ALenum, al.ALfloat)>ctx.device.get_al_proc_address("alListenerf")
        self.set_3f = <void (*)(al.ALenum, al.ALfloat, al.ALfloat, al.ALfloat)>ctx.device.get_al_proc_address("alListener3f")
        self.set_fv = <void (*)(al.ALenum, const al.ALfloat*)>ctx.device.get_al_proc_address("alListenerfv")
        self.set_i = <void (*)(al.ALenum, al.ALint)>ctx.device.get_al_proc_address("alListeneri")
        self.set_3i = <void (*)(al.ALenum, al.ALint, al.ALint, al.ALint)>ctx.device.get_al_proc_address("alListener3i")
        self.set_iv = <void (*)(al.ALenum, const al.ALint*)>ctx.device.get_al_proc_address("alListeneriv")
        self.get_f = <void (*)(al.ALenum, al.ALfloat*)>ctx.device.get_al_proc_address("alGetListenerf")
        self.get_3f = <void (*)(al.ALenum, al.ALfloat*, al.ALfloat*, al.ALfloat*)>ctx.device.get_al_proc_address("alGetListener3f")
        self.get_fv = <void (*)(al.ALenum, al.ALfloat*)>ctx.device.get_al_proc_address("alGetListenerfv")
        self.get_i = <void (*)(al.ALenum, al.ALint*)>ctx.device.get_al_proc_address("alGetListeneri")
        self.get_3i = <void (*)(al.ALenum, al.ALint*, al.ALint*, al.ALint*)>ctx.device.get_al_proc_address("alGetListener3i")
        self.get_iv = <void (*)(al.ALenum, al.ALint*)>ctx.device.get_al_proc_address("alGetListeneriv")

    @property
    def position(self):
        cdef float x, y, z
        self.get_3f(al.AL_POSITION, &x, &y, &z)
        return V3f(x, y, z)

    @position.setter
    def position(self, pos):
        self.set_3f(al.AL_POSITION, pos[0], pos[1], pos[2])

    @property
    def velocity(self):
        cdef float x, y, z
        self.get_3f(al.AL_VELOCITY, &x, &y, &z)
        return V3f(x, y, z)

    @velocity.setter
    def velocity(self, val):
        self.set_3f(al.AL_VELOCITY, val[0], val[1], val[2])

    @property
    def gain(self):
        cdef float val
        self.get_f(al.AL_GAIN, &val)
        return val

    @gain.setter
    def gain(self, val):
        self.set_f(al.AL_GAIN, val)

    @property
    def orientation(self):
        cdef float[6] data
        self.get_fv(al.AL_ORIENTATION, data)
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
        self.set_fv(al.AL_ORIENTATION, data)
