# cython: language_level=3

from cpython cimport array
import array
from contextlib import contextmanager

from .device cimport Device
from .exceptions cimport check_al_error, check_alc_error
from .listener cimport Listener
from .source cimport Source
from . cimport al, alc

cdef array.array ids_template = array.array('I')

cdef class Context:
    def __cinit__(self, Device dev not None, **kwargs):
        self.device = dev
        cdef ContextAttrs attrs = ContextAttrs.from_kwargs(dev, **kwargs)
        self._ctx  =alc.alcCreateContext(dev._device, &attrs._attrs[0])
        if self._ctx is NULL:
            check_alc_error(dev._device)
        self.listener = Listener(self)
        self.al_gen_sources = <void (*)(al.ALsizei, al.ALuint*)>dev.get_al_proc_address("alGenSources")
        self.al_delete_sources = <void (*)(al.ALsizei, al.ALuint*)>dev.get_al_proc_address("alDeleteSources")

    def __dealloc__(self):
        if self._ctx:
            if self._ctx == alc.alcGetCurrentContext():
                alc.alcMakeContextCurrent(NULL)
            alc.alcDestroyContext(self._ctx)

    def get_attrs(self):
        return ContextAttrs.from_device(self.device)

    def make_current(self):
        alc.alcMakeContextCurrent(self._ctx)

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

    def gen_source(self):
        cdef al.ALuint id
        self.al_gen_sources(1, &id)
        check_al_error()
        return Source.from_id(self, id)

    def gen_sources(self, n):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.al_gen_sources(n, &ids[0])
        check_al_error()
        return [Source.from_id(self, id) for id in ids]

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
