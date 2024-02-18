# cython: language_level=3

from . cimport al, alc
from .device cimport Device
from .exceptions cimport check_alc_error, UnsupportedExtensionError

cdef class HrtfExtension:
    def __cinit__(self, Device device not None):
        if alc.alcIsExtensionPresent(device._device, b"ALC_SOFT_HRTF") != al.AL_TRUE:
            raise UnsupportedExtensionError("ALC_SOFT_HRTF")

        self.device = device

        # Function pointers
        self.alc_get_string_i_soft = <const alc.ALCchar *(*)(alc.ALCdevice*, alc.ALCenum, alc.ALCsizei)>alc.alcGetProcAddress(device._device, b"alcGetStringiSOFT")

        # Enum values
        self.alc_hrtf_soft = alc.alcGetEnumValue(device._device, b"ALC_HRTF_SOFT")
        self.alc_hrtf_id_soft = alc.alcGetEnumValue(device._device, b"ALC_HRTF_ID_SOFT")
        self.alc_hrtf_id_soft = alc.alcGetEnumValue(device._device, b"ALC_HRTF_ID_SOFT")
        self.DONT_CARE = alc.alcGetEnumValue(device._device, b"ALC_DONT_CARE_SOFT")
        self.alc_hrtf_status_soft = alc.alcGetEnumValue(device._device, b"ALC_HRTF_STATUS_SOFT")
        self.alc_num_hrtf_specifiers_soft = alc.alcGetEnumValue(device._device, b"ALC_NUM_HRTF_SPECIFIERS_SOFT")
        self.alc_hrtf_specifier_soft = alc.alcGetEnumValue(device._device, b"ALC_HRTF_SPECIFIER_SOFT")

        self.DISABLED = alc.alcGetEnumValue(device._device, b"ALC_HRTF_DISABLED_SOFT")
        self.ENABLED = alc.alcGetEnumValue(device._device, b"ALC_HRTF_ENABLED_SOFT")
        self.DENIED = alc.alcGetEnumValue(device._device, b"ALC_HRTF_DENIED_SOFT")
        self.REQUIRED = alc.alcGetEnumValue(device._device, b"ALC_HRTF_REQUIRED_SOFT")
        self.HEADPHONES_DETECTED = alc.alcGetEnumValue(device._device, b"ALC_HRTF_HEADPHONES_DETECTED_SOFT")
        self.UNSUPPORTED_FORMAT = alc.alcGetEnumValue(device._device, b"ALC_HRTF_UNSUPPORTED_FORMAT_SOFT")

    def __iter__(self) -> HrtfModelIterator:
        return HrtfModelIterator(self)

    def __len__(self):
        cdef alc.ALCint val
        alc.alcGetIntegerv(self.device._device, self.alc_num_hrtf_specifiers_soft, 1, &val)
        check_alc_error(self.device._device)
        return val

    def __getitem__(self, index: int) -> str:
        cdef alc.ALCchar *val = self.alc_get_string_i_soft(self.device._device, self.alc_hrtf_specifier_soft, index)
        if val is NULL:
            raise IndexError("OpenAL HRTF model index out of range")
        return val.decode("utf8")

    def models(self) -> HrtfModelIterator:
        return HrtfModelIterator(self)
    
    cpdef alc.ALCint find_model(self, str model):
        cdef HrtfModelIterator iter = self.models()
        for m in iter:
            if m == model:
                return iter.current_index - 1
        raise ValueError(f"Could not find HRTF model: \"{model}\"")

    def use(self, model: str | int | None):
        if model is None: self.enabled = False
        elif isinstance(model, int): self.current_model_index = model
        elif isinstance(model, str): self.current_model_index = self.find_model(model)
        else: raise TypeError(f"Model must be of type str, int or None, got {type(model)}")

    @property
    def enabled(self) -> bool:
        cdef alc.ALCint val
        alc.alcGetIntegerv(self.device._device, self.alc_hrtf_soft, 1, &val)
        check_alc_error(self.device._device)
        return val == al.AL_TRUE

    @enabled.setter
    def enabled(self, val: bool | int):
        cdef alc.ALCint[3] attrs = [self.alc_hrtf_soft, val, 0]
        if not self.device.alc_reset_device_soft(self.device._device, attrs):
            check_alc_error(self.device._device)

    @property
    def status(self) -> int:
        cdef alc.ALCint val
        alc.alcGetIntegerv(self.device._device, self.alc_hrtf_status_soft, 1, &val)
        check_alc_error(self.device._device)
        return val

    @property
    def current_model(self) -> str:
        cdef alc.ALCchar *val = alc.alcGetString(self.device._device, self.alc_hrtf_specifier_soft)
        if val is NULL:
            check_alc_error(self.device._device)
        return None if val == b"" else val.decode("utf8")

    @current_model.setter
    def current_model(self, model: str):
        self.current_model_index = self.find_model(model)

    @property
    def current_model_index(self) -> int:
        return -1 if self.current_model is None else self.find_model(self.current_model)

    @current_model_index.setter
    def current_model_index(self, index: int):
        cdef alc.ALCint[5] attrs = [self.alc_hrtf_soft, al.AL_TRUE, self.alc_hrtf_id_soft, index, 0]
        if not self.device.alc_reset_device_soft(self.device._device, attrs):
            check_alc_error(self.device._device)

cdef class HrtfModelIterator:
    def __cinit__(self, HrtfExtension hrtf not None):
        self.hrtf = hrtf
        self.current_index = 0
        alc.alcGetIntegerv(hrtf.device._device, hrtf.alc_num_hrtf_specifiers_soft, 1, &self.num_specifiers)
        check_alc_error(hrtf.device._device)

    def __len__(self) -> int:
        return self.num_specifiers

    def __iter__(self):
        return self

    def __next__(self) -> str:
        if self.current_index >= self.num_specifiers:
            raise StopIteration
        cdef const alc.ALCchar *val = self.hrtf.alc_get_string_i_soft(self.hrtf.device._device, self.hrtf.alc_hrtf_specifier_soft, self.current_index)
        self.current_index += 1
        return val.decode("utf8")
