#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "imagequarify.pl [--bordercolor=color] foo1.png [foo2.jpg foo3.tiff ...]

Uses ImageMagick's convert to add a border

Default border is white.
Use --bordercolor=none for transparency (if possible).
";

$bgcolor = "White";

foreach $arg (@ARGV) {
    if ($arg =~ m/^--bordercolor=(.*)$/) {
	$bgcolor = $1;
    } else {
	push(@imagefiles,$arg);
    }
}

foreach $imagefile (@imagefiles) {

    ($squareimagefile = $imagefile) =~ s/\.([a-z]*?)$/-square.$1/;
    if ($squareimagefile eq $imagefile) {
	print "Did not comprehend $imagefile as an image file\n";
	exit;
    }
    print "Creating $squareimagefile ...\n";

    $width = `identify -format "%w" $imagefile`;
    $height = `identify -format "%h" $imagefile`;

    if ($width > $height) {
	$xborder = 0;
	$yborder = sprintf('%d',0.5*($width - $height));
    } else {
	$xborder = sprintf('%d',0.5*($height - $width));
	$yborder = 0;
    }
    $borderdims = $xborder."x".$yborder;

    system("convert -bordercolor $bgcolor -border $borderdims $imagefile $squareimagefile");

}

