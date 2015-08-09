#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

use List::Util qw(sum);

$usage = "makecollage-packed.pl [--test] --fraction=0.6 --numrows=15 --width=20 --height=30 --rowheight=960 --outputfilename=foo-collage.jpg foo001.jpg [foo002.jpg ...]

Presumes all arguments are provided
--test is not yet functional

Creates a collage of images, handling irregular sets (square, panorama).
Packs images reasonably well but will require some tests
for the right number of rows.

Uses the magnficence that is ImageMagick.

Used successfully for 100 to 120 photos combined into one poster.

Good form: number photos to be packed with %03d (foo001.jpg, foo002.jpg).
iPhoto will export photos in a reasonable way but may need to clean
out spaces.

Store choice for following in a shell script for easy experimentation
and as a record.

fraction:
maximum fraction of the last image in row  that is allowed to go beyond average row length.
if exceeded, move imaage to next row.
0.55 seems to work okay but experimentation may be needed

numrows = number of rows of images
 e.g., 10 for 100 images of 3:2 shape for a 30x20 poster
 15 or 16 for a 2:3 shape

outputfilename = base for output file names

width and height are relative and dimensionless
they are used only to give an aspect ratio (= width/height)
e.g.,
30/20 = 1.5 for landscape 30x20 poster
but 3/2 will do the same job.

20/30 = 0.666 for portrait 20x30 poster

";

if ($#ARGV < 0) { 
    print $usage;
    exit;
};

undef @imagenames;
$test = "no";
foreach $arg (@ARGV) {
    if ($arg =~ m/^--test/) {
	$test = "yes";} 
    elsif ($arg =~ m/^--fraction=(.*)/) {
	$fraction = $1;
    } elsif ($arg =~ m/^--numrows=(.*)/) {
	$numrows = $1;
    } elsif ($arg =~ m/^--width=(.*)/) {
	$width = $1;
    } elsif ($arg =~ m/^--height=(.*)/) {
	$height = $1;
    }
    elsif ($arg =~ m/^--rowheight=(.*)/) {
	$rowheight = $1;
    }
    elsif ($arg =~ m/^--outputfilename=(.*)/) {
	$outputfilename = $1;
    }
    elsif ($arg =~ m/\.jpg$/) {
	push(@imagenames, $arg);
    } else {
	print "Argument $arg is uncool.";
	exit;
    }
}

$required_aspectratio = 1.0*$width/$height;


# if needed, create reduced size images
# delete these later by hand
# widths are based on these versions
foreach $imagename (@imagenames) { 
    ($imagename_normalized = $imagename) =~ s/\.jpg$/_x$rowheight.jpg/;
    push (@imagenames_normalized, $imagename_normalized);
    unless (-e $imagename_normalized) {
	print "converting $imagename ...\n";
	`convert -geometry x$rowheight $imagename -bordercolor 'rgb(175,175,175)' -border 10  $imagename_normalized`;
    }
}

# find widths
# widths
$widthlist = `identify -format "%w\n" @imagenames_normalized`;
# $widthlist = `identify -format "%w\n" $base_image_name\_x$height\_[0-9][0-9][0-9].jpg`;
chomp($widthlist);

@widths = split(/\n/,$widthlist);

$totalwidth = sum(@widths);

# number of images
$numimages = $#widths + 1;

# ideal width of each row
$rowwidth = $totalwidth/$numrows;

print "$numrows $totalwidth $numimages $rowwidth\n";


# allocate images so as to 
# minimize variation of line length

$rowindices[0] = 0;
$j = 1; # row index
$currentwidth = 0;
foreach $i (0..$#widths) {
    print "$rowwidth $currentwidth $widths[$i]\n";
    if ($rowwidth - $currentwidth - (1-$fraction)*$widths[$i] < 0) {
	# image starts next row
	$rowindices[$j] = $i;
	$j = $j + 1;
	$currentwidth = 0;
    }
    $currentwidth = $currentwidth + $widths[$i];
}

print "\n";

for $i (0..$#rowindices-1) {
    for $j ($rowindices[$i]..$rowindices[$i+1]-1){
	printf("%03d ",$j);
    }
    print "\n";
}

for $j ($rowindices[$#rowindices]..$numimages-1){
    printf("%03d ",$j);
}

print "\n\n";

# sleep();

# make rows

$rowimagenames = "";
for $i (0..$#rowindices-1) {
    $tag = sprintf("%03d",$i);
    @someimagenames = join (' ',@imagenames_normalized[$rowindices[$i]..$rowindices[$i+1]-1]);
    $rowconvertcommand = "convert @someimagenames -bordercolor black -border 60 +append $outputfilename$tag.jpg";

    print "$rowconvertcommand\n\n";
    system($rowconvertcommand);

    $rowimagenames = $rowimagenames." $outputfilename$tag.jpg";
}

$tag = sprintf("%03d",$#rowindices);
@someimagenames = join (' ',@imagenames_normalized[$rowindices[$#rowindices]..$numimages-1]);
$rowconvertcommand = "convert @someimagenames -bordercolor black -border 60 +append $outputfilename$tag.jpg";

print "$rowconvertcommand\n\n";
system($rowconvertcommand);

$rowimagenames = $rowimagenames." $outputfilename$tag.jpg";

## stack rows
## 

$stackcommand = "convert $rowimagenames -background black -gravity center -append $outputfilename-combined.jpg";

print "$stackcommand\n\n";
system($stackcommand);

## 
## # add border

print "Converting to 3:2 shape ...\n";

$output_w = `identify -format "%w" $outputfilename-combined.jpg`;
$output_h = `identify -format "%h" $outputfilename-combined.jpg`;
$aspectratio = ($output_w + 2*$minborder)/($output_h + 2*$minborder);

print "Width, height, ratio = $output_w x $output_h, $aspectratio\n";

## add at least 200 in each dimension
$minborder = 200.0;
$aspectratio = ($output_w + 2*$minborder)/($output_h + 2*$minborder);
if ($aspectratio > $required_aspectratio) {
    ## too wide; add more to height
    $h_border = $minborder;
    $v_border = 0.5*($output_w + 2*$minborder)/$required_aspectratio - 0.5*$output_h;
} else {
    ## too tall, add more to width
    $h_border = 0.5*($output_h + 2*$minborder)*$required_aspectratio - 0.5*$output_w;
    $v_border = $minborder;
}

$borderdims = $h_border."x".$v_border;

## using help from here:
## http://www.imagemagick.org/Usage/files/#massive
$bordercommand = "convert -border $borderdims -bordercolor black $outputfilename-combined.jpg $outputfilename-combined-border.jpg";

print "$bordercommand\n\n";

system($bordercommand);

$output_w = `identify -format "%w" $outputfilename-combined-border.jpg`;
$output_h = `identify -format "%h" $outputfilename-combined-border.jpg`;
$aspectratio = $output_w/$output_h;

print "Width, height, ratio = $output_w x $output_h, $aspectratio\n";

print "\n";

print "Collage created with file name:
$outputfilename-combined-border.jpg
";

$cleancommand = "\\rm $rowimagenames $outputfilename-combined.jpg";
system($cleancommand);
