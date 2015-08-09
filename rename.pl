#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "rename text1 text2 file [files...]

swap text1 for text2 in file names
whenever text1 is found.

swaps only the first instance.

rudimentary first version: use only for static text.
";

$pattern1 = $ARGV[0];
$pattern2 = $ARGV[1];

foreach $filename (@ARGV[2..$#ARGV]) {
    if ($filename =~ m/$pattern1/) {
	($newfilename = $filename) =~ s/$pattern1/$pattern2/g;
	print "renaming $filename as $newfilename...\n";
	`mv -i "$filename" "$newfilename"`;
    }
}
