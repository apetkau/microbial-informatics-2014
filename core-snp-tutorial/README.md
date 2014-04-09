Core SNP Phylogenomics
======================

This document walks through how to run the [core phylogenomics pipeline](https://github.com/apetkau/core-phylogenomics) and generating a set of SNPs and a phylogenetic tree based on whole genome sequencing data.  This tutorial assumes you have have the pipeline installed and that you have some familiarity with working on the command line in Linux.

Step 1: Obtaining input data
----------------------------

The input data to the core phylogenomics pipeline consists of a reference genome (in FASTA format) and a set of sequencing reads (in FASTQ format).  This data can be obtained with the following commands:

	$ wget http://url-to-data/core-snp-input.tar.gz
	$ tar -xvf core-snp-input.tar.gz

This will download and extract the data into two directories.  The first directory **reference/** contains the reference genome.  In this case, it is the concatenated chromosomes of V. cholerae 2010EL-1786, which can also be obtained from http://www.ncbi.nlm.nih.gov/nuccore/NC_016445.1 and http://www.ncbi.nlm.nih.gov/nuccore/NC_016446.1.  This file looks like:

	$ ls reference/
	2010EL-1786.fasta

	$ head reference/2010EL-1786.fasta
	>gi|360034408|ref|NC_016445.1| Vibrio cholerae O1 str. 2010EL-1786 chromosome 1, complete sequence
	TTTCATCAGGTCGTTTATGGTAATTTTTTTCATGTTTAGTCCTTACTCGACGTTGGCGAGTGCCAAATGC
	TGAGCCCATTGAGCGGTACTTGTTGCAATAACGCTTGGATTTCAGTCCCGTCTGGGAGGGTTAAATTTGG
	...

The second directory, fastq, contains the sequencing reads for all the other samples we will use to build a phylogenetic tree in FASTQ format.  These were downloaded from NCBI's [Sequence Read Archive](http://www.ncbi.nlm.nih.gov/sra/) and were reduced to 10x coverage for the purposes of this tutorial.  The directory looks like:

	$ ls fastq/

	$ head fastq/file.fastq

Step 2: Running the Core SNP pipeline
-------------------------------------

The command __snp_phylogenomics_control__ can used to generate a set of SNPs given the input data we just downloaded and build a whole genome phylogeny from a multiple alignment of these SNPs.  There are a number of different methods to building a whole genome phylogeny implemented in this pipeline but the method we will focus on for this tutorial is the reference mapping method.  

The reference mapping method can be run using the __--mode mapping__ parameter.  This requires as input the reference FASTA file, the FASTQ sequencing reads and a configuration file defining other parameters for the reference mapping mode.  For this tutorial, the configuration file is named __mapping.conf__ and looks like:

	%YAML 1.1
	---
	min_coverage: 5
	freebayes_params: '--pvar 0 --ploidy 1 --left-align-indels --min-mapping-quality 30 --min-base-quality 30 --min-alternate-fraction 0.75'
	smalt_index: '-k 13 -s 6'
	smalt_map: '-n 24 -f samsoft -r -1 -y 0.5'
	vcf2pseudo_numcpus: 4
	vcf2core_numcpus: 24
	trim_clean_params: '--numcpus 4 --min_quality 20 --bases_to_trim 10 --min_avg_quality 25 --min_length 36 -p 1'
	drmaa_params:
	    general: "-V"
	    vcf2pseudoalign: "-pe smp 4"
	    vcf2core: "-pe smp 24"
	    trimClean: "-pe smp 4"

The main parameter you will want to change here is the __min_coverage__ parameter which defines the minimum coverage in a particular position to be included within the results.  For this tutorial we will leave the minimum coverage at 5 since the mean coverage for the downloaded data was 10.  For other data sets with different mean coverage values this number could be adjusted.

In order to run the pipeline, the following command can be used:

	$ snp_phylogenomics_control --mode mapping --input-dir fastq/ --reference reference/2010EL-1786.fasta --output out1 --config mapping.conf
	
	Running core SNP phylogenomic pipeline on Tue Dec  3 12:18:02 CST 2013
	Core Pipeline git Commit: 3e93c5c1ef436ab6878789d330d343c47562a7a9
	vcf2pseudoalign git Commit: e81ab24e52dc2b8de85c9beed8c2ced8f478d795
	
	Parameters:
	...

When finished, you should expect to see the following output:

	================
	= Output Files =
	================
	tree: /home/course/aaron/core-phylogenomics-tutorial/tutorial1_out/phylogeny/pseudoalign.phy_phyml_tree.txt
	matrix: /home/course/aaron/core-phylogenomics-tutorial/tutorial1_out/pseudoalign/matrix.csv
	pseudoalignment: /home/course/aaron/core-phylogenomics-tutorial/tutorial1_out/pseudoalign/pseudoalign.phy
	stage: mapping-final took 0.00 minutes to complete
	pipeline took 6.18 minutes to complete

The main file you will want to check out include __tutorial1_out/phylogeny/pseudoalign.phy_phyml_tree.txt__, which is the computed phylogenetic tree.  This can be opened up using [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) and should look similar to below.

![tutorial1_tree.png](tutorial1_tree.png)

Also, the file __tutorial1_out/pseudoalign/matrix.csv__ which contains a matrix of core SNP distances among all the input isolates.

	$ column -t tutorial1_out/pseudoalign/matrix.csv
	strain     08-5578  08-5578-0  08-5578-2  08-5578-4  08-5578-1  08-5578-3
	08-5578    0        98         98         98         0          0
	08-5578-0  98       0          49         0          98         98
	08-5578-2  98       49         0          49         98         98
	08-5578-4  98       0          49         0          98         98
	08-5578-1  0        98         98         98         0          0
	08-5578-3  0        98         98         98         0          0
	

Also, the file __tutorial1_out/pseudoalign/pseudoalign-positions.tsv__ which includes every variant that was used by the pipeline for genetating the phylogenetic tree as well as those that were filtered out.

	$ head tutorial1_out/pseudoalign/pseudoalign-positions.tsv | column -t
	#Chromosome                    Position  Status  Reference  08-5578-0  08-5578-1  08-5578-2  08-5578-3  08-5578-4
	gi|284800255|ref|NC_013766.1|  77005     valid   T          C          T          G          T          C
	gi|284800255|ref|NC_013766.1|  156056    valid   T          C          T          G          T          C
	gi|284800255|ref|NC_013766.1|  163917    valid   T          C          T          G          T          C
	gi|284800255|ref|NC_013766.1|  177102    valid   A          G          A          T          A          G
	gi|284800255|ref|NC_013766.1|  197161    valid   G          A          G          C          G          A
	gi|284800255|ref|NC_013766.1|  198617    valid   T          C          T          G          T          C
	gi|284800255|ref|NC_013766.1|  222201    valid   A          G          A          T          A          G
	gi|284800255|ref|NC_013766.1|  253430    valid   G          C          G          C          G          C
	gi|284800255|ref|NC_013766.1|  289669    valid   G          C          G          C          G          C
	
This file contains a list of all variants detected by the pipeline, one per line.  Each variant is given a status, with 'valid' indicating that the variants at that position were used for further analysis.

A quick method to count the total number of 'valid' variants used to generate the phylogenetic tree and SNP matrix is with the following command:

	$ grep -c -P "\tvalid\t" tutorial1_out/pseudoalign/pseudoalign-positions.tsv
	98

Since this file is in the exact same format as the variants table used to define the mutations in our simulated data we can check how many of the variants introduced were identified properly by the pipeline.  This can be accomplished with the __diff__ command below:

	$ diff tutorial1_mutations.tsv tutorial1_out/pseudoalign/pseudoalign-positions.tsv
	62d61
	< gi|284800255|ref|NC_013766.1|	1817903	valid	T	G	T	G	T	G
	93d91
	< gi|284800255|ref|NC_013766.1|	2786700	valid	C	T	C	A	C	T

This indicates that the core SNP pipeline is missing two of the variants that were introduced, one at position 1817903 and another at position 2786700.

Alternatively, to get a brief count of the number of differences, you can use the __scripts/compare_positions.pl__ script.

	$ perl scripts/compare_positions.pl tutorial1_mutations.tsv tutorial1_out/pseudoalign/pseudoalign-positions.tsv | column -t
	tutorial1_mutations.tsv  tutorial1_out/pseudoalign/pseudoalign-positions.tsv  Intersection  Unique-tutorial1_mutations.tsv  Unique-tutorial1_out/pseudoalign/pseudoalign-positions.tsv
	100                      98                                                   98            2                               0

This prints the number of positions found within each file, as well as the intersection and unique positions.  This indicates that pipeline is missing 2 of the original set of positions from _tutorial1_mutations.tsv_.  Note: we pipe the output through __column -t__ to line up columns correctly.

Questions
=========

1. The reference mapping alignment BAM files for each genome are located within __tutorial1_out/bam__.  Load one of these files up using software such as [Tablet](http://bioinf.scri.ac.uk/tablet/) and examine the two missing positions 1817903 and 2786700.  What do you notice about these positions?

2. For this tutorial the mean coverage simulated was 30x, and our minimum SNP detection coverage was 5x.  Try changing the minimum coverage to 15x and 25x within the file __mapping.conf__ and re-running the pipeline.  Compare the differences in the number of SNPs detected.  How does the number of SNPs detected change as the minimum coverage increases?

3. All the fastq files we generated were simulated with 100 bp reads.  Adjust the read length using the __--len__ parameter in the __scripts/generate_genomes.pl__ script to 50x and 200x.  What difference does this make to the number of SNPs detected?

[Answers](Tutorial1Answers.md)
