#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

use File::Basename;

($sec,$min,$hour,$day,$month,$year) = (localtime)[0,1,2,3,4,5];
$year = $year + 1900;
$month = $month+1;

$timesstampeddir = sprintf("%04d-%02d-%02d-%02d-%02d-%02d",$year,$month,$day,$hour,$min,$sec);

# note: could fine unique directories
# but intended use is for small local archiving

foreach $file (@ARGV) {
    $directory = dirname($file)."/archive/".$timesstampeddir;
    system("mkdir -p $directory\n");
    system("cp -v -R $file $directory/\n");
}


