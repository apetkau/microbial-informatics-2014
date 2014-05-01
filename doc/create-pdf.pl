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
	'core-snp/README.md' => {'file'=>'Day7PetkauCoreSNPLab.pdf', 'title'=>'Core SNP Phylogenies', 'date'=>'May 15, 2014'},
	'core-snp/Answers.md' => {'file'=>'Day7PetkauCoreSNPAnswers.pdf', 'title'=>'Core SNP Phylogenies: Answers', 'date'=>'May 15, 2014'},
	'ffp-phylogeny/README.md' => {'file'=>'Day7PetkauFFPLab.pdf', 'title'=>'Feature Frequency Profile Phylogenies', 'date'=>'May 15, 2014'},
	'ffp-phylogeny/Answers.md' => {'file'=>'Day7PetkauFFPAnswers.pdf', 'title'=>'Feature Frequency Profile Phylogenies: Answers', 'date'=>'May 15, 2014'},
	'gview-server/README.md' => {'file'=>'Day6PetkauGViewServerLab.pdf', 'title'=>'Working with GView Server', 'date'=>'May 14, 2014'},
	'gview-server/Answers.md' => {'file'=>'Day6PetkauGViewServerAnswers.pdf', 'title'=>'Working with GView Server: Answers', 'date'=>'May 14, 2014'},
	'orthomcl/README.md' => {'file'=>'Day6PetkauOrthoMCLLab.pdf', 'title'=>'Ortholog detection with OrthoMCL', 'date'=>'May 14, 2014'},
	'orthomcl/Answers.md' => {'file'=>'Day6PetkauOrthoMCLAnswers.pdf', 'title'=>'Ortholog detection with OrthoMCL: Answers', 'date'=>'May 14, 2014'},
	'mst/README.md' => {'file'=>'Day6PetkauMSTLab.pdf', 'title'=>'Minimum Spanning Trees with PHYLOViZ', 'date'=>'May 14, 2014'},
	'mst/Answers.md' => {'file'=>'Day6PetkauMSTAnswers.pdf', 'title'=>'Minimum Spanning Trees with PHYLOViZ: Answers', 'date'=>'May 14, 2014'}
);

my $author = "Aaron Petkau";
my $geometry = "margin=1in";
my $highlight = "monochrome";
my $template = "$script_dir/default.latex";
my $command;

# prepare directory with labs
system("rm -r $lab_dir") if (-e $lab_dir);
system("cp -r $lab_dir_orig $lab_dir");

# prepare images by converting the dpi 
$command = "find $lab_dir -iname '*.jpg' | xargs -I {} convert {} -resize 65% {}";
print "$command\n";
system($command);

# prepare images to not be figures by adding '\' right after
$command = "find $lab_dir -iname '*.md' | xargs -I {} sed -i -e 's/\\.jpg)\$/\\.jpg)\\\\/' -e 's/\\.jpg\\]\$/\\.jpg\\]\\\\/' {}";
print "$command\n";
system($command);

for my $file (keys %file_properties)
{
	my $name = $file_properties{$file}{'file'};
	my $title = $file_properties{$file}{'title'};
	my $date = $file_properties{$file}{'date'};
	my $lab_title = "Lab: $title";
	my $file_path = "$lab_dir/$file";
	my $file_path_dir = dirname("$lab_dir/$file");

	chdir $file_path_dir;

	my $command = "pandoc --template=$template --toc --highlight-style $highlight -Vlabdate=\"$date\" -Vlab=\"$lab_title\" -Vtitle=\"$title\" -Vauthor=\"$author\" -Vgeometry:$geometry -f markdown+pipe_tables -o $doc_dir/$name $file_path";
	print "$command\n";
	system($command) == 0 || die "Could not run \"$command\"";

	chdir $cwd;
}
