#!/usr/bin/perl
$usage = "pdftile m n widthfrac hspacepts vspacepts f fontsize maintitle title1 fig1.pdf [title2 fig2.pdf ...] outfile

creates an m rows by n columns tiling of postscript figures
with titles above each figure (figures are laid out
in rows moving from left to right, then down).

widthfrac = fraction of textwidth to use in pdflatex
for each figure (e.g., for n=3 panels across, 0.32 would be okay).

uses tabular with format f which can be l, c, or r.

fontsize for labels: 8, 9, 10, ...

hspacepts = adjustment to horizontal separation between figures    
vspacepts = adjustment to vertical separation between figures
    
no checks that input is okay---horrible things could happen

outfile.pdf will be created (involves cropping).

Example (put this kind of structure into a simple shell script):

pdftile 2 2 0.48 3 0 l 8 \
\"\" \
\"A. Title for panel A:\" \
panel-A.pdf \
\"B. Title for panel B:\" \
panel-B.pdf \
\"C. Title for panel C:\" \
panel-C.pdf \
\"D. Title for panel D:\" \
panel-D.pdf \
combined_figure_name

";

if ($#ARGV < 0) {
    print $usage;
    exit;
}

$m = $ARGV[0];
$n = $ARGV[1];
$widthfrac = $ARGV[2];
$hspacepts = $ARGV[3];
$vspacepts = $ARGV[4];
$f = $ARGV[5];
$fontsize = $ARGV[6];

print "-------\n";

$title = $ARGV[7];
$resize = $ARGV[8];
$titlekludge = "";
for ($i = 9; $i < $#ARGV; $i += 2) {
    $titlekludge = $titlekludge."$ARGV[$i]";
}

$texfile = "tmp_tmp_pdftile";

$outfile = $ARGV[$#ARGV];

print "making a little latex file...\n";

open (TEXFILE,">$texfile.tex") or die "can't open $texfile.tex: $!";
print TEXFILE "\\documentclass[$fontsize pt]{extarticle}
%% \\documentclass[final]{beamer}
\\usepackage{graphics,rotating,color,array,amsmath}
\\usepackage[paperwidth=20in,paperheight=40in]{geometry}
\\pagestyle{empty}

\\setlength{\\tabcolsep}{$hspacepts"."pt}
\\setlength{\\extrarowheight}{$vspacepts"."pt}

\\begin{document}

%% \\sffamily
\\noindent
";


print TEXFILE"\\begin{center}
\\textbf{$title}
\\end{center}
";

print TEXFILE "{\\$resize \\begin{tabular}{";
foreach $j (1..$n) {
    print TEXFILE "$f";
}
print TEXFILE "}\n";

$k1=9;
$k2=10;
foreach $i (1..$m) {
    if ($titlekludge ne "") {
	foreach $j (1..$n) {
	    if ($j < $n) {
		print TEXFILE "$ARGV[$k1]&";
	    }
	    else {
		print TEXFILE "$ARGV[$k1]\\\\\n";
	    }
	    $k1+=2;
	}
    }
    foreach $j (1..$n) {
	if ($j < $n) {
	    print TEXFILE "\\input{$ARGV[$k2]}&";
	}
	else {
	    print TEXFILE "\\input{$ARGV[$k2]}\\\\\n";
	}
	$k2+=2;
    }
}

print TEXFILE "\\end{tabular} }
\\end{document}
";

close TEXFILE;

print "creating tiled pdf ...\n";
`pdflatex $texfile 1>&2`;
print "\n";
print "cropping pdf...\n";
`pdfcrop $texfile.pdf 1>&2`;
print "\n";
`cp $texfile-crop.pdf $outfile.pdf`;

print "cleaning up ... \n";
`\\rm $texfile.*`;


