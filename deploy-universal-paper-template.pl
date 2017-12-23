#!/usr/bin/perl


$usage = "% deploy-universal-paper-template.pl YYYY-MMhandle1 YYYY-MMhandle2 ...

Creates a framework for a paper using universal template
stored in ~/github/universal-paper-template

Directories will be YYYYY-MMhandle1, YYYYY-MMhandle2, ...
LaTeX files will be named with handle1, handle2, ...
";

$templatedir = $ENV{"HOME"}."/github/universal-paper-template";

foreach $papername (@ARGV) {

    unless ($papername =~ m/\d\d\d\d-\d\d([a-z-]+)/) {
	print $usage;
	exit;
    } else {
	$directory = $papername;
	$handle = $1;

	`mkdir $directory`;
	`cp -R $templatedir/* $directory/`;

	`cd $directory; rename paper-template $handle paper-template*; make-name-match-settingsfile.pl; zip -r overleaf-$handle-template.zip *;`;

	print "Directory $directory/ created and constituted with goodness ...\n";
	print "uploadable overleaf template stored in $directory/overleaf-$handle-template.zip ...\n";

    }

}
