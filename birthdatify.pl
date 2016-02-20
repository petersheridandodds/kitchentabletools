#!/usr/bin/perl
# peter sheridan dodds
# https://github.com/petersheridandodds
# MIT License

$usage = "usage: birthdatify file1 [file2 file3 ...]

extracts creation time stamp for files and prepends file names with YY-MM-DD

for preference, changes spaces into underscores

see also flowify

time is the big sorting index
";

foreach $file (@ARGV) {
    $date = `stat -t "%F" -f "%SB" "$file"`;
    chomp($date);

    if ($file =~ m/^(.*)\/(.*)?$/) {
	$dir = $1;
	$filename = $2;
    }
    else {
	$dir = ".";
	$filename = $file;
    }

    $filename =~ s/ +/_/g;
    print $filename;
    
    $newfile = $dir."/".$date.$filename;

    `mv -i "$file" "$newfile"`;

    if ($?==0) {
	print "moved $file to $newfile\n";
    } else {
	print "error: $file not moved\n";
    }
    
}
