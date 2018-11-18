#!/bin/bash

# set this to (at least) the number of processor cores on your system
NUM_THREADS=6
# total number of frames to render (will always be a full cycle of sin(x))
STEP_SIZE=126
NUM_HARMONICS=4

# requires: imagemagick
IMGCVT=convert

# matlab cli (just use octave, ya know)
MATLAB=octave-cli
MATLABFUNC=sinplotmultiple

# requires ffmpeg
FFMPEG=ffmpeg

# render each of the frames in a parallel instance of Octave
for i in `seq 1 $NUM_THREADS`; do
	echo "$MATLABFUNC($i, $NUM_THREADS, $STEP_SIZE, $NUM_HARMONICS)"
	echo "$MATLABFUNC($i, $NUM_THREADS, $STEP_SIZE, $NUM_HARMONICS)" | $MATLAB &
done
wait # for the forked processes to all finish

echo "==== MATLAB COMPLETE ===="


# convert each rendered PDF to an appropriately rasterized PNG
PDFSTOCONVERT=`find ./ | grep -e "\.\/[0-9]\{5\}\.pdf$"`

(
for i in $PDFSTOCONVERT; do
	if [ ! -e $i.png ]; then
		# This line forces NUM_THREADS jobs to be spooled up at a time
		((x=x%NUM_THREADS)); ((x++==0)) && wait
		echo $i;
		# change this line to crop and scale for the desired resolution
		$IMGCVT -density 201 -strip -crop 3840x2160+9+4 $i $i.png &
	fi
done
)


# once we have all the PNGs, make that movie
$FFMPEG -framerate 60 -i %05d.pdf.png -c:v libx264 -vf "fps=60,format=yuv420p" \
	animation.mp4 # change this to desired movie name

# (un)comment this if you want to clean up the PDFs and PNGs once the render is
# done. if you're doing multiple runs in the same directory, you may or may not
# want to clobber everything.
if [ $? -eq 0 ]; then
	rm $PDFSTOCONVERT
	rm `find ./ | grep -e "\.\/[0-9]\{5\}\.pdf\.png$"`
fi
