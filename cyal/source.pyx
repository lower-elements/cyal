# cython: language_level=3

from libc.limits cimport INT_MAX
from cpython cimport array
import array
from collections.abc import Sequence

from .context cimport Context
from .efx cimport EfxExtension, Filter
from .exceptions cimport check_al_error, UnsupportedExtensionError
from .util cimport get_al_enum, V3f
from . cimport al, alc

cdef array.array ids_template = array.array('I')

cdef class Source:
    def __cinit__(self):
        pass

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef Source from_id(Context ctx, al.ALuint id):
        cdef Source src = Source.__new__(Source)
        src.context = ctx
        src._queued_bufs = {}
        src.id = id
        return src

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.context._ctx)
        al.alDeleteSources(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    def play(self):
        al.alSourcePlay(self.id)
        check_al_error()

    def stop(self):
        al.alSourceStop(self.id)
        check_al_error()

    def rewind(self):
        al.alSourceRewind(self.id)
        check_al_error()

    def pause(self):
        al.alSourcePause(self.id)
        check_al_error()

    def queue_buffers(self, *bufs):
        cdef al.ALuint[:] ids = array.clone(ids_template, len(bufs), zero=False)
        cdef Py_ssize_t i
        for i, b in enumerate(bufs): ids[i] = b.id
        al.alSourceQueueBuffers(self.id, ids.size, &ids[0])
        check_al_error()
        for b in bufs: self._queued_bufs[b.id] = b
        self._buf = None

    def unqueue_buffers(self, *, max=INT_MAX):
        cdef al.ALint length
        al.alGetSourcei(self.id, al.AL_BUFFERS_PROCESSED, &length)
        length = length if length < max else max
        if length <= 0:
            return []
        cdef al.ALuint[:] ids = array.clone(ids_template, length, zero=False)
        al.alSourceUnqueueBuffers(self.id, ids.size, &ids[0])
        check_al_error()
        return [self._queued_bufs.pop(id) for id in ids]

    @property
    def buffer(self):
        return self._buf

    @buffer.setter
    def buffer(self, buf):
        al.alSourcei(self.id, al.AL_BUFFER, <al.ALint>buf.id)
        check_al_error()
        self._buf = buf


    @buffer.deleter
    def buffer(self):
        al.alSourcei(self.id, al.AL_BUFFER, al.AL_NONE)
        self._buf = None

    @property
    def relative(self):
        cdef al.ALint flag
        al.alGetSourcei(self.id, al.AL_SOURCE_RELATIVE, &flag)
        return flag == al.AL_TRUE

    @relative.setter
    def relative(self, val):
        al.alSourcei(self.id, al.AL_SOURCE_RELATIVE, al.AL_TRUE if val else al.AL_FALSE)

    @property
    def cone_inner_angle(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_CONE_INNER_ANGLE, &val)
        return val

    @cone_inner_angle.setter
    def cone_inner_angle(self, val):
        al.alSourcef(self.id, al.AL_CONE_INNER_ANGLE, val)

    @property
    def cone_outer_angle(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_CONE_OUTER_ANGLE, &val)
        return val

    @cone_outer_angle.setter
    def cone_outer_angle(self, val):
        al.alSourcef(self.id, al.AL_CONE_OUTER_ANGLE, val)

    @property
    def pitch(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_PITCH, &val)
        return val

    @pitch.setter
    def pitch(self, val):
        al.alSourcef(self.id, al.AL_PITCH, val)

    @property
    def position(self):
        cdef float x, y, z
        al.alGetSource3f(self.id, al.AL_POSITION, &x, &y, &z)
        return V3f(x, y, z)

    @position.setter
    def position(self, val):
        al.alSource3f(self.id, al.AL_POSITION, val[0], val[1], val[2])

    @property
    def direction(self):
        cdef float x, y, z
        al.alGetSource3f(self.id, al.AL_DIRECTION, &x, &y, &z)
        return V3f(x, y, z)

    @direction.setter
    def direction(self, val):
        al.alSource3f(self.id, al.AL_DIRECTION, val[0], val[1], val[2])

    @property
    def velocity(self):
        cdef float x, y, z
        al.alGetSource3f(self.id, al.AL_VELOCITY, &x, &y, &z)
        return V3f(x, y, z)

    @velocity.setter
    def velocity(self, val):
        al.alSource3f(self.id, al.AL_VELOCITY, val[0], val[1], val[2])

    @property
    def looping(self):
        cdef al.ALint flag
        al.alGetSourcei(self.id, al.AL_LOOPING, &flag)
        return flag == al.AL_TRUE

    @looping.setter
    def looping(self, val):
        al.alSourcei(self.id, al.AL_LOOPING, al.AL_TRUE if val else al.AL_FALSE)

    @property
    def gain(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_GAIN, &val)
        return val

    @gain.setter
    def gain(self, val):
        al.alSourcef(self.id, al.AL_GAIN, val)

    @property
    def min_gain(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_MIN_GAIN, &val)
        return val

    @min_gain.setter
    def min_gain(self, val):
        al.alSourcef(self.id, al.AL_MIN_GAIN, val)

    @property
    def max_gain(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_MAX_GAIN, &val)
        return val

    @max_gain.setter
    def max_gain(self, val):
        al.alSourcef(self.id, al.AL_MAX_GAIN, val)

    @property
    def state(self):
        cdef al.ALenum val
        al.alGetSourcei(self.id, al.AL_SOURCE_STATE, &val)
        return SourceState(val)

    @property
    def buffers_queued(self):
        cdef al.ALint val
        al.alGetSourcei(self.id, al.AL_BUFFERS_QUEUED, &val)
        return val

    @property
    def buffers_processed(self):
        cdef al.ALint val
        al.alGetSourcei(self.id, al.AL_BUFFERS_PROCESSED, &val)
        return val

    @property
    def reference_distance(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_REFERENCE_DISTANCE, &val)
        return val

    @reference_distance.setter
    def reference_distance(self, val):
        al.alSourcef(self.id, al.AL_REFERENCE_DISTANCE, val)

    @property
    def rolloff_factor(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_ROLLOFF_FACTOR, &val)
        return val

    @rolloff_factor.setter
    def rolloff_factor(self, val):
        al.alSourcef(self.id, al.AL_ROLLOFF_FACTOR, val)

    @property
    def cone_outer_gain(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_CONE_OUTER_GAIN, &val)
        return val

    @cone_outer_gain.setter
    def cone_outer_gain(self, val):
        al.alSourcef(self.id, al.AL_CONE_OUTER_GAIN, val)

    @property
    def max_distance(self):
        cdef float val
        al.alGetSourcef(self.id, al.AL_MAX_DISTANCE, &val)
        return val

    @max_distance.setter
    def max_distance(self, val):
        al.alSourcef(self.id, al.AL_MAX_DISTANCE, val)

    @property
    def type(self):
        cdef al.ALenum val
        al.alGetSourcei(self.id, al.AL_SOURCE_TYPE, &val)
        return SourceType(val)

    @property
    def direct_channels(self):
        cdef al.ALenum direct_channels_soft = al.alGetEnumValue(b"AL_DIRECT_CHANNELS_SOFT")
        cdef al.ALenum remix_unmatched_soft = al.alGetEnumValue(b"AL_REMIX_UNMATCHED_SOFT")
        cdef al.ALint val

        if direct_channels_soft != al.AL_NONE:
            al.alGetSourcei(self.id, direct_channels_soft, &val)
            check_al_error()

            if val == al.AL_FALSE: return False
            elif val == al.AL_TRUE: return True
            else:
                if remix_unmatched_soft != al.AL_NONE:
                    if val == remix_unmatched_soft: return "remix_unmatched"
                    else: raise ValueError(f"Invalid value for Source.direct_channels, got {val}")
                elif self.context.emulate_direct_channels_remix: return True
                else: raise ValueError(f"Invalid value for Source.direct_channels, got {val}")

        else:
            if self.context.emulate_direct_channels: return False
            else: raise UnsupportedExtensionError("AL_SOFT_DIRECT_CHANNELS")

    @direct_channels.setter
    def direct_channels(self, val):
        cdef al.ALenum direct_channels_soft = al.alGetEnumValue(b"AL_DIRECT_CHANNELS_SOFT")
        cdef al.ALenum remix_unmatched_soft = al.alGetEnumValue(b"AL_REMIX_UNMATCHED_SOFT")
        cdef al.ALint enum_val
        if direct_channels_soft != al.AL_NONE:
            if val == True: enum_val = al.AL_TRUE
            elif val == False: enum_val = al.AL_FALSE
            elif val == "remix_unmatched":
                if remix_unmatched_soft != al.AL_NONE: enum_val = remix_unmatched_soft
                elif self.context.emulate_direct_channels_remix: enum_value = al.AL_TRUE
                else: raise UnsupportedExtensionError("AL_SOFT_DIRECT_CHANNELS_REMIX")
            else: raise ValueError(f"Invalid value for Source.direct_channels, got {val}")
            al.alSourcei(self.id, direct_channels_soft, enum_val)
            check_al_error()
        elif not self.context.emulate_direct_channels:
            raise UnsupportedExtensionError("AL_SOFT_DIRECT_CHANNELS")

    @property
    def spatialize(self):
        cdef al.ALenum source_spatialize_soft = al.alGetEnumValue(b"AL_SOURCE_SPATIALIZE_SOFT")
        cdef al.ALint val
        if source_spatialize_soft != 0:
            al.alGetSourcei(self.id, source_spatialize_soft, &val)
            check_al_error()
            if val == al.AL_FALSE: return False
            elif val == al.AL_TRUE: return True
            elif val == al.alGetEnumValue(b"AL_AUTO_SOFT"): return "auto"
            else: raise ValueError(f"Invalid value for Source.spatialize, got {val}")
        else:
            if self.context.emulate_source_spatialize: return "auto" 
            else: raise UnsupportedExtensionError("AL_SOFT_SOURCE_SPATIALIZE")

    @spatialize.setter
    def spatialize(self, val):
        cdef al.ALenum source_spatialize_soft = al.alGetEnumValue(b"AL_SOURCE_SPATIALIZE_SOFT")
        cdef al.ALint enum_val
        if source_spatialize_soft != 0:
            if val == False: enum_val = al.AL_FALSE
            elif val == True: enum_val = al.AL_TRUE
            elif val == "auto": enum_val = al.alGetEnumValue(b"AL_AUTO_SOFT")
            else: raise ValueError(f"Invalid value for Source.spatialize, got {val}")
            al.alSourcei(self.id, source_spatialize_soft, enum_val)
            check_al_error()
        elif not self.context.emulate_source_spatialize:
            raise UnsupportedExtensionError("AL_SOFT_SOURCE_SPATIALIZE")

    @property
    def direct_filter(self):
        return self._direct_filter

    @direct_filter.setter
    def direct_filter(self, filter):
        if not isinstance(filter, Filter):
            raise TypeError("Source.direct_filter must be a Filter object")
        cdef EfxExtension efx = filter.efx
        al.alSourcei(self.id, efx.al_direct_filter, filter.id)
        check_al_error()
        self._direct_filter = filter

    @direct_filter.deleter
    def direct_filter(self):
        if self._direct_filter is None: return
        cdef EfxExtension efx = self._direct_filter.efx
        al.alSourcei(self.id, efx.al_direct_filter, efx.al_filter_null)
        check_al_error()
        self._direct_filter = None

    # Generic property functions for extension properties

    def get_int(self, prop):
        cdef al.ALenum e_val = get_al_enum(prop)
        cdef al.ALint val
        al.alGetSourcei(self.id, e_val, &val)
        check_al_error()
        return val

    def get_float(self, prop):
        cdef al.ALenum e_val = get_al_enum(prop)
        cdef al.ALfloat val
        al.alGetSourcef(self.id, e_val, &val)
        check_al_error()
        return val

    def get_v3f(self, prop):
        cdef al.ALenum e_val = get_al_enum(prop)
        cdef al.ALfloat[3] val
        al.alGetSourcefv(self.id, e_val, val)
        check_al_error()
        return V3f(val[0], val[1], val[2])

    def set(self, prop, val):
        cdef al.ALenum e_val = get_al_enum(prop)
        cdef al.ALfloat[3] data
        if isinstance(val, int):
            al.alSourcei(self.id, e_val, val)
        elif isinstance(val, float):
            al.alSourcef(self.id, e_val, val)
        elif (isinstance(val, Sequence) and len(val) == 3) or isinstance(val, V3f):
            data = [val[0], val[1], val[2]]
            al.alSourcefv(self.id, e_val, data)
        else:
            raise TypeError(f"Cannot convert {type(val)} to OpenAL type")
        check_al_error()

cpdef enum SourceState:
    INITIAL = al.AL_INITIAL
    PLAYING = al.AL_PLAYING
    PAUSED = al.AL_PAUSED
    STOPPED = al.AL_STOPPED

cpdef enum SourceType:
        STATIC = al.AL_STATIC
        STREAMING = al.AL_STREAMING
        UNDETERMINED = al.AL_UNDETERMINED
