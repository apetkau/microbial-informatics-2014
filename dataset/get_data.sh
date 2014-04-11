# How to download and prepare data

# Download from NCBI's SRA using the SRA Toolkit: http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software
mkdir files
perl download_sra_runs.pl < files.txt

# Reduce each dataset to 6 million random reads
# Uses seqtk: https://github.com/lh3/seqtk ab4fe619c291ea
mkdir files-reduced
for i in files/*.fastq; do b=`basename $i`; ./seqtk/seqtk sample -s 101 $i 6000000 > files-reduced/$b; done

##########################
# Reference Genome       #
##########################
# reference genome downloaded from http://www.ncbi.nlm.nih.gov/nuccore/NC_016445.1 and http://www.ncbi.nlm.nih.gov/nuccore/NC_016446.1
mkdir reference
# export GenBank and FASTA formats to reference/*.ffn and reference/*.faa

##########################
# Assemblies/Annotations #
##########################

# Assemble using SPAdes 3.0: http://bioinf.spbau.ru/spades
mkdir assemblies
perl assemble-genomes.pl < files.txt

# Pull out contigs
mkdir logs
mv assemblies/*.{out,err} logs/
mkdir contigs
for i in assemblies/*; do b=`basename $i`; cp $i/contigs.fasta contigs/$b.fasta; done

# insert reference genome into contigs/ folder
cp reference/2010EL-1786.fasta contigs/

# make contigs tarball
tar -cvzf contigs-cholera.tar.gz contigs/*

# annotate contigs with prokka 1.8: http://www.vicbioinformatics.com/software.prokka.shtml
mkdir annotations
mkdir tmp
cd tmp # deal with many temp files building up
for i in ../contigs/*.fasta; do b=`basename $i .fasta`; qsub -o ../logs/$b-prokka.out -e ../logs/$b-prokka.err -cwd -V -b yes prokka --outdir ../annotations/$b --prefix $b --locustag $b $i; sleep 2; done

# export features from reference genome (concatenate both chromosomes) and to annotations/
cat reference/*c*.ffn > annotations/2010EL-1786.ffn
cat reference/*c*.faa > annotations/2010EL-1786.faa

# copy annotations to annotations/ and create tar file
cp annotations/*/*.faa annotations/
cp annotations/*/*.ffn annotations/
tar -cvvzf annotations-cholera.tar.gz annotations/*.{ffn,faa}

##########################
# Core SNP Pipeline data #
##########################

# Reduce data to approx 10x coverage for core snp pipeline
mkdir files-cov-10
for i in files-reduced/*.fastq; do b=`basename $i`; ./extract_reads_for_coverage.pl /usr/bin/shuf 4077740 10 $i files-cov-10/$b; done

# Remove second pair of paired-end data and re-name first set of reads (treat paired-end as single-end data)
rm files-cov-10/*_2.fastq
prename 's/_1\.fastq/\.fastq/' files-cov-10/*_1.fastq

# tar up reduced fastq files and reference file
tar -cvvzf core-snp-pipeline-data.tar.gz files-cov-10/* reference/*
