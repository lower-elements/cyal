# cython: language_level=3

from .context cimport Context
from .exceptions cimport check_al_error
from .util cimport V3f
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

    def play(self):
        self.context.source_play(self.id)
        check_al_error()

    def stop(self):
        self.context.source_stop(self.id)
        check_al_error()

    def rewind(self):
        self.context.source_rewind(self.id)
        check_al_error()

    def pause(self):
        self.context.source_pause(self.id)
        check_al_error()

    @property
    def buffer(self):
        return self._buf

    @buffer.setter
    def buffer(self, buf):
        self.context.set_source_i(self.id, al.AL_BUFFER, <al.ALint>buf.id)
        check_al_error()
        self._buf = buf


    @buffer.deleter
    def buffer(self):
        self.context.set_source_i(self.id, al.AL_BUFFER, al.AL_NONE)
        self._buf = None

    @property
    def relative(self):
        cdef al.ALint flag
        self.context.get_source_i(self.id, al.AL_SOURCE_RELATIVE, &flag)
        return flag == al.AL_TRUE

    @relative.setter
    def relative(self, val):
        self.context.set_source_i(self.id, al.AL_SOURCE_RELATIVE, al.AL_TRUE if val else al.AL_FALSE)

    @property
    def cone_inner_angle(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_CONE_INNER_ANGLE, &val)
        return val

    @cone_inner_angle.setter
    def cone_inner_angle(self, val):
        self.context.set_source_f(self.id, al.AL_CONE_INNER_ANGLE, val)

    @property
    def cone_outer_angle(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_CONE_OUTER_ANGLE, &val)
        return val

    @cone_outer_angle.setter
    def cone_outer_angle(self, val):
        self.context.set_source_f(self.id, al.AL_CONE_OUTER_ANGLE, val)

    @property
    def pitch(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_PITCH, &val)
        return val

    @pitch.setter
    def pitch(self, val):
        self.context.set_source_f(self.id, al.AL_PITCH, val)

    @property
    def position(self):
        cdef float x, y, z
        self.context.get_source_3f(self.id, al.AL_POSITION, &x, &y, &z)
        return V3f(x, y, z)

    @position.setter
    def position(self, val):
        self.context.set_source_3f(self.id, al.AL_POSITION, val[0], val[1], val[2])

    @property
    def direction(self):
        cdef float x, y, z
        self.context.get_source_3f(self.id, al.AL_DIRECTION, &x, &y, &z)
        return V3f(x, y, z)

    @direction.setter
    def direction(self, val):
        self.context.set_source_3f(self.id, al.AL_DIRECTION, val[0], val[1], val[2])

    @property
    def velocity(self):
        cdef float x, y, z
        self.context.get_source_3f(self.id, al.AL_VELOCITY, &x, &y, &z)
        return V3f(x, y, z)

    @velocity.setter
    def velocity(self, val):
        self.context.set_source_3f(self.id, al.AL_VELOCITY, val[0], val[1], val[2])

    @property
    def looping(self):
        cdef al.ALint flag
        self.context.get_source_i(self.id, al.AL_LOOPING, &flag)
        return flag == al.AL_TRUE

    @looping.setter
    def looping(self, val):
        self.context.set_source_i(self.id, al.AL_LOOPING, al.AL_TRUE if val else al.AL_FALSE)

    @property
    def gain(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_GAIN, &val)
        return val

    @gain.setter
    def gain(self, val):
        self.context.set_source_f(self.id, al.AL_GAIN, val)

    @property
    def min_gain(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_MIN_GAIN, &val)
        return val

    @min_gain.setter
    def min_gain(self, val):
        self.context.set_source_f(self.id, al.AL_MIN_GAIN, val)

    @property
    def max_gain(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_MAX_GAIN, &val)
        return val

    @max_gain.setter
    def max_gain(self, val):
        self.context.set_source_f(self.id, al.AL_MAX_GAIN, val)

    @property
    def state(self):
        cdef al.ALenum val
        self.context.get_source_i(self.id, al.AL_SOURCE_STATE, &val)
        return SourceState(val)

    @property
    def buffers_queued(self):
        cdef al.ALint val
        self.context.get_source_i(self.id, al.AL_BUFFERS_QUEUED, &val)
        return val

    @property
    def buffers_processed(self):
        cdef al.ALint val
        self.context.get_source_i(self.id, al.AL_BUFFERS_PROCESSED, &val)
        return val

    @property
    def reference_distance(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_REFERENCE_DISTANCE, &val)
        return val

    @reference_distance.setter
    def reference_distance(self, val):
        self.context.set_source_f(self.id, al.AL_REFERENCE_DISTANCE, val)

    @property
    def rolloff_factor(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_ROLLOFF_FACTOR, &val)
        return val

    @rolloff_factor.setter
    def rolloff_factor(self, val):
        self.context.set_source_f(self.id, al.AL_ROLLOFF_FACTOR, val)

    @property
    def cone_outer_gain(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_CONE_OUTER_GAIN, &val)
        return val

    @cone_outer_gain.setter
    def cone_outer_gain(self, val):
        self.context.set_source_f(self.id, al.AL_CONE_OUTER_GAIN, val)

    @property
    def max_distance(self):
        cdef float val
        self.context.get_source_f(self.id, al.AL_MAX_DISTANCE, &val)
        return val

    @max_distance.setter
    def max_distance(self, val):
        self.context.set_source_f(self.id, al.AL_MAX_DISTANCE, val)

    @property
    def type(self):
        cdef al.ALenum val
        self.context.get_source_i(self.id, al.AL_SOURCE_TYPE, &val)
        return SourceType(val)

cpdef enum SourceState:
    INITIAL = al.AL_INITIAL
    PLAYING = al.AL_PLAYING
    PAUSED = al.AL_PAUSED
    STOPPED = al.AL_STOPPED

cpdef enum SourceType:
        STATIC = al.AL_STATIC
        STREAMING = al.AL_STREAMING
        UNDETERMINED = al.AL_UNDETERMINED
