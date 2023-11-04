# cython: language_level=3

from .context cimport Context
from .exceptions cimport check_al_error, UnsupportedExtensionError
from . cimport al, alc

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
        al.alDeleteBuffers(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    def set_data(self, data, *, sample_rate, format):
        cdef const al.ALubyte[:] view = data
        al.alBufferData(self.id, format, &view[0], view.size, sample_rate)
        check_al_error()

    def __len__(self):
        cdef al.ALsizei length
        al.alGetBufferi(self.id, al.AL_SIZE, &length)
        return length

    @property
    def bits(self):
        cdef al.ALint val
        al.alGetBufferi(self.id, al.AL_BITS, &val)
        return val

    @property
    def channels(self):
        cdef al.ALint val
        al.alGetBufferi(self.id, al.AL_CHANNELS, &val)
        return val

    @property
    def sample_rate(self):
        cdef al.ALsizei val
        al.alGetBufferi(self.id, al.AL_FREQUENCY, &val)
        return val

    @property
    def byte_length(self):
        cdef al.ALint val
        if self.context.al_byte_length_soft != al.AL_NONE:
            al.alGetBufferi(self.id, self.context.al_byte_length_soft, &val)
            return val
        elif self.context.emulate_buffer_length_query:
            return len(self)
        else:
            raise UnsupportedExtensionError("AL_SOFT_BUFFER_LENGTH_QUERY")

    @property
    def sample_length(self):
        cdef al.ALint val
        if self.context.al_sample_length_soft != al.AL_NONE:
            al.alGetBufferi(self.id, self.context.al_sample_length_soft, &val)
            return val
        elif self.context.emulate_buffer_length_query:
            return len(self) // (self.bits // 8) // self.channels
        else:
            raise UnsupportedExtensionError("AL_SOFT_BUFFER_LENGTH_QUERY")

    @property
    def sec_length(self):
        cdef al.ALfloat val
        if self.context.al_sec_length_soft != al.AL_NONE:
            al.alGetBufferf(self.id, self.context.al_sec_length_soft, &val)
            return val
        elif self.context.emulate_buffer_length_query:
            try: return len(self) // (self.bits // 8) // self.channels / self.sample_rate
            except ZeroDivisionError: return 0
        else:
            raise UnsupportedExtensionError("AL_SOFT_BUFFER_LENGTH_QUERY")
