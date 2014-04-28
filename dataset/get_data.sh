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

# Extract small subregion for smaller reference mapping lab
perl -MBio::SeqIO -e '$i=Bio::SeqIO->new(-file=>"<reference/2010EL-1786.fasta",-format=>"fasta");$s=$i->next_seq; print ">",$s->display_id,"_2000000_2400000\n";print $s->subseq(2000000,2400000),"\n";'| fold -w80 > reference/2010EL-1786-c1_2000_2400kb.fasta

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

############################
# GView Server Annotations #
############################
mkdir gview-server-annotations
mkdir gview-server-annotations/reference
mkdir gview-server-annotations/other-genomes

cp annotations/*/*.gbk gview-server-annotations/other-genomes/
cp reference/2010EL-1786-c*.gbk gview-server-annotations/reference/

cd gview-server-annotations
# shifted a contig in other-genomes/VC-1.gbk so the first contig has a CDS
tar -cvzf other-genomes.tar.gz other-genomes/

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

# map reads to small subregion of reference to reduce dataset size
mkdir read-reduction
cp reference/2010EL-1786-c1_2000_2400kb.fasta read-reduction/
cd read-reduction
mkdir cholera-files-subsample
mkdir cholera-files-subsample/reference
cp ../reference/2010EL-1786-c1_2000_2400kb.fasta cholera-files-subsample/reference
mkdir cholera-files-subsample/fastq

smalt index -k 13 -s 1 2010EL-1786-c1_2000_2400kb 2010EL-1786-c1_2000_2400kb.fasta
for i in ../files-cov-10/*.fastq; do b=`basename $i`; echo $i; smalt map -f samsoft -n 8 -r 1 -y 0.5 2010EL-1786-c1_2000_2400kb $i > $b.sam 2> $b.err; done

# pull out mapped reads from sam files
# used fasta_utilities https://github.com/apetkau/fasta_utilities 724d0ed31e653d55113d8594ee218b4c41779be5
for i in *.sam; do b=`basename $i .sam`; perl fasta_utilities/scripts/sam2fastq.pl --remove-unaligned $i > cholera-files-subsample/fastq/$b.fastq; done
# rename files to remove extra .fastq
prename 's/\.fastq$//' cholera-files-subsample/fastq/*.fastq

# tar up file containing reduced dataset
tar -cvzf cholera-files-subsample.tar.gz cholera-files-subsample
