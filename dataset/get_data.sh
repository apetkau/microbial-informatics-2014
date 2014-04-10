# How to download and prepare data

# Download from NCBI's SRA using the SRA Toolkit: http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software
mkdir files
perl download_sra_runs.pl < files.txt

# Reduce each dataset to 6 million random reads
# Uses seqtk: https://github.com/lh3/seqtk ab4fe619c291ea
mkdir files-reduced
for i in files/*.fastq; do b=`basename $i`; ./seqtk/seqtk sample -s 101 $i 6000000 > files-reduced/$b; done

##########################
# Assemblies/Annotations #
##########################

# Assemble using SPAdes 3.0: http://bioinf.spbau.ru/spades
mkdir assemblies
perl assemble-genomes.pl < files.txt

##########################
# Core SNP Pipeline data #
##########################

# Reduce data to approx 10x coverage for core snp pipeline
mkdir files-cov-10
for i in files-reduced/*.fastq; do b=`basename $i`; ./extract_reads_for_coverage.pl /usr/bin/shuf 4077740 10 $i files-cov-10/$b; done

# Remove second pair of paired-end data and re-name first set of reads (treat paired-end as single-end data)
rm files-cov-10/*_2.fastq
prename 's/_1\.fastq/\.fastq/' files-cov-10/*_1.fastq

# tar up reduced fastq files
tar -cvvzf files-cov-10.tar.gz files-cov-10/*
