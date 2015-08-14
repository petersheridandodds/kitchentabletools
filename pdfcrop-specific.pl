#!/usr/bin/perl

foreach $file (@ARGV) {

    if ($file =~ m/\.pdf$/) {
	($basefilename = $file) =~ s/\.pdf//;
	print "Processing $file ...\n";

	       $command = "gs                               \\
 -o cropped-$basefilename.pdf                 \\
 -sDEVICE=pdfwrite              \\
 -c \"[/CropBox [0 0 800 440]\"   \\
 -c \" /PAGES pdfmark\"           \\
 -f $basefilename.pdf";

	system($command);
    }
}
