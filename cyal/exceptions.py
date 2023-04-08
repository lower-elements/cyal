class CyalError(Exception):
    pass


class DeviceNotFoundError(CyalError):
    __slots__ = ["device_name"]

    def __init__(self, *args, **kwargs):
        super().__init__(*args)
        self.device_name = kwargs.get("device_name", None)

    def __str__(self):
        if self.device_name is None:
            return "No OpenAL devices found"
        else:
            return f"OpenAL device {self.device_name} not found"
