#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "usage: flowify [YYYY-MM-DD] file1 [file2 file3 ...]

Simple command line tool to store files in ~/flow/YYYY/ 
with a date prefixed

Time is the big sorting index.  For many files, storing
them in time order fashion is entirely sufficient
for future reference.

- if no date is given, today's date is used.

- if any file starts with a proper date prefix, it's moved to
  the correct directory.

- replaces spaces with underscores.

- use birthdatify to first prefix files with their creation date.
";

$flowdir = $ENV{"HOME"}."/flow";

## set up prefix date stamp
if ($ARGV[0] =~ m/^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
    $year = $1;
    $month = $2;
    $day = $3;
    shift @ARGV;
} 
else {
    ($day,$month,$year) = (localtime)[3,4,5];
    $year = $year + 1900;
    $month = $month+1;
    if ($month < 10) {
	$month = "0$month";
    }
    if ($day < 10) {
	$day = "0$day";
    }
}

`mkdir -p $flowdir/$year`;

foreach $file (@ARGV) {
    if ($file =~ m/^(.*)\/(.*)?$/) {
	$dir = $1;
	$filenname = $2;
    }
    else {
	$dir = ".";
	$filename = $file;
    }

    # replace spaces
    $filename =~ s/ +/_/g;

    if ($filename =~ m/^(\d\d\d\d)-(\d\d)-(\d\d)/) {
	$newdir = $flowdir."/$1";
	$newfile = "$newdir/$filename";
    }
    else { # use specified or current date
	$newdir = $flowdir."/$year";
	$newfile = $flowdir."/$year/$year-$month-$day$filename";
    }
    
    # handle some possible badness
    $filename =~ s/'/\\'/g;

    # make the directory if needed
    `mkdir -p $newdir`;

    # move the file
    `mv -i "$file" "$newfile"`;

    if ($?==0) {
	print "moved $file to $newfile\n";
    } else {
	print "error: $file not moved\n";
    }
}



