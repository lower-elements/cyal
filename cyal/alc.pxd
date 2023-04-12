cdef extern from "alc.h":
    # Opaque device handle
    ctypedef struct ALCdevice:
        pass
    # Opaque context handle
    ctypedef struct ALCcontext:
        pass

    # 8-bit boolean
    ctypedef char ALCboolean

    # character
    ctypedef char ALCchar

    # signed 8-bit integer
    ctypedef signed char ALCbyte

    # unsigned 8-bit integer
    ctypedef unsigned char ALCubyte

    # signed 16-bit integer
    ctypedef short ALCshort

    # unsigned 16-bit integer
    ctypedef unsigned short ALCushort

    # signed 32-bit integer
    ctypedef int ALCint

    # unsigned 32-bit integer
    ctypedef unsigned int ALCuint

    # non-negative 32-bit integer size
    ctypedef int ALCsizei

    # 32-bit enumeration value
    ctypedef int ALCenum

    # 32-bit IEEE-754 floating-point
    ctypedef float ALCfloat

    # 64-bit IEEE-754 floating-point
    ctypedef double ALCdouble

    # void type (for opaque pointers only)
    ctypedef void ALCvoid

    cdef enum:
        # Context attribute: <int> Hz.
        ALC_FREQUENCY = 0x1007

        # Context attribute: <int> Hz.
        ALC_REFRESH = 0x1008

        # Context attribute: AL_TRUE or AL_FALSE synchronous context?
        ALC_SYNC = 0x1009

        # Context attribute: <int> requested Mono (3D) Sources.
        ALC_MONO_SOURCES = 0x1010

        # Context attribute: <int> requested Stereo Sources.
        ALC_STEREO_SOURCES = 0x1011

        # No error.
        ALC_NO_ERROR = 0

        # Invalid device handle.
        ALC_INVALID_DEVICE = 0xA001

        # Invalid context handle.
        ALC_INVALID_CONTEXT = 0xA002

        # Invalid enumeration passed to an ALC call.
        ALC_INVALID_ENUM = 0xA003

        # Invalid value passed to an ALC call.
        ALC_INVALID_VALUE = 0xA004

        # Out of memory.
        ALC_OUT_OF_MEMORY = 0xA005


        # Runtime ALC major version.
        ALC_MAJOR_VERSION = 0x1000
        # Runtime ALC minor version.
        ALC_MINOR_VERSION = 0x1001

        # Context attribute list size.
        ALC_ATTRIBUTES_SIZE = 0x1002
        # Context attribute list properties.
        ALC_ALL_ATTRIBUTES = 0x1003

        # String for the default device specifier.
        ALC_DEFAULT_DEVICE_SPECIFIER = 0x1004
        # Device specifier string.
        #
        # If device handle is NULL, it is instead a null-character separated list of
        # strings of known device specifiers (list ends with an empty string).
        ALC_DEVICE_SPECIFIER = 0x1005
        # String for space-separated list of ALC extensions.
        ALC_EXTENSIONS = 0x1006


        # Capture extension
        ALC_EXT_CAPTURE = 1
        # Capture device specifier string.
        #
        # If device handle is NULL, it is instead a null-character separated list of
        # strings of known capture device specifiers (list ends with an empty string).
        ALC_CAPTURE_DEVICE_SPECIFIER = 0x310
        # String for the default capture device specifier.
        ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER = 0x311
        # Number of sample frames available for capture.
        ALC_CAPTURE_SAMPLES = 0x312


        # Enumerate All extension
        ALC_ENUMERATE_ALL_EXT = 1
        # String for the default extended device specifier.
        ALC_DEFAULT_ALL_DEVICES_SPECIFIER = 0x1012
        # Device's extended specifier string.
        #
        # If device handle is NULL, it is instead a null-character separated list of
        # strings of known extended device specifiers (list ends with an empty string).
        ALC_ALL_DEVICES_SPECIFIER = 0x1013


    # Context management.

    # Create and attach a context to the given device.
    ALCcontext* alcCreateContext(ALCdevice *device, const ALCint *attrlist)
    # Makes the given context the active process-wide context. Passing NULL clears
    # the active context.
    ALCboolean  alcMakeContextCurrent(ALCcontext *context)
    # Resumes processing updates for the given context.
    void        alcProcessContext(ALCcontext *context)
    # Suspends updates for the given context.
    void        alcSuspendContext(ALCcontext *context)
    # Remove a context from its device and destroys it.
    void        alcDestroyContext(ALCcontext *context)
    # Returns the currently active context.
    ALCcontext* alcGetCurrentContext()
    # Returns the device that a particular context is attached to.
    ALCdevice*  alcGetContextsDevice(ALCcontext *context)

    # Device management.

    # Opens the named playback device.
    ALCdevice* alcOpenDevice(const ALCchar *devicename)
    # Closes the given playback device.
    ALCboolean alcCloseDevice(ALCdevice *device)

    # Error support.

    # Obtain the most recent Device error.
    ALCenum alcGetError(ALCdevice *device)

    # Extension support.

    # Query for the presence of an extension on the device. Pass a NULL device to
    # query a device-inspecific extension.
    ALCboolean alcIsExtensionPresent(ALCdevice *device, const ALCchar *extname)
    # Retrieve the address of a function. Given a non-NULL device, the returned
    # function may be device-specific.
    ALCvoid*   alcGetProcAddress(ALCdevice *device, const ALCchar *funcname)
    # Retrieve the value of an enum. Given a non-NULL device, the returned value
    # may be device-specific.
    ALCenum    alcGetEnumValue(ALCdevice *device, const ALCchar *enumname)

    # Query functions.

    # Returns information about the device, and error strings.
    const ALCchar* alcGetString(ALCdevice *device, ALCenum param)
    # Returns information about the device and the version of OpenAL.
    void           alcGetIntegerv(ALCdevice *device, ALCenum param, ALCsizei size, ALCint *values)

    # Capture functions.

    # Opens the named capture device with the given frequency, format, and buffer
    # size.
    ALCdevice* alcCaptureOpenDevice(const ALCchar *devicename, ALCuint frequency, ALCenum format, ALCsizei buffersize)
    # Closes the given capture device.
    ALCboolean alcCaptureCloseDevice(ALCdevice *device)
    # Starts capturing samples into the device buffer.
    void       alcCaptureStart(ALCdevice *device)
    # Stops capturing samples. Samples in the device buffer remain available.
    void       alcCaptureStop(ALCdevice *device)
    # Reads samples from the device buffer.
    void       alcCaptureSamples(ALCdevice *device, ALCvoid *buffer, ALCsizei samples)
