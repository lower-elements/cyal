cdef extern from "al.h":
    #  8-bit boolean
    ctypedef char ALboolean

    #  character
    ctypedef char ALchar

    #  signed 8-bit integer
    ctypedef signed char ALbyte

    #  unsigned 8-bit integer
    ctypedef unsigned char ALubyte

    #  signed 16-bit integer
    ctypedef short ALshort

    #  unsigned 16-bit integer
    ctypedef unsigned short ALushort

    #  signed 32-bit integer
    ctypedef int ALint

    #  unsigned 32-bit integer
    ctypedef unsigned int ALuint

    #  non-negative 32-bit integer size
    ctypedef int ALsizei

    #  32-bit enumeration value
    ctypedef int ALenum

    #  32-bit IEEE-754 floating-point
    ctypedef float ALfloat

    #  64-bit IEEE-754 floating-point
    ctypedef double ALdouble

    #  void type (opaque pointers only)
    ctypedef void ALvoid

    cdef enum:
        #  No distance model or no buffer
        AL_NONE = 0

        #  Boolean False.
        AL_FALSE = 0

        #  Boolean True.
        AL_TRUE = 1


        # Relative source.
        # Type:    ALboolean
        # Range:   [AL_FALSE, AL_TRUE]
        # Default: AL_FALSE
        #
        # Specifies if the source uses relative coordinates.
        AL_SOURCE_RELATIVE = 0x202


        # Inner cone angle, in degrees.
        # Type:    ALint, ALfloat
        # Range:   [0 - 360]
        # Default: 360
        #
        # The angle covered by the inner cone, the area within which the source will
        # not be attenuated by direction.
        AL_CONE_INNER_ANGLE = 0x1001

        # Outer cone angle, in degrees.
        # Range:   [0 - 360]
        # Default: 360
        #
        # The angle covered by the outer cone, the area outside of which the source
        # will be fully attenuated by direction.
        AL_CONE_OUTER_ANGLE = 0x1002

        # Source pitch.
        # Type:    ALfloat
        # Range:   [0.5 - 2.0]
        # Default: 1.0
        #
        # A multiplier for the sample rate of the source's buffer.
        AL_PITCH = 0x1003

        # Source or listener position.
        # Type:    ALfloat[3], ALint[3]
        # Default: {0, 0, 0}
        #
        # The source or listener location in three dimensional space.
        #
        # OpenAL uses a right handed coordinate system, like OpenGL, where with a
        # default view, X points right (thumb), Y points up (index finger), and Z
        # points towards the viewer/camera (middle finger).
        #
        # To change from or to a left handed coordinate system, negate the Z
        # component.
        AL_POSITION = 0x1004

        # Source direction.
        # Type:    ALfloat[3], ALint[3]
        # Default: {0, 0, 0}
        #
        # Specifies the current direction in local space. A zero-length vector
        # specifies an omni-directional source (cone is ignored).
        #
        # To change from or to a left handed coordinate system, negate the Z
        # component.
        AL_DIRECTION = 0x1005

        # Source or listener velocity.
        # Type:    ALfloat[3], ALint[3]
        # Default: {0, 0, 0}
        #
        # Specifies the current velocity, relative to the position.
        #
        # To change from or to a left handed coordinate system, negate the Z
        # component.
        AL_VELOCITY = 0x1006

        # Source looping.
        # Type:    ALboolean
        # Range:   [AL_FALSE, AL_TRUE]
        # Default: AL_FALSE
        #
        # Specifies whether source playback loops.
        AL_LOOPING = 0x1007

        # Source buffer.
        # Type:    ALuint
        # Range:   any valid Buffer ID
        # Default: AL_NONE
        #
        # Specifies the buffer to provide sound samples for a source.
        AL_BUFFER = 0x1009

        # Source or listener gain.
        # Type:  ALfloat
        # Range: [0.0 - ]
        #
        # For sources, an initial linear gain value (before attenuation is applied).
        # For the listener, an output linear gain adjustment.
        #
        # A value of 1.0 means unattenuated. Each division by 2 equals an attenuation
        # of about -6dB. Each multiplication by 2 equals an amplification of about
        # +6dB.
        AL_GAIN = 0x100A

        # Minimum source gain.
        # Type:  ALfloat
        # Range: [0.0 - 1.0]
        #
        # The minimum gain allowed for a source, after distance and cone attenuation
        # are applied (if applicable).
        AL_MIN_GAIN = 0x100D

        # Maximum source gain.
        # Type:  ALfloat
        # Range: [0.0 - 1.0]
        #
        # The maximum gain allowed for a source, after distance and cone attenuation
        # are applied (if applicable).
        AL_MAX_GAIN = 0x100E

        # Listener orientation.
        # Type:    ALfloat[6]
        # Default: {0.0, 0.0, -1.0, 0.0, 1.0, 0.0}
        #
        # Effectively two three dimensional vectors. The first vector is the front (or
        # "at") and the second is the top (or "up"). Both vectors are relative to the
        # listener position.
        #
        # To change from or to a left handed coordinate system, negate the Z
        # component of both vectors.
        AL_ORIENTATION = 0x100F

        # Source state (query only).
        # Type:  ALenum
        # Range: [AL_INITIAL, AL_PLAYING, AL_PAUSED, AL_STOPPED]
        AL_SOURCE_STATE = 0x1010

        #  Source state values.
        AL_INITIAL = 0x1011
        AL_PLAYING = 0x1012
        AL_PAUSED = 0x1013
        AL_STOPPED = 0x1014

        # Source Buffer Queue size (query only).
        # Type: ALint
        #
        # The number of buffers queued using alSourceQueueBuffers, minus the buffers
        # removed with alSourceUnqueueBuffers.
        AL_BUFFERS_QUEUED = 0x1015

        # Source Buffer Queue processed count (query only).
        # Type: ALint
        #
        # The number of queued buffers that have been fully processed, and can be
        # removed with alSourceUnqueueBuffers.
        #
        # Looping sources will never fully process buffers because they will be set to
        # play again for when the source loops.
        AL_BUFFERS_PROCESSED = 0x1016

        # Source reference distance.
        # Type:    ALfloat
        # Range:   [0.0 - ]
        # Default: 1.0
        #
        # The distance in units that no distance attenuation occurs.
        #
        # At 0.0, no distance attenuation occurs with non-linear attenuation models.
        AL_REFERENCE_DISTANCE = 0x1020

        # Source rolloff factor.
        # Type:    ALfloat
        # Range:   [0.0 - ]
        # Default: 1.0
        #
        # Multiplier to exaggerate or diminish distance attenuation.
        #
        # At 0.0, no distance attenuation ever occurs.
        AL_ROLLOFF_FACTOR = 0x1021

        # Outer cone gain.
        # Type:    ALfloat
        # Range:   [0.0 - 1.0]
        # Default: 0.0
        #
        # The gain attenuation applied when the listener is outside of the source's
        # outer cone angle.
        AL_CONE_OUTER_GAIN = 0x1022

        # Source maximum distance.
        # Type:    ALfloat
        # Range:   [0.0 - ]
        # Default: FLT_MAX
        #
        # The distance above which the source is not attenuated any further with a
        # clamped distance model, or where attenuation reaches 0.0 gain for linear
        # distance models with a default rolloff factor.
        AL_MAX_DISTANCE = 0x1023

        #  Source buffer offset, in seconds
        AL_SEC_OFFSET = 0x1024
        #  Source buffer offset, in sample frames
        AL_SAMPLE_OFFSET = 0x1025
        #  Source buffer offset, in bytes
        AL_BYTE_OFFSET = 0x1026

        # Source type (query only).
        # Type:  ALenum
        # Range: [AL_STATIC, AL_STREAMING, AL_UNDETERMINED]
        #
        # A Source is Static if a Buffer has been attached using AL_BUFFER.
        #
        # A Source is Streaming if one or more Buffers have been attached using
        # alSourceQueueBuffers.
        #
        # A Source is Undetermined when it has the NULL buffer attached using
        # AL_BUFFER.
        AL_SOURCE_TYPE = 0x1027

        #  Source type values.
        AL_STATIC = 0x1028
        AL_STREAMING = 0x1029
        AL_UNDETERMINED = 0x1030

        #  Unsigned 8-bit mono buffer format.
        AL_FORMAT_MONO8 = 0x1100
        #  Signed 16-bit mono buffer format.
        AL_FORMAT_MONO16 = 0x1101
        #  Unsigned 8-bit stereo buffer format.
        AL_FORMAT_STEREO8 = 0x1102
        #  Signed 16-bit stereo buffer format.
        AL_FORMAT_STEREO16 = 0x1103

        #  Buffer frequency/sample rate (query only).
        AL_FREQUENCY = 0x2001
        #  Buffer bits per sample (query only).
        AL_BITS = 0x2002
        #  Buffer channel count (query only).
        AL_CHANNELS = 0x2003
        #  Buffer data size in bytes (query only).
        AL_SIZE = 0x2004

        #  Buffer state. Not for public use.
        AL_UNUSED = 0x2010
        AL_PENDING = 0x2011
        AL_PROCESSED = 0x2012


        #  No error.
        AL_NO_ERROR = 0

        #  Invalid name (ID) passed to an AL call.
        AL_INVALID_NAME = 0xA001

        #  Invalid enumeration passed to AL call.
        AL_INVALID_ENUM = 0xA002

        #  Invalid value passed to AL call.
        AL_INVALID_VALUE = 0xA003

        #  Illegal AL call.
        AL_INVALID_OPERATION = 0xA004

        #  Not enough memory to execute the AL call.
        AL_OUT_OF_MEMORY = 0xA005


        #  Context string: Vendor name.
        AL_VENDOR = 0xB001
        #  Context string: Version.
        AL_VERSION = 0xB002
        #  Context string: Renderer name.
        AL_RENDERER = 0xB003
        #  Context string: Space-separated extension list.
        AL_EXTENSIONS = 0xB004

        # Doppler scale.
        # Type:    ALfloat
        # Range:   [0.0 - ]
        # Default: 1.0
        #
        # Scale for source and listener velocities.
        AL_DOPPLER_FACTOR = 0xC000

        # Doppler velocity (deprecated).
        #
        # A multiplier applied to the Speed of Sound.
        AL_DOPPLER_VELOCITY = 0xC001

        # Speed of Sound, in units per second.
        # Type:    ALfloat
        # Range:   [0.0001 - ]
        # Default: 343.3
        #
        # The speed at which sound waves are assumed to travel, when calculating the
        # doppler effect from source and listener velocities.
        AL_SPEED_OF_SOUND = 0xC003

        # Distance attenuation model.
        # Type:    ALenum
        # Range:   [AL_NONE, AL_INVERSE_DISTANCE, AL_INVERSE_DISTANCE_CLAMPED,
        #           AL_LINEAR_DISTANCE, AL_LINEAR_DISTANCE_CLAMPED,
        #           AL_EXPONENT_DISTANCE, AL_EXPONENT_DISTANCE_CLAMPED]
        # Default: AL_INVERSE_DISTANCE_CLAMPED
        #
        # The model by which sources attenuate with distance.
        #
        # None     - No distance attenuation.
        # Inverse  - Doubling the distance halves the source gain.
        # Linear   - Linear gain scaling between the reference and max distances.
        # Exponent - Exponential gain dropoff.
        #
        # Clamped variations work like the non-clamped counterparts, except the
        # distance calculated is clamped between the reference and max distances.
        AL_DISTANCE_MODEL = 0xD000

        #  Distance model values.
        AL_INVERSE_DISTANCE = 0xD001
        AL_INVERSE_DISTANCE_CLAMPED = 0xD002
        AL_LINEAR_DISTANCE = 0xD003
        AL_LINEAR_DISTANCE_CLAMPED = 0xD004
        AL_EXPONENT_DISTANCE = 0xD005
        AL_EXPONENT_DISTANCE_CLAMPED = 0xD006

    #  Renderer State management.
    void alEnable(ALenum capability)
    void alDisable(ALenum capability)
    ALboolean alIsEnabled(ALenum capability)

    #  Context state setting.
    void alDopplerFactor(ALfloat value)
    void alDopplerVelocity(ALfloat value)
    void alSpeedOfSound(ALfloat value)
    void alDistanceModel(ALenum distanceModel)

    #  Context state retrieval.
    const ALchar* alGetString(ALenum param)
    void alGetBooleanv(ALenum param, ALboolean *values)
    void alGetIntegerv(ALenum param, ALint *values)
    void alGetFloatv(ALenum param, ALfloat *values)
    void alGetDoublev(ALenum param, ALdouble *values)
    ALboolean alGetBoolean(ALenum param)
    ALint alGetInteger(ALenum param)
    ALfloat alGetFloat(ALenum param)
    ALdouble alGetDouble(ALenum param)

    # Obtain the first error generated in the AL context since the last call to
    # this function.
    ALenum alGetError()

    #  Query for the presence of an extension on the AL context.
    ALboolean alIsExtensionPresent(const ALchar *extname)
    # Retrieve the address of a function. The returned function may be context-
    # specific.
    void* alGetProcAddress(const ALchar *fname)
    # Retrieve the value of an enum. The returned value may be context-specific.
    ALenum alGetEnumValue(const ALchar *ename)


    #  Set listener parameters.
    void alListenerf(ALenum param, ALfloat value)
    void alListener3f(ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alListenerfv(ALenum param, const ALfloat *values)
    void alListeneri(ALenum param, ALint value)
    void alListener3i(ALenum param, ALint value1, ALint value2, ALint value3)
    void alListeneriv(ALenum param, const ALint *values)

    #  Get listener parameters.
    void alGetListenerf(ALenum param, ALfloat *value)
    void alGetListener3f(ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetListenerfv(ALenum param, ALfloat *values)
    void alGetListeneri(ALenum param, ALint *value)
    void alGetListener3i(ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetListeneriv(ALenum param, ALint *values)


    #  Create source objects.
    void alGenSources(ALsizei n, ALuint *sources)
    #  Delete source objects.
    void alDeleteSources(ALsizei n, const ALuint *sources)
    #  Verify an ID is for a valid source.
    ALboolean alIsSource(ALuint source)

    #  Set source parameters.
    void alSourcef(ALuint source, ALenum param, ALfloat value)
    void alSource3f(ALuint source, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alSourcefv(ALuint source, ALenum param, const ALfloat *values)
    void alSourcei(ALuint source, ALenum param, ALint value)
    void alSource3i(ALuint source, ALenum param, ALint value1, ALint value2, ALint value3)
    void alSourceiv(ALuint source, ALenum param, const ALint *values)

    #  Get source parameters.
    void alGetSourcef(ALuint source, ALenum param, ALfloat *value)
    void alGetSource3f(ALuint source, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetSourcefv(ALuint source, ALenum param, ALfloat *values)
    void alGetSourcei(ALuint source,  ALenum param, ALint *value)
    void alGetSource3i(ALuint source, ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetSourceiv(ALuint source,  ALenum param, ALint *values)


    #  Play, restart, or resume a source, setting its state to AL_PLAYING.
    void alSourcePlay(ALuint source)
    #  Stop a source, setting its state to AL_STOPPED if playing or paused.
    void alSourceStop(ALuint source)
    #  Rewind a source, setting its state to AL_INITIAL.
    void alSourceRewind(ALuint source)
    #  Pause a source, setting its state to AL_PAUSED if playing.
    void alSourcePause(ALuint source)

    #  Play, restart, or resume a list of sources atomically.
    void alSourcePlayv(ALsizei n, const ALuint *sources)
    #  Stop a list of sources atomically.
    void alSourceStopv(ALsizei n, const ALuint *sources)
    #  Rewind a list of sources atomically.
    void alSourceRewindv(ALsizei n, const ALuint *sources)
    #  Pause a list of sources atomically.
    void alSourcePausev(ALsizei n, const ALuint *sources)

    #  Queue buffers onto a source
    void alSourceQueueBuffers(ALuint source, ALsizei nb, const ALuint *buffers)
    #  Unqueue processed buffers from a source
    void alSourceUnqueueBuffers(ALuint source, ALsizei nb, ALuint *buffers)


    #  Create buffer objects
    void alGenBuffers(ALsizei n, ALuint *buffers)
    #  Delete buffer objects
    void alDeleteBuffers(ALsizei n, const ALuint *buffers)
    #  Verify an ID is a valid buffer (including the NULL buffer)
    ALboolean alIsBuffer(ALuint buffer)

    # Copies data into the buffer, interpreting it using the specified format and
    # samplerate.
    void alBufferData(ALuint buffer, ALenum format, const ALvoid *data, ALsizei size, ALsizei samplerate)

    #  Set buffer parameters.
    void alBufferf(ALuint buffer, ALenum param, ALfloat value)
    void alBuffer3f(ALuint buffer, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alBufferfv(ALuint buffer, ALenum param, const ALfloat *values)
    void alBufferi(ALuint buffer, ALenum param, ALint value)
    void alBuffer3i(ALuint buffer, ALenum param, ALint value1, ALint value2, ALint value3)
    void alBufferiv(ALuint buffer, ALenum param, const ALint *values)

    #  Get buffer parameters.
    void alGetBufferf(ALuint buffer, ALenum param, ALfloat *value)
    void alGetBuffer3f(ALuint buffer, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetBufferfv(ALuint buffer, ALenum param, ALfloat *values)
    void alGetBufferi(ALuint buffer, ALenum param, ALint *value)
    void alGetBuffer3i(ALuint buffer, ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetBufferiv(ALuint buffer, ALenum param, ALint *values)
