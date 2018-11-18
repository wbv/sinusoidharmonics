THE LEAST EFFICIENT WAY TO ANIMATE SINUSOIDAL HARMONICS EVER INVENTED
=====================================================================

If you've made the mistake of coming here, the packages you need are:

- GNU Octave (I used 4.4.1)
- ImageMagick (I used 6.9.7.4)
- ffmpeg (I used 3.2.12)

(Disclaimer: I live on debian stable, no clue if it works on other distros)

Usage
======

Read and adjust parameters in `render.sh` to your liking. Consider doing 
`STEP_SIZE=100` and `NUM_HARMONICS=4` or similar to test it out first. It won't
look right unless you have either a small number of x's (harmonics) or a large
number of cycles.

If that works, you can get a pretty cool looking animation (after quite some
time) with `STEP_SIZE=10240` and `NUM_HARMONICS=64`.

By default, the video is rendered in 4K. Adjust the ImageMagick flags to
render a more sane size (i.e. `-density 76 -crop 1280x768+0+0`)

Then:

```
./render.sh
```

(wait some time)

