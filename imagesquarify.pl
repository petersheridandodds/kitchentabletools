#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "imagesquarify.pl [--bordercolor=color] foo1.png [foo2.jpg foo3.tiff ...]

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
    ($x100imagefile = $imagefile) =~ s/\.([a-z]*?)$/-100x100.$1/;
    ($x200imagefile = $imagefile) =~ s/\.([a-z]*?)$/-200x200.$1/;
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
    system("convert  -scale 100x100 $squareimagefile $x100imagefile");
    system("convert  -scale 200x200 $squareimagefile $x200imagefile");
}

