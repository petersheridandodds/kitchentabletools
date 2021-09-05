#!/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

# expects sensible input of small videos

foreach $file (@ARGV) {
    ($outfile = $file) =~ s/\.???$/.gif/;
    `ffmpeg -i $file -vf scale=320:-1 -r 10 -f image2pipe -vcodec ppm - | convert -delay 5 -loop 0 - ffmpeg -i $outfile 1>&2`;
}
