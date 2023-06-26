# cython: language_level=3

from .exceptions cimport check_alc_error
from . cimport al, alc
from .context cimport Context
from .device cimport Device

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
