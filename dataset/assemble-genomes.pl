#!/usr/bin/env perl

use FindBin;

my $script_dir = $FindBin::Bin;

use warnings;
use strict;

# given a list of files in format (name, SRA URL, layout) assembles the genomes
# assumes genomes are in directory files-reduced
print "Usage: $0 < files.txt\n";

my $fastq_dir = "files-reduced";
my $assembly_dir = "assemblies";

while(my $line = <STDIN>)
{
	chomp $line;
	my @parts = split(/\t/,$line);

	my $name = $parts[0];
	my $layout = $parts[2];
	my $fastq = "$fastq_dir/$name.fastq";
	my $fastq_1 = "$fastq_dir/${name}_1.fastq";
	my $fastq_2 = "$fastq_dir/${name}_2.fastq";
	my $out_dir = "$assembly_dir/$name";
	my $log_out = "$assembly_dir/$name.out";
	my $log_err = "$assembly_dir/$name.err";

	my $command = "qsub -V -cwd -b y -o $log_out -e $log_err spades.py";
	$command .= ($layout eq 'PAIRED') ? " -1 $fastq_1 -2 $fastq_2" : " -s $fastq";
	$command .= " -o $out_dir";

	print $command."\n";
	if (system($command) != 0)
	{
		print "Failed for $name\n";
	}
	else
	{
		print "Success for $name\n";
	}
}
