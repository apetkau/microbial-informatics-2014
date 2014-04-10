#!/usr/bin/env perl

use warnings;
use strict;

use File::Copy;

my $usage = "Usage: $0 [shuf_path] [ref length] [cov to keep] [input.fastq] [out file]\n";

my $shuf_path = $ARGV[0];
my $ref_length = $ARGV[1];
my $cov = $ARGV[2];
my $input_fastq = $ARGV[3];
my $output_file = $ARGV[4];

die "shuf_path is not defined" if (not defined $shuf_path);
die "shuf_path=$shuf_path does not exist" if (not -e $shuf_path);

die "reference length is not defined\n$usage" if (not defined $ref_length);
die "coverage is not defined\n$usage" if (not defined $cov);

die "reference length=$ref_length is not an integer\n$usage" if ($ref_length !~ /^\d+$/);
die "coverage=$cov is not an integer\n$usage" if ($cov !~ /^\d+$/);

die "input_fastq is not defined\n$usage" if (not defined $input_fastq);
die "input_fastq=$input_fastq does not exist\n$usage" if (not -e $input_fastq);

die "output_file is not defined\n$usage" if (not defined $output_file);

my $total_bp = `awk '{if(n\%4==1){ print \$0} n++;}' < $input_fastq | tr -d '[:space:]' | wc -c`;

my ($total_records) = (`wc -l $input_fastq` =~ /(^\d+)/);
die "error: total_records=$total_records for $input_fastq is invalid" if ($total_records !~ /\d/);
my $total_reads = $total_records/4;

chomp $total_bp;
chomp $total_reads;

die "Error: total_bp=$total_bp is not a number" if ($total_bp !~ /^\d+/);
die "Error: total_bp=$total_bp must be positive" if ($total_bp <= 0);
die "Error: total_reads=$total_reads is not a number" if ($total_reads !~ /^\d+$/);
die "Error: total_reads=$total_reads must be positive" if ($total_reads <= 0);

my $avg_bp_reads = $total_bp/$total_reads;
my $bp_to_keep = $ref_length * $cov;
my $reads_to_keep = int($bp_to_keep/$avg_bp_reads+0.5);

print STDERR "$input_fastq: bp=$total_bp, reads=$total_reads, bp/read=$avg_bp_reads, reads_to_keep=$reads_to_keep\n";

if ($reads_to_keep >= $total_reads)
{
	print STDERR "reads_to_keep=$reads_to_keep >= total_reads=$total_reads, not extracting subample\n";
	copy($input_fastq,$output_file) or die "Could not copy $input_fastq to $output_file: $!\n";
}
else
{
	# merges fastq entries to a single line, shuffles, and pulls out a certain number
	# obtained from http://biostar.stackexchange.com/post/show/6544/selecting-random-pairs-from-fastq/#6562
	my $command = "awk '{ printf(\"\%s\",\$0); n++; if(n\%4==0) { printf(\"\\n\");} else { printf(\"\\t\\t\");} }' < $input_fastq | $shuf_path | head -n $reads_to_keep | sed 's/\\t\\t/\\n/g' > $output_file";
	#my $command = "seqtk sample $input_fastq $reads_to_keep > $output_file";
	print STDERR "Running $command\n";
	system($command) == 0 or die "Could not run $command";
	print STDERR "done\n";
}
