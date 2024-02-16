# cython: language_level=3

from . cimport al, alc
from .context cimport Context

cdef class EfxExtension:
    cdef object __weakref__
    cdef readonly Context context
    cdef object _source_effectslot_sends
    cdef object _source_filter_sends

    # Function pointers
    cdef void (*al_gen_effects)(al.ALsizei n, al.ALuint *effects)
    cdef void (*al_delete_effects)(al.ALsizei n, const al.ALuint *effects)
    cdef void (*al_effect_i)(al.ALuint effect, al.ALenum param, al.ALint iValue)
    cdef void (*al_effect_iv)(al.ALuint effect, al.ALenum param, const al.ALint *piValues)
    cdef void (*al_effect_f)(al.ALuint effect, al.ALenum param, al.ALfloat flValue)
    cdef void (*al_effect_fv)(al.ALuint effect, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*al_get_effect_i)(al.ALuint effect, al.ALenum param, al.ALint *piValue)
    cdef void (*al_get_effect_iv)(al.ALuint effect, al.ALenum param, al.ALint *piValues)
    cdef void (*al_get_effect_f)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*al_get_effect_fv)(al.ALuint effect, al.ALenum param, al.ALfloat *pflValues)

    cdef void (*al_gen_filters)(al.ALsizei n, al.ALuint *filters)
    cdef void (*al_delete_filters)(al.ALsizei n, const al.ALuint *filters)
    cdef void (*al_filter_i)(al.ALuint filter, al.ALenum param, al.ALint iValue)
    cdef void (*al_filter_iv)(al.ALuint filter, al.ALenum param, const al.ALint *piValues)
    cdef void (*al_filter_f)(al.ALuint filter, al.ALenum param, al.ALfloat flValue)
    cdef void (*al_filter_fv)(al.ALuint filter, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*al_get_filter_i)(al.ALuint filter, al.ALenum param, al.ALint *piValue)
    cdef void (*al_get_filter_iv)(al.ALuint filter, al.ALenum param, al.ALint *piValues)
    cdef void (*al_get_filter_f)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*al_get_filter_fv)(al.ALuint filter, al.ALenum param, al.ALfloat *pflValues)

    cdef void (*al_gen_auxiliary_effect_slots)(al.ALsizei n, al.ALuint *effectslots)
    cdef void (*al_delete_auxiliary_effect_slots)(al.ALsizei n, const al.ALuint *effectslots)
    cdef void (*al_auxiliary_effect_slot_i)(al.ALuint effectslot, al.ALenum param, al.ALint iValue)
    cdef void (*al_auxiliary_effect_slot_iv)(al.ALuint effectslot, al.ALenum param, const al.ALint *piValues)
    cdef void (*al_auxiliary_effect_slot_f)(al.ALuint effectslot, al.ALenum param, al.ALfloat flValue)
    cdef void (*al_auxiliary_effect_slot_fv)(al.ALuint effectslot, al.ALenum param, const al.ALfloat *pflValues)
    cdef void (*al_get_auxiliary_effect_slot_i)(al.ALuint effectslot, al.ALenum param, al.ALint *piValue)
    cdef void (*al_get_auxiliary_effect_slot_iv)(al.ALuint effectslot, al.ALenum param, al.ALint *piValues)
    cdef void (*al_get_auxiliary_effect_slot_f)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValue)
    cdef void (*al_get_auxiliary_effect_slot_fv)(al.ALuint effectslot, al.ALenum param, al.ALfloat *pflValues)

    # Enum values
    cdef al.ALenum al_meters_per_unit
    cdef alc.ALCenum alc_max_auxiliary_sends

    cdef al.ALenum al_effect_type
    cdef al.ALenum al_effect_null

    cdef al.ALenum al_filter_type
    cdef al.ALenum al_filter_null
    cdef al.ALenum al_direct_filter

    cdef al.ALenum al_effectslot_effect
    cdef al.ALenum al_effectslot_null
    cdef al.ALenum al_auxiliary_send_filter
    cdef al.ALenum al_effectslot_gain
    cdef al.ALenum al_effectslot_auxiliary_send_auto
    cdef al.ALenum al_effectslot_target_soft # Provided by AL_SOFT_effect_target

cdef class AuxiliaryEffectSlot:
    cdef object __weakref__
    cdef readonly EfxExtension efx
    cdef Effect _effect
    cdef AuxiliaryEffectSlot _target
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
