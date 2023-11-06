# cython: language_level=3

from cpython cimport array
import array
from collections.abc import Sequence
from weakref import WeakKeyDictionary

from . cimport al, alc
from .context cimport Context
from .device cimport Device
from .exceptions cimport check_alc_error, check_al_error, UnsupportedExtensionError
from .util cimport get_al_enum, V3f
from .source cimport Source

cdef array.array ids_template = array.array('I')

cdef class EfxExtension:
    def __cinit__(self, Context ctx not None):
        if alc.alcIsExtensionPresent(ctx.device._device, "ALC_EXT_EFX") == al.AL_FALSE:
            raise UnsupportedExtensionError("ALC_EXT_EFX")
        self.context = ctx
        self.source_direct_filters = WeakKeyDictionary()

        # Get pointers to all the needed functions
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(ctx._ctx)

        self.al_gen_effects = <void (*)(al.ALsizei n, al.ALuint *effects)>al.alGetProcAddress("alGenEffects")
        self.al_delete_effects = <void (*)(al.ALsizei n, const al.ALuint *effects)>al.alGetProcAddress("alDeleteEffects")
        self.al_effect_i = <void (*)(al.ALuint effect, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alEffecti")
        self.al_effect_iv = <void (*)(al.ALuint effect, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alEffectiv")
        self.al_effect_f = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alEffectf")
        self.al_effect_fv = <void (*)(al.ALuint effect, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alEffectfv")
        self.al_get_effect_i = <void (*)(al.ALuint effect, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetEffecti")
        self.al_get_effect_iv = <void (*)(al.ALuint effect, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetEffectiv")
        self.al_get_effect_f = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetEffectf")
        self.al_get_effect_fv = <void (*)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetEffectfv")

        self.al_gen_filters = <void (*)(al.ALsizei n, al.ALuint *filters)>al.alGetProcAddress("alGenFilters")
        self.al_delete_filters = <void (*)(al.ALsizei n, const al.ALuint *filters)>al.alGetProcAddress("alDeleteFilters")
        self.al_filter_i = <void (*)(al.ALuint filter, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alFilteri")
        self.al_filter_iv = <void (*)(al.ALuint filter, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alFilteriv")
        self.al_filter_f = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alFilterf")
        self.al_filter_fv = <void (*)(al.ALuint filter, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alFilterfv")
        self.al_get_filter_i = <void (*)(al.ALuint filter, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetFilteri")
        self.al_get_filter_iv = <void (*)(al.ALuint filter, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetFilteriv")
        self.al_get_filter_f = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetFilterf")
        self.al_get_filter_fv = <void (*)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetFilterfv")

        self.al_gen_auxiliary_effect_slots = <void (*)(al.ALsizei n, al.ALuint *effectslots)>al.alGetProcAddress("alGenAuxiliaryEffectSlots")
        self.al_delete_auxiliary_effect_slots = <void (*)(al.ALsizei n, const al.ALuint *effectslots)>al.alGetProcAddress("alDeleteAuxiliaryEffectSlots")
        self.al_auxiliary_effect_slot_i = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint iValue)>al.alGetProcAddress("alAuxiliaryEffectSloti")
        self.al_auxiliary_effect_slot_iv = <void (*)(al.ALuint effectslot, al.ALenum param, const al.ALint *piValues)>al.alGetProcAddress("alAuxiliaryEffectSlotiv")
        self.al_auxiliary_effect_slot_f = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat flValue)>al.alGetProcAddress("alAuxiliaryEffectSlotf")
        self.al_auxiliary_effect_slot_fv = <void (*)(al.ALuint effectslot, al.ALenum param, const al.ALfloat *pflValues)>al.alGetProcAddress("alAuxiliaryEffectSlotfv")
        self.al_get_auxiliary_effect_slot_i = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint *piValue)>al.alGetProcAddress("alGetAuxiliaryEffectSloti")
        self.al_get_auxiliary_effect_slot_iv = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALint *piValues)>al.alGetProcAddress("alGetAuxiliaryEffectSlotiv")
        self.al_get_auxiliary_effect_slot_f = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValue)>al.alGetProcAddress("alGetAuxiliaryEffectSlotf")
        self.al_get_auxiliary_effect_slot_fv = <void (*)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValues)>al.alGetProcAddress("alGetAuxiliaryEffectSlotfv")

        self.al_meters_per_unit = alc.alcGetEnumValue(ctx.device._device, b"AL_METERS_PER_UNIT")
        self.alc_max_auxiliary_sends = alc.alcGetEnumValue(ctx.device._device, b"ALC_MAX_AUXILIARY_SENDS")
        self.al_effect_type = alc.alcGetEnumValue(ctx.device._device, b"AL_EFFECT_TYPE")
        self.al_filter_type = alc.alcGetEnumValue(ctx.device._device, b"AL_FILTER_TYPE")
        self.al_effectslot_effect = alc.alcGetEnumValue(ctx.device._device, b"AL_EFFECTSLOT_EFFECT")
        self.al_effect_null = alc.alcGetEnumValue(ctx.device._device, b"AL_EFFECT_NULL")
        self.al_filter_null = alc.alcGetEnumValue(ctx.device._device, b"AL_FILTER_NULL")
        self.al_direct_filter = alc.alcGetEnumValue(ctx.device._device, b"AL_DIRECT_FILTER")

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
        al.alGetListenerf(self.al_meters_per_unit, &mpu)
        return mpu

    @meters_per_unit.setter
    def meters_per_unit(self, val):
        al.alListenerf(self.al_meters_per_unit, val)
        check_al_error()

    @property
    def max_auxiliary_sends(self):
        cdef al.ALint val
        alc.alcGetIntegerv(self.context.device._device, self.alc_max_auxiliary_sends, 1, &val)
        check_alc_error(self.context.device._device)
        return val

    def gen_auxiliary_effect_slot(self, **kwargs):
        cdef al.ALuint id
        self.al_gen_auxiliary_effect_slots(1, &id)
        check_al_error()
        cdef AuxiliaryEffectSlot slot = AuxiliaryEffectSlot.from_id(self, id)
        for k, v in kwargs.items(): setattr(slot, k, v)
        return slot

    def gen_auxiliary_effect_slots(self, n, **kwargs):
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.al_gen_auxiliary_effect_slots(n, &ids[0])
        check_al_error()
        cdef list slots = [AuxiliaryEffectSlot.from_id(self, id) for id in ids]
        for slot in slots:
            for k, v in kwargs.items(): setattr(slot, k, v)
        return slots

    def gen_effect(self, type cls=Effect, **kwargs):
        if not issubclass(cls, Effect):
            raise TypeError("cls argument must be a subclass of cyal.efx.Effect")
        cdef al.ALuint id
        self.al_gen_effects(1, &id)
        check_al_error()
        return make_effect(cls, self, id, kwargs)

    def gen_effects(self, n, type cls=Effect, **kwargs):
        if not issubclass(cls, Effect):
            raise TypeError("cls argument must be a subclass of cyal.efx.Effect")
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.al_gen_effects(n, &ids[0])
        check_al_error()
        return [make_effect(cls, self, id, kwargs) for id in ids]

    def gen_filter(self, type cls=Filter, **kwargs):
        if not issubclass(cls, Filter):
            raise TypeError("cls argument must be a subclass of cyal.efx.Filter")
        cdef al.ALuint id
        self.al_gen_filters(1, &id)
        check_al_error()
        return make_filter(cls, self, id, kwargs)

    def gen_filters(self, n, type cls=Filter, **kwargs):
        if not issubclass(cls, Filter):
            raise TypeError("cls argument must be a subclass of cyal.efx.Filter")
        cdef al.ALuint[:] ids = array.clone(ids_template, n, zero=False)
        self.al_gen_filters(n, &ids[0])
        check_al_error()
        return [make_filter(cls, self, id, kwargs) for id in ids]

    def set_filter(self, source, filter):
        if not isinstance(source, Source):
            raise TypeError("source argument must be a subclass of cyal.source.Source")
        if not isinstance(filter, Filter):
            raise TypeError("filter argument must be a subclass of cyal.efx.Filter")
        al.alSourcei(source.id, self.al_direct_filter, filter.id)
        check_al_error()
        # Remember which Filter is attached to this Source
        self.source_direct_filters[source] = filter

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
        self.efx.al_delete_auxiliary_effect_slots(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    @property
    def effect(self):
        return self._effect

    @effect.setter
    def effect(self, effect):
        if not isinstance(effect, Effect):
            raise TypeError("effect argument must be a subclass of cyal.efx.Effect")
        self.efx.al_auxiliary_effect_slot_i(self.id, self.efx.al_effectslot_effect, effect.id)
        check_al_error()
        # Keep a reference, the Effect can't be freed while still in use
        self._effect = effect

    @effect.deleter
    def effect(self):
        self.efx.al_auxiliary_effect_slot_i(self.id, self.efx.al_effectslot_effect, self.efx.al_effect_null)
        check_al_error()
        self._effect = None

cdef class Effect:
    def __cinit__(self):
        self._type = "null"

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    cdef void init_with_id(self, EfxExtension efx, al.ALuint id):
        self.efx = efx
        self.id = id

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.efx.context._ctx)
        self.efx.al_delete_effects(1, &self.id)
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
        self.efx.al_effect_i(self.id, self.efx.al_effect_type, enum_val)
        check_al_error()
        self._type = val

    def get_int(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALint val
        self.efx.al_get_effect_i(self.id, e_val, &val)
        check_al_error()
        return val

    def get_float(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat val
        self.efx.al_get_effect_f(self.id, e_val, &val)
        check_al_error()
        return val

    def get_v3f(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] val
        self.efx.al_get_effect_fv(self.id, e_val, val)
        check_al_error()
        return V3f(val[0], val[1], val[2])

    def set(self, prop, val):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] data
        if isinstance(val, int):
            self.efx.al_effect_i(self.id, e_val, val)
        elif isinstance(val, float):
            self.efx.al_effect_f(self.id, e_val, val)
        elif (isinstance(val, Sequence) and len(val) == 3) or isinstance(val, V3f):
            data = [val[0], val[1], val[2]]
            self.efx.al_effect_fv(self.id, e_val, data)
        else:
            raise TypeError(f"Cannot convert {type(val)} to OpenAL type")
        check_al_error()

cdef class Filter:
    def __cinit__(self):
        self._type = "null"

    def __init__(self):
        raise TypeError("This class cannot be instantiated directly.")

    cdef void init_with_id(self, EfxExtension efx, al.ALuint id):
        self.efx = efx
        self.id = id

    def __dealloc__(self):
        cdef alc.ALCcontext* prev_ctx = alc.alcGetCurrentContext()
        alc.alcMakeContextCurrent(self.efx.context._ctx)
        self.efx.al_delete_filters(1, &self.id)
        alc.alcMakeContextCurrent(prev_ctx)

    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, val):
        cdef str val_upper = val.upper()
        cdef enum_val = al.alGetEnumValue(b"AL_FILTER_" + val_upper.encode("utf8"))
        if enum_val == al.AL_NONE:
            raise RuntimeError(f"Could not get enum value for AL_FILTER_{val_upper}")
        self.efx.al_filter_i(self.id, self.efx.al_filter_type, enum_val)
        check_al_error()
        self._type = val

    def get_int(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALint val
        self.efx.al_get_filter_i(self.id, e_val, &val)
        check_al_error()
        return val

    def get_float(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat val
        self.efx.al_get_filter_f(self.id, e_val, &val)
        check_al_error()
        return val

    def get_v3f(self, prop):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] val
        self.efx.al_get_filter_fv(self.id, e_val, val)
        check_al_error()
        return V3f(val[0], val[1], val[2])

    def set(self, prop, val):
        cdef al.ALenum e_val = get_al_enum(self._type + "_" + prop)
        cdef al.ALfloat[3] data
        if isinstance(val, int):
            self.efx.al_filter_i(self.id, e_val, val)
        elif isinstance(val, float):
            self.efx.al_filter_f(self.id, e_val, val)
        elif (isinstance(val, Sequence) and len(val) == 3) or isinstance(val, V3f):
            data = [val[0], val[1], val[2]]
            self.efx.al_filter_fv(self.id, e_val, data)
        else:
            raise TypeError(f"Cannot convert {type(val)} to OpenAL type")
        check_al_error()

cdef object make_effect(type cls, EfxExtension efx, al.ALuint id, dict kwargs):
    cdef Effect effect = <Effect>cls.__new__(cls)
    effect.init_with_id(efx, id)
    for k, v in kwargs.items(): effect.set(k, v)
    return effect

cdef object make_filter(type cls, EfxExtension efx, al.ALuint id, dict kwargs):
    cdef Filter filter = <Filter>cls.__new__(cls)
    filter.init_with_id(efx, id)
    for k, v in kwargs.items(): filter.set(k, v)
    return filter
