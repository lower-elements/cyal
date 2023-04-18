""" Capture 5 seconds of audio at 48000 hz, using the OpenAL capture extension,
and writing it to a wave file with the builtin wave module.
"""

import cyal, wave

FREQ = 48000

ext = cyal.CaptureExtension()
dev = ext.open_device(sample_rate=FREQ)
total = 0
with wave.open("out.wav", "w") as w:
    w.setnchannels(1)
    w.setsampwidth(2)
    w.setframerate(FREQ)
    with dev.capturing():
        while total < FREQ * 5:
            bytes = dev.available_samples * 2
            print(bytes)
            buf = bytearray(bytes)
            dev.capture_samples(buf)
            w.writeframes(buf)
            total += bytes
