#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

foreach $pdffigure (@ARGV) {
    ($tifffigure = $pdffigure) =~ s/pdf$/tiff/;
##    maximum width = 7.5 * 600
    print "Converting $pdffigure ...\n";
    `convert -depth 8 -background white -flatten +matte -geometry 4500x -compress lzw -density 900x900 $pdffigure $tifffigure &`;
}

