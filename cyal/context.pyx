from contextlib import contextmanager

from .device cimport Device
from . cimport alc

cdef class Context:
    cdef alc.ALCcontext* _ctx
    cdef readonly Device device

    def __cinit__(self, Device dev not None):
        self.device = dev
        self._ctx  =alc.alcCreateContext(dev._device, NULL)
        if self._ctx is NULL:
            raise RuntimeError("Context creation failed")

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
        alc.alcMakeContextCurrent(self._ctx)
        try:
            yield self
        finally:
            alc.alcMakeContextCurrent(NULL)

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
