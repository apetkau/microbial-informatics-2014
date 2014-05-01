#!/usr/bin/env perl

use warnings;
use strict;

use FindBin;
use File::Basename;
use Cwd;

my $script_dir = $FindBin::Bin;

my $cwd = getcwd;
my $doc_dir = "$script_dir/../doc";
my $lab_dir_orig = "$script_dir/../labs";
my $lab_dir = "$script_dir/labs";

my %file_properties = (
	"core-snp/README.md" => 'PetkauCoreSNPLab.pdf',
	"core-snp/Answers.md" => 'PetkauCoreSNPAnswers.pdf'
);

my $author = "Aaron Petkau";
my $geometry = "margin=1in";
my $highlight = "monochrome";
my $template = "$script_dir/default.latex";
my $dpi_to_convert = 144;

# prepare directory with labs
system("rm -r $lab_dir") if (-e $lab_dir);
system("cp -r $lab_dir_orig $lab_dir");

# prepare images by converting the dpi 
system("find $lab_dir -iname '*.jpg' | xargs -I {} convert {} -units 'PixelsPerInch' -density $dpi_to_convert -resample '$dpi_to_convert' {}");

for my $file (keys %file_properties)
{
	my $name = $file_properties{$file};
	my $file_path = "$lab_dir/$file";
	my $file_path_dir = dirname("$lab_dir/$file");

	chdir $file_path_dir;

	my $command = "pandoc --template=$template -H $script_dir/header.latex --toc --highlight-style $highlight -Vauthor=\"$author\" -Vgeometry:$geometry -f markdown+pipe_tables -o $doc_dir/$name $file_path";
	print "$command\n";
	system($command) == 0 || die "Could not run \"$command\"";

	chdir $cwd;
}
