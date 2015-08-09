#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

# usage: optimizepdf foo1.pdf [foo2.pdf ... ]
# creates foo1-optimized.pdf ...

# uses ghostscript command-line tool to optimize overly large pdfs 
# (for example, ones containing many high resolution raster images)

# peter sheridan dodds
# 2015-04-16

foreach $file (@ARGV) {
    if ($file =~ m/\.pdf$/) {
	($outfile = $file) =~ s/\.pdf$/-optimized\.pdf/;
	print "creating $outfile ...\n";
	`gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/default -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$outfile $file`
    }
}
