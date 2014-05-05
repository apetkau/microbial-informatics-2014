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
my $main_dir = "$script_dir/..";
my $scale = "65%";

my %file_properties = (
	'core-snp/README.md' => {'file'=>'Day7PetkauCoreSNPLab2014.pdf', 'title'=>'Whole Genome SNP Phylogenomics', 'date'=>'Thursday, May 15, 2014', 'day'=>'Day 7'},
	'core-snp/Answers.md' => {'file'=>'Day7PetkauCoreSNPAnswers2014.pdf', 'title'=>'Whole Genome SNP Phylogenomics: Answers', 'date'=>'Thursday, May 15, 2014', 'day'=>'Day 7'},
	'ffp-phylogeny/README.md' => {'file'=>'Day7PetkauFFPLab2014.pdf', 'title'=>'Feature Frequency Profile Phylogenies', 'date'=>'Thursday, May 15, 2014', 'day'=>'Day 7'},
	'ffp-phylogeny/Answers.md' => {'file'=>'Day7PetkauFFPAnswers2014.pdf', 'title'=>'Feature Frequency Profile Phylogenies: Answers', 'date'=>'Thursday, May 15, 2014', 'day'=>'Day 7'},
	'gview-server/README.md' => {'file'=>'Day6PetkauGViewServerLab2014.pdf', 'title'=>'Working with GView Server', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'gview-server/Answers.md' => {'file'=>'Day6PetkauGViewServerAnswers2014.pdf', 'title'=>'Working with GView Server: Answers', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'orthomcl/README.md' => {'file'=>'Day6PetkauOrthoMCLLab2014.pdf', 'title'=>'Ortholog detection with OrthoMCL', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'orthomcl/Answers.md' => {'file'=>'Day6PetkauOrthoMCLAnswers2014.pdf', 'title'=>'Ortholog detection with OrthoMCL: Answers', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'mst/README.md' => {'file'=>'Day6PetkauMSTLab2014.pdf', 'title'=>'Minimum Spanning Trees with PHYLOViZ', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'mst/Answers.md' => {'file'=>'Day6PetkauMSTAnswers2014.pdf', 'title'=>'Minimum Spanning Trees with PHYLOViZ: Answers', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'},
	'README.md' => {'file'=>'Day6PetkauIntroductionData2014.pdf', 'title'=>'Introduction to Lab Data', 'date'=>'Wednesday, May 14, 2014', 'day'=>'Day 6'}
);

my @gview_server_files = ('lab2-atlas-1.jpg','lab2-atlas-2.jpg','lab3-atlas-c1.jpg','lab3-atlas-c2.jpg');

my $author = "Aaron Petkau";
my $geometry = "margin=1in";
my $highlight = "monochrome";
my $template = "$script_dir/default.latex";
my $command;

# prepare directory with labs
system("rm -r $lab_dir") if (-e $lab_dir);
system("cp -r $lab_dir_orig $lab_dir");

# prepare images by converting the dpi 
$command = "find $lab_dir -iname '*.jpg' | xargs -I {} mogrify -density 128 -units PixelsPerInch {}";
print "$command\n";
system($command);

# prepare images to not be figures by adding '\' right after
$command = "find $lab_dir -iname '*.md' | xargs -I {} sed -i -e 's/\\.jpg)\$/\\.jpg)\\\\/' -e 's/\\.jpg\\]\$/\\.jpg\\]\\\\/' {}";
print "$command\n";
system($command);

# Change gview server images so they're smaller
for my $file (@gview_server_files)
{
	my $image = "$lab_dir/gview-server/images/$file";
	$command = "mogrify -density 156 -units PixelsPerInch $image";
	print "$command\n";
	system("$command");
}

for my $file (keys %file_properties)
{
	my $name = $file_properties{$file}{'file'};
	my $title = $file_properties{$file}{'title'};
	my $date = $file_properties{$file}{'date'};
	my $day = $file_properties{$file}{'day'};
	my $lab_title = "$day: $title";
	my $file_path;
	my $file_path_dir;
	if ($file eq 'README.md')
	{
		$file_path = "$main_dir/$file";
		$file_path_dir = $main_dir;
	}
	else
	{
		$file_path = "$lab_dir/$file";
		$file_path_dir = dirname("$lab_dir/$file");
	}

	chdir $file_path_dir;

	my $command = "pandoc --template=$template --toc --highlight-style $highlight -Vlabdate=\"$date\" -Vlab=\"$lab_title\" -Vtitle=\"$title\" -Vauthor=\"$author\" -Vgeometry:$geometry -f markdown+pipe_tables -o $doc_dir/$name $file_path";
	print "$command\n";
	system($command) == 0 || die "Could not run \"$command\"";

	chdir $cwd;
}
