#!/usr/bin/env perl

use FindBin;

my $script_dir = $FindBin::Bin;

use warnings;
use strict;

# given a list of files in format (name, SRA URL, layout), downloads and renames the runs
print "Usage: $0 < files.txt\n";

while(my $line = <STDIN>)
{
	chomp $line;
	my @parts = split(/\t/,$line);

	my $files_dir = "$script_dir/files";
	my $name = $parts[0];
	my $sra_run = $parts[1];
	my $layout = $parts[2];
	chdir $files_dir;

	my $command = "fastq-dump --qual-filter-1 -F --defline-qual + -A $name ";
	$command .= ($layout eq 'PAIRED') ? '--split-files' : '';
	$command .= " $sra_run";

	print $command."\n";
	if (system($command) != 0)
	{
		print "Failed for $name\n";
	}
	else
	{
		print "Success for $name\n";
	}

	sleep 3;
}
