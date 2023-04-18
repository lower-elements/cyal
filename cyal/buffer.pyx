# cython: language_level=3

from .context cimport Context
from .exceptions cimport check_al_error
from . cimport alc

cdef class Buffer:
    def __cinit__(self):
        pass

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef Buffer from_id(Context ctx, al.ALuint id):
        cdef Buffer buf = Buffer.__new__(Buffer)
        buf.context = ctx
        buf.id = id
        return buf

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.context._ctx)
        self.context.al_delete_buffers(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    def set_data(self, data, *, sample_rate, format):
        cdef const al.ALubyte[:] view = data
        self.context.al_buffer_data(self.id, format, &view[0], view.size, sample_rate)
        check_al_error()

    def __len__(self):
        cdef al.ALsizei length
        self.context.get_buffer_i(self.id, al.AL_SIZE, &length)
        return length

    @property
    def bits(self):
        cdef al.ALint val
        self.context.get_buffer_i(self.id, al.AL_BITS, &val)
        return val

    @property
    def channels(self):
        cdef al.ALint val
        self.context.get_buffer_i(self.id, al.AL_CHANNELS, &val)
        return val

    @property
    def sample_rate(self):
        cdef al.ALsizei val
        self.context.get_buffer_i(self.id, al.AL_FREQUENCY, &val)
        return val
