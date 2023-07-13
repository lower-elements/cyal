# cython: language_level=3

from cpython cimport array
import array
from collections.abc import Sequence

from . cimport al, alc
from .context cimport Context
from .device cimport Device
from .exceptions cimport check_alc_error, check_al_error
from .util cimport get_al_enum, V3f

cdef array.array ids_template = array.array('I')

cdef class EfxExtension:
    def __cinit__(self, Context ctx not None):
        if alc.alcIsExtensionPresent(ctx.device._device, "ALC_EXT_EFX") == al.AL_FALSE:
            raise RuntimeError("Unsupported extension: ALC_EXT_EFX")
        self.context = ctx

        # Get pointers to all the needed functions
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(ctx._ctx)

        self.alGenEffects = <void (*)(al.ALsizei n, al.ALuint *effects)>al.alGetProcAddress("alGenEffects")
        self.alDeleteEffects = <void (*)(al.ALsizei n, const al.ALuint *effects)>al.alGetProcAddress("alDeleteEffects")
        self.alEffecti = <void (*)(al.ALuint effect, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alEffecti")
        self.alEffectiv = <void (*)(al.ALuint effect, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alEffectiv")
        self.alEffectf = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alEffectf")
        self.alEffectfv = <void (*)(al.ALuint effect, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alEffectfv")
        self.alGetEffecti = <void (*)(al.ALuint effect, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetEffecti")
        self.alGetEffectiv = <void (*)(al.ALuint effect, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetEffectiv")
        self.alGetEffectf = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetEffectf")
        self.alGetEffectfv = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetEffectfv")

        self.alGenFilters = <void (*)(al.ALsizei n, al.ALuint *filters)>al.alGetProcAddress("alGenFilters")
        self.alDeleteFilters = <void (*)(al.ALsizei n, const al.ALuint *filters)>al.alGetProcAddress("alDeleteFilters")
        self.alFilteri = <void (*)(al.ALuint filter, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alFilteri")
        self.alFilteriv = <void (*)(al.ALuint filter, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alFilteriv")
        self.alFilterf = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alFilterf")
        self.alFilterfv = <void (*)(al.ALuint filter, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alFilterfv")
        self.alGetFilteri = <void (*)(al.ALuint filter, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetFilteri")
        self.alGetFilteriv = <void (*)(al.ALuint filter, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetFilteriv")
        self.alGetFilterf = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetFilterf")
        self.alGetFilterfv = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetFilterfv")

        self.alGenAuxiliaryEffectSlots = <void (*)(al.ALsizei n, al.ALuint *effectslots)>al.alGetProcAddress("alGenAuxiliaryEffectSlots")
        self.alDeleteAuxiliaryEffectSlots = <void (*)(al.ALsizei n, const al.ALuint *effectslots)>al.alGetProcAddress("alDeleteAuxiliaryEffectSlots")
        self.alAuxiliaryEffectSloti = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alAuxiliaryEffectSloti")
        self.alAuxiliaryEffectSlotiv = <void (*)(al.ALuint effectslot, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alAuxiliaryEffectSlotiv")
        self.alAuxiliaryEffectSlotf = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alAuxiliaryEffectSlotf")
        self.alAuxiliaryEffectSlotfv = <void (*)(al.ALuint effectslot, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alAuxiliaryEffectSlotfv")
        self.alGetAuxiliaryEffectSloti = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetAuxiliaryEffectSloti")
        self.alGetAuxiliaryEffectSlotiv = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetAuxiliaryEffectSlotiv")
        self.alGetAuxiliaryEffectSlotf = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetAuxiliaryEffectSlotf")
        self.alGetAuxiliaryEffectSlotfv = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetAuxiliaryEffectSlotfv")

        self.AL_METERS_PER_UNIT = alc.alcGetEnumValue(ctx.device._device, "AL_METERS_PER_UNIT")
        self.AL_EFFECT_TYPE = alc.alcGetEnumValue(ctx.device._device, "AL_EFFECT_TYPE")

        # Restore the old context (if any)
        alc.alcMakeContextCurrent(prev_ctx)

    @property
    def version(self):
        cdef alc.ALCenum ver_maj = self.context.device.get_enum_value("ALC_EFX_MAJOR_VERSION")
        cdef alc.ALCenum ver_min = self.context.device.get_enum_value("ALC_EFX_MINOR_VERSION")
        cdef alc.ALCint maj, min
        alc.alcGetIntegerv(self.context.device._device, ver_maj, 1, &maj)
        alc.alcGetIntegerv(self.context.device._device, ver_min, 1, &min)
        check_alc_error(self.context.device._device)
        return (maj, min)

    @property
    def meters_per_unit(self):
        cdef al.ALfloat mpu
        al.alGetListenerf(self.AL_METERS_PER_UNIT, &mpu)
        return mpu

    @meters_per_unit.setter
    def meters_per_unit(self, val):
        al.alListenerf(self.AL_METERS_PER_UNIT, val)
        check_al_error()

    def gen_auxiliary_effect_slot(self, **kwargs):
        cdef al.ALuint id
        self.alGenAuxiliaryEffectSlots(1, &id)
        check_al_error()
        cdef AuxiliaryEffectSlot slot = AuxiliaryEffectSlot.from_id(self, id)
        for k, v in kwargs.items(): setattr(slot, k, v)
        return slot

    def gen_auxiliary_effect_slots(self, n, **kwargs):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.alGenAuxiliaryEffectSlots(n, &ids[0])
        check_al_error()
        cdef list slots = [AuxiliaryEffectSlot.from_id(self, id) for id in ids]
        for slot in slots:
            for k, v in kwargs.items(): setattr(slot, k, v)
        return slots

    def gen_effect(self, **kwargs):
        cdef al.ALuint id
        self.alGenEffects(1, &id)
        check_al_error()
        cdef Effect effect = Effect.from_id(self, id)
        for k, v in kwargs.items(): setattr(effect, k, v)
        return effect

    def gen_effects(self, n, **kwargs):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.alGenEffects(n, &ids[0])
        check_al_error()
        cdef list effects = [Effect.from_id(self, id) for id in ids]
        for effect in effects:
            for k, v in kwargs.items(): setattr(effect, k, v)
        return effects

    def gen_filter(self, **kwargs):
        cdef al.ALuint id
        self.alGenFilters(1, &id)
        check_al_error()
        cdef Filter filter = Filter.from_id(self, id)
        for k, v in kwargs.items(): setattr(filter, k, v)
        return filter

    def gen_filters(self, n, **kwargs):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.alGenFilters(n, &ids[0])
        check_al_error()
        cdef list filters = [Filter.from_id(self, id) for id in ids]
        for filter in filters:
            for k, v in kwargs.items(): setattr(filter, k, v)
        return filters

cdef class AuxiliaryEffectSlot:
    def __cinit__(self):
        pass

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef AuxiliaryEffectSlot from_id(EfxExtension efx, al.ALuint id):
        cdef AuxiliaryEffectSlot slot = AuxiliaryEffectSlot.__new__(AuxiliaryEffectSlot)
        slot.efx = efx
        slot.id = id
        return slot

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.efx.context._ctx)
        self.efx.alDeleteAuxiliaryEffectSlots(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

cdef class Effect:
    def __cinit__(self, **kwargs):
        self._type = "null"
        for prop, val in kwargs.items():
            self.set(prop, val)

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef Effect from_id(EfxExtension efx, al.ALuint id):
        cdef Effect effect = Effect.__new__(Effect)
        effect.efx = efx
        effect.id = id
        return effect

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.efx.context._ctx)
        self.efx.alDeleteEffects(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, val):
        cdef str val_upper = val.upper()
        cdef enum_val = al.alGetEnumValue(b"AL_EFFECT_" + val_upper.encode("utf8"))
        if enum_val == al.AL_NONE:
            raise RuntimeError(f"Could not get enum value for AL_EFFECT_{val_upper}")
        self.efx.alEffecti(self.id, self.efx.AL_EFFECT_TYPE, enum_val)
        check_al_error()
        self._type = val

    def get_int(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALint val
        self.efx.alGetEffecti(self.id, e_val, &val)
        check_al_error()
        return val

    def get_float(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat val
        self.efx.alGetEffectf(self.id, e_val, &val)
        check_al_error()
        return val

    def get_v3f(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] val
        self.efx.alGetEffectfv(self.id, e_val, val)
        check_al_error()
        return V3f(val[0], val[1], val[2])

    def set(self, prop, val):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] data
        if isinstance(val, int):
            self.efx.alEffecti(self.id, e_val, val)
        elif isinstance(val, float):
            self.efx.alEffectf(self.id, e_val, val)
        elif (isinstance(val, Sequence) and len(val) == 3) or isinstance(val, V3f):
            data = [val[0], val[1], val[2]]
            self.efx.alEffectfv(self.id, e_val, data)
        else:
            raise TypeError("Cannot convert to OpenAL type")
        check_al_error()

cdef class Filter:
    def __cinit__(self):
        pass

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    @staticmethod
    cdef Filter from_id(EfxExtension efx, al.ALuint id):
        cdef Filter filter = Filter.__new__(Filter)
        filter.efx = efx
        filter.id = id
        return filter

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.efx.context._ctx)
        self.efx.alDeleteFilters(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)
