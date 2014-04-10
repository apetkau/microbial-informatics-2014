# How to download and prepare data

# Download from NCBI's SRA using the SRA Toolkit: http://www.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software
mkdir files
perl download_sra_runs.pl < files.txt

# Reduce each dataset to 6 million random reads
# Uses seqtk: https://github.com/lh3/seqtk ab4fe619c291ea
mkdir files-reduced
for i in files/*.fastq; do b=`basename $i`; ./seqtk/seqtk sample -s 101 $i 6000000 > files-reduced/$b; done

# Assemble using SPAdes 3.0: http://bioinf.spbau.ru/spades
mkdir assemblies
perl assemble-genomes.pl < files.txt
