cdef class CyalError(Exception):
    pass

cdef class DeviceNotFoundError(CyalError):
    cdef readonly bytes device_name

    def __cinit__(self, *args, **kwargs):
        self.device_name = kwargs.get("device_name", None)

    def __init__(self, *args, **kwargs):
        super().__init__(*args)

    def __str__(self):
        if self.device_name is None:
            return "No OpenAL devices found"
        else:
            return f"OpenAL device {self.device_name} not found"
