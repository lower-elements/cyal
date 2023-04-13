# cython: language_level=3

from cpython cimport array
import array
from contextlib import contextmanager

from .device cimport Device
from .exceptions cimport raise_alc_error
from . cimport al, alc

cdef class Context:
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device

    def __cinit__(self, Device dev not None, **kwargs):
        self.device = dev
        cdef ContextAttrs attrs = ContextAttrs.from_kwargs(dev, **kwargs)
        self._ctx  =alc.alcCreateContext(dev._device, &attrs._attrs[0])
        if self._ctx is NULL:
            raise_alc_error(dev._device)

    def __dealloc__(self):
        if self._ctx:
            if self._ctx == alc.alcGetCurrentContext():
                alc.alcMakeContextCurrent(NULL)
            alc.alcDestroyContext(self._ctx)

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

cdef array.array attrs_template = array.array('i')

cdef class ContextAttrs:
    cdef alc.ALCint[:] _attrs

    def __cinit__(self, array.array attrs):
        self._attrs = attrs

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
        return ContextAttrs(attrs_array)
