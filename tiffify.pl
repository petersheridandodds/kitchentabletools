#!/usr/bin/perl
foreach $pdffigure (@ARGV) {
    ($tifffigure = $pdffigure) =~ s/pdf$/tiff/;
    ##    maximum width = 7.5 * 600  = 4500
    ##  max height is 8.75, * 600 = 5250
    print "Converting $pdffigure ...\n";
    `convert -depth 8 -background white -flatten +matte -geometry 4500x5250 -compress lzw -density 600x600 $pdffigure $tifffigure &`;
    ## http://www.imagemagick.org/script/command-line-processing.php#geometry
}


