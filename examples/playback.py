import cyal, math, time, wave

# Open an OpenAL device and create a Context from it
# Unknown keyword arguments such as hrtf_soft below are passed directly to OpenAL. The hrtf_soft=1 argument enables
# OpenAL Soft's Head Related Transfer Function processing
ctx = cyal.Context(cyal.Device(), make_current=True, hrtf_soft=1)

# Create two buffer objects to load the left and right channel audio into
# We use two separate buffers so they can be attached to two separate sources, and moved around the world separately
# Context.gen_buffers(n) may be faster than Context.gen_buffer() when generating Buffer objects in bulk
left_buf, right_buf = ctx.gen_buffers(2)

# Load wave data into the buffers
# This uses Python's built-in wave module to load the audio from wave files in the examples directory
# Music by Mudb0y <https://soundcloud.com/mudb0y>
with wave.open("beat2-left.wav", "r") as w:
    data = w.readframes(w.getnframes())
    left_buf.set_data(data, sample_rate=w.getframerate(), format=cyal.BufferFormat.MONO16)

with wave.open("beat2-right.wav", "r") as w:
    data = w.readframes(w.getnframes())
    right_buf.set_data(data, sample_rate=w.getframerate(), format=cyal.BufferFormat.MONO16)

# Generate Source objects
# You can pass properties to the Context.gen_*() functions, they will be set on the returned objects
# In this case, ctx.gen_sources(2 ...
left_src, right_src = ctx.gen_sources(2, looping=True)
# ... is the same as ...
# left_src, right_src = ctx.gen_sources(2)
# left_src.looping = True
# right_src.looping = True

# Assign the buffers to the sources
left_src.buffer = left_buf
right_src.buffer = right_buf

# Set source positions
# OpenAL's coordinates are left-handed: +x = right, +y = up, +z = backwards
# This sets the two sources to be in front of the listener at the start, separated as if they were stereo speakers in a room
left_src.position = [-1.5, 0, -1]
right_src.position = [1.5, 0, -1]

# Set listener properties (these are the defaults)
ctx.listener.position = [0, 0, 0]
# The first 3 coordinates are the facing direction, the last 3 are the up direction
ctx.listener.orientation = [0, 0, -1, 0, 1, 0]

# Start playback of both sources
# You can call Source.play() on a single source, but Context.play_sources() ensures that the sources start playback
# atomically, at *exactly* the same time
ctx.play_sources(left_src, right_src)

# Spin the listener around in a circle
angle = 0.0
while True:
    # Calculate the new coordinates (Y remains constant)
    new_x = math.sin(angle)
    new_z = math.cos(angle)
    # Update the listener orientation
    ctx.listener.orientation = [new_x, 0, new_z, 0, 1, 0]
    angle += 0.01
    time.sleep(0.02)
