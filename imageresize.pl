#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "imageresize.pl width imagefile1 imagefile2 ...\n";

$width = $ARGV[0];
$widthtext = "$width"."px";
$dimensions = "$width"."x";

if ($width !~ m/^\d+$/) {
    print "error:\n";
    print $usage;
    exit;
}

foreach $imagefile (@ARGV[1..$#ARGV]) {
	if ($imagefile =~ m/\.[a-z]+?$/) {
	    ($newfile = $imagefile) =~ s/(\.[a-z]+?)$/_$widthtext$1/;
	    print "converting $imagefile to $newfile ...\n";
	    `convert -geometry $dimensions $imagefile $newfile`;
    }
}
