# cython: language_level=3

from . cimport al, alc
from .context cimport Context

cdef class EfxExtension:
    cdef object __weakref__
    cdef readonly Context context

    # Function pointers
    cdef void (*alGenEffects)(al.ALsizei n, al.ALuint *effects)
    cdef void (*alDeleteEffects)(al.ALsizei n, const al.ALuint *effects)
    cdef void (*alEffecti)(al.ALuint effect, al.ALenum param, al.ALint iValue)
    cdef void (*alEffectiv)(al.ALuint effect, al.ALenum param, const al.ALint *piValues)
    cdef void (*alEffectf)(al.ALuint effect, al.ALenum param, al.ALfloat flValue)
    cdef void (*alEffectfv)(al.ALuint effect, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*alGetEffecti)(al.ALuint effect, al.ALenum param, al.ALint *piValue)
    cdef void (*alGetEffectiv)(al.ALuint effect, al.ALenum param, al.ALint *piValues)
    cdef void (*alGetEffectf)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*alGetEffectfv)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValues)

    cdef void (*alGenFilters)(al.ALsizei n, al.ALuint *filters)
    cdef void (*alDeleteFilters)(al.ALsizei n, const al.ALuint *filters)
    cdef void (*alFilteri)(al.ALuint filter, al.ALenum param, al.ALint iValue)
    cdef void (*alFilteriv)(al.ALuint filter, al.ALenum param, const al.ALint *piValues)
    cdef void (*alFilterf)(al.ALuint filter, al.ALenum param, al.ALfloat flValue)
    cdef void (*alFilterfv)(al.ALuint filter, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*alGetFilteri)(al.ALuint filter, al.ALenum param, al.ALint *piValue)
    cdef void (*alGetFilteriv)(al.ALuint filter, al.ALenum param, al.ALint *piValues)
    cdef void (*alGetFilterf)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*alGetFilterfv)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValues)

    cdef void (*alGenAuxiliaryEffectSlots)(al.ALsizei n, al.ALuint *effectslots)
    cdef void (*alDeleteAuxiliaryEffectSlots)(al.ALsizei n, const al.ALuint *effectslots)
    cdef void (*alAuxiliaryEffectSloti)(al.ALuint effectslot, al.ALenum param, al.ALint iValue)
    cdef void (*alAuxiliaryEffectSlotiv)(al.ALuint effectslot, al.ALenum param, const al.ALint *piValues)
    cdef void (*alAuxiliaryEffectSlotf)(al.ALuint effectslot, al.ALenum param, al.ALfloat flValue)
    cdef void (*alAuxiliaryEffectSlotfv)(al.ALuint effectslot, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*alGetAuxiliaryEffectSloti)(al.ALuint effectslot, al.ALenum param, al.ALint *piValue)
    cdef void (*alGetAuxiliaryEffectSlotiv)(al.ALuint effectslot, al.ALenum param, al.ALint *piValues)
    cdef void (*alGetAuxiliaryEffectSlotf)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*alGetAuxiliaryEffectSlotfv)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValues)

    # Enum values
    cdef al.ALenum AL_METERS_PER_UNIT
    cdef alc.ALCenum alc_max_auxiliary_sends
    cdef al.ALenum AL_EFFECT_TYPE
    cdef al.ALenum AL_FILTER_TYPE

cdef class AuxiliaryEffectSlot:
    cdef object __weakref__
    cdef readonly EfxExtension efx
    cdef readonly al.ALuint id

    @staticmethod
    cdef AuxiliaryEffectSlot from_id(EfxExtension efx, al.ALuint id)

cdef class Effect:
    cdef object __weakref__
    cdef readonly EfxExtension efx
    cdef readonly al.ALuint id
    cdef str _type

    cdef void init_with_id(self, EfxExtension efx, al.ALuint id)

cdef class Filter:
    cdef object __weakref__
    cdef readonly EfxExtension efx
    cdef readonly al.ALuint id
    cdef str _type

    cdef void init_with_id(self, EfxExtension efx, al.ALuint id)
