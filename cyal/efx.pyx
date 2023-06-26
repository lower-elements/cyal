# cython: language_level=3

from cpython cimport array
import array

from . cimport al, alc
from .context cimport Context
from .device cimport Device
from .exceptions cimport check_alc_error, check_al_error

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

        # Restore the old context (if any)
        alc.alcMakeContextCurrent(prev_ctx)

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
    def __cinit__(self):
        pass

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
