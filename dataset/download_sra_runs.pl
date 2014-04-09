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

	my $sra_dir = "$script_dir/sra";
	my $files_dir = "$script_dir/files";
	my $sra_url = $parts[2];
	my $sra_file = "$sra_dir/".$parts[1].".sra";
	my $real_name = "$files_dir/".$parts[0].".sra";
	my $wget_sra = "wget $sra_url -O $sra_file 2>&1";

	if (-e $sra_file)
	{
		print "Skipping $sra_file ...\n";
	}
	else
	{
		if(system($wget_sra) != 0)
		{
			print STDERR "Failed $line\n";
		}
		else
		{
			print STDERR "Success $line\n";
			symlink($sra_file,$real_name);
		}

		sleep 3;
	}
}
