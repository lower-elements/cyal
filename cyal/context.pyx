# cython: language_level=3

from cpython cimport array
import array
from contextlib import contextmanager

from .buffer cimport Buffer
from .device cimport Device
from .exceptions cimport UnsupportedExtensionError, check_al_error, check_alc_error
from .listener cimport Listener
from .source cimport Source
from . cimport al, alc

cdef array.array ids_template = array.array('I')

cdef class Context:
    def __cinit__(self, Device dev not None, *,
            make_current=False,
            emulate_deferred_updates=True,
            emulate_direct_channels=True,
            emulate_direct_channels_remix=True,
            emulate_source_spatialize=True,
            emulate_disconnect=True,
            emulate_buffer_length_query=True,
            **kwargs):
        self.device = dev
        cdef ContextAttrs attrs = ContextAttrs.from_kwargs(dev, **kwargs)
        self._ctx  =alc.alcCreateContext(dev._device, &attrs._attrs[0])
        if self._ctx is NULL:
            check_alc_error(dev._device)
        self.listener = Listener(self)

    # Flags for extension emulation
        self.emulate_direct_channels = emulate_direct_channels
        self.emulate_direct_channels_remix = emulate_direct_channels_remix
        self.emulate_source_spatialize = emulate_source_spatialize
        self.emulate_disconnect = emulate_disconnect
        self.emulate_buffer_length_query = emulate_buffer_length_query

        # Make the context current here, as checking for extensions requires it, and alGetProcAddress() may return context-specific functions
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self._ctx)

        # Extension enum values
        self.alc_connected = alc.alcGetEnumValue(self.device._device, b"ALC_CONNECTED");
        if al.alIsExtensionPresent(b"AL_SOFT_BUFFER_LENGTH_QUERY") == al.AL_TRUE:
            self.al_byte_length_soft = al.alGetEnumValue(b"AL_BYTE_LENGTH_SOFT")
            self.al_sample_length_soft = al.alGetEnumValue(b"AL_SAMPLE_LENGTH_SOFT")
            self.al_sec_length_soft = al.alGetEnumValue(b"AL_SEC_LENGTH_SOFT")
        else:
            self.al_byte_length_soft = al.AL_NONE
            self.al_sample_length_soft = al.AL_NONE
            self.al_sec_length_soft = al.AL_NONE

        # AL_SOFT_deferred_updates extension functions
        if al.alIsExtensionPresent("AL_SOFT_DEFERRED_UPDATES") == al.AL_TRUE:
            self.al_defer_updates_soft = <void (*)()>dev.get_al_proc_address("alDeferUpdatesSOFT")
            self.al_process_updates_soft = <void (*)()>dev.get_al_proc_address("alProcessUpdatesSOFT")
        elif emulate_deferred_updates:
            self.al_defer_updates_soft = wrap_defer_updates
            self.al_process_updates_soft = wrap_process_updates
        else:
            self.al_defer_updates_soft = no_defer_updates
            self.al_process_updates_soft = no_process_updates

        if not make_current:
            # Restore the previous context
            alc.alcMakeContextCurrent(prev_ctx)

    def __dealloc__(self):
        if self._ctx:
            if self._ctx == alc.alcGetCurrentContext():
                alc.alcMakeContextCurrent(NULL)
            alc.alcDestroyContext(self._ctx)

    def get_attrs(self):
        return ContextAttrs.from_device(self.device)

    @property
    def supported_extensions(self):
        cdef const al.ALchar* exts = al.alGetString(al.AL_EXTENSIONS)
        return exts.decode("utf8").split(' ') if exts is not NULL else []

    def is_extension_present(self, ext_name):
        return al.alIsExtensionPresent(ext_name.encode("utf8")) == al.AL_TRUE

    def make_current(self):
        alc.alcMakeContextCurrent(self._ctx)

    @property
    def is_connected(self):
        cdef al.ALint val
        if self.alc_connected != al.AL_NONE:
            alc.alcGetIntegerv(self.device._device, self.alc_connected, 1, &val)
            check_alc_error(self.device._device)
            return val != al.AL_FALSE
        elif self.emulate_disconnect:
            return True
        else:
            raise UnsupportedExtensionError("ALC_EXT_DISCONNECT")

    @property
    def is_current(self):
        return self._ctx == alc.alcGetCurrentContext()

    @contextmanager
    def as_current(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self._ctx)
        try:
            yield self
        finally:
            alc.alcMakeContextCurrent(prev_ctx)

    def process(self):
        alc.alcProcessContext(self._ctx)

    def suspend(self):
        alc.alcSuspendContext(self._ctx)

    @contextmanager
    def as_processing(self):
        alc.alcProcessContext(self._ctx)
        try:
            yield self
        finally:
            alc.alcSuspendContext(self._ctx)

    @contextmanager
    def as_suspended(self):
        alc.alcSuspendContext(self._ctx)
        try:
            yield self
        finally:
            alc.alcProcessContext(self._ctx)

    def defer_updates(self):
        self.al_defer_updates_soft()

    def process_updates(self):
        self.al_process_updates_soft()

    @contextmanager
    def batch(self):
        self.al_defer_updates_soft()
        try:
            yield self
        finally:
            self.al_process_updates_soft()

    def gen_buffer(self):
        cdef al.ALuint id
        al.alGenBuffers(1, &id)
        check_al_error()
        return Buffer.from_id(self, id)

    def gen_buffers(self, n):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        al.alGenBuffers(n, &ids[0])
        check_al_error()
        return [Buffer.from_id(self, id) for id in ids]

    def gen_source(self, **kwargs):
        cdef al.ALuint id
        al.alGenSources(1, &id)
        check_al_error()
        cdef Source src = Source.from_id(self, id)
        for k, v in kwargs.items(): setattr(src, k, v)
        return src

    def gen_sources(self, n, **kwargs):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        al.alGenSources(n, &ids[0])
        check_al_error()
        cdef list srcs = [Source.from_id(self, id) for id in ids]
        for src in srcs:
            for k, v in kwargs.items(): setattr(src, k, v)
        return srcs

    def play_sources(self, *srcs):
        cdef al.ALuint[:] ids = array.clone(ids_template, len(srcs), zero=False)
        cdef Py_ssize_t i
        for i, s in enumerate(srcs): ids[i] = s.id
        al.alSourcePlayv(ids.size, &ids[0])
        check_al_error()

    def stop_sources(self, *srcs):
        cdef al.ALuint[:] ids = array.clone(ids_template, len(srcs), zero=False)
        cdef Py_ssize_t i
        for i, s in enumerate(srcs): ids[i] = s.id
        al.alSourceStopv(ids.size, &ids[0])
        check_al_error()

    def rewind_sources(self, *srcs):
        cdef al.ALuint[:] ids = array.clone(ids_template, len(srcs), zero=False)
        cdef Py_ssize_t i
        for i, s in enumerate(srcs): ids[i] = s.id
        al.alSourceRewindv(ids.size, &ids[0])
        check_al_error()

    def pause_sources(self, *srcs):
        cdef al.ALuint[:] ids = array.clone(ids_template, len(srcs), zero=False)
        cdef Py_ssize_t i
        for i, s in enumerate(srcs): ids[i] = s.id
        al.alSourcePausev(ids.size, &ids[0])
        check_al_error()

cdef array.array attrs_template = array.array('i')

cdef class ContextAttrs:
    def __cinit__(self, Device dev, array.array attrs):
        self._attrs = attrs
        self._dev = dev

    @staticmethod
    def from_kwargs(Device dev, **kwargs):
        cdef:
            Py_ssize_t length = len(kwargs) * 2 + 1
            array.array attrs_array = array.clone(attrs_template, length, zero=False)
            alc.ALCint[:] attrs = attrs_array
            bytes enum_name
            alc.ALCenum enum_val
            Py_ssize_t idx = 0
        for k, v in kwargs.items():
            enum_name = b"ALC_" + k.upper().encode("utf-8")
            enum_val = alc.alcGetEnumValue(dev._device, <const alc.ALCchar *>enum_name)
            if enum_val == al.AL_NONE:
                raise TypeError(f"'{k} is an invalid keyword argument for ContextAttrs")
            attrs[idx] = enum_val
            attrs[idx+1] = <alc.ALCint>v
            idx += 2
        attrs[idx] = 0
        return ContextAttrs(dev, attrs_array)

    @staticmethod
    def from_device(Device dev):
        cdef alc.ALCint length
        alc.alcGetIntegerv(dev._device, alc.ALC_ATTRIBUTES_SIZE, 1, &length)
        cdef array.array attrs = array.clone(attrs_template, length + 1, zero=False)
        alc.alcGetIntegerv(dev._device, alc.ALC_ALL_ATTRIBUTES, length, <alc.ALCint *>attrs.data.as_voidptr)
        attrs[length] = 0
        return ContextAttrs(dev, attrs)

    def __getattr__(self, attr):
        cdef:
            bytes enum_name = b"ALC_" + attr.upper().encode("utf-8")
            alc.ALCenum enum_val = alc.alcGetEnumValue(self._dev._device, <const alc.ALCchar *>enum_name)
        if enum_val == al.AL_NONE:
            raise AttributeError(f"ContextAttrs object has no attribute '{attr}'")
        cdef Py_ssize_t i
        for i in range(0, self._attrs.size, 2):
            if self._attrs[i] == enum_val:
                return self._attrs[i+1]
        # Not found
        raise AttributeError(f"ContextAttrs object has no attribute '{attr}'")

cdef void wrap_defer_updates():
    alc.alcSuspendContext(alc.alcGetCurrentContext())

cdef void wrap_process_updates():
    alc.alcProcessContext(alc.alcGetCurrentContext())

cdef void no_defer_updates(): pass
cdef void no_process_updates(): pass
