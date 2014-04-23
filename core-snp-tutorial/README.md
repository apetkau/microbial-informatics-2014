Core SNP Phylogenomics
======================

Introduction
============

Tutorial
========

This document walks through how to run the [core phylogenomics pipeline](https://github.com/apetkau/core-phylogenomics) to generate a set of SNPs and a phylogenetic tree based on whole genome sequencing data.  This tutorial assumes you have have the pipeline installed and that you have some familiarity with working on the command line in Linux.

Step 1: Constructing a Working Directory
----------------------------------------

To construct a working directory and obtain a copy of these instructions the following commands can be used.

	$ git clone http://gitlab.corefacility.ca/aaron.petkau/microbialinformatics2014.git
	$ cd microbialinformatics2014/core-snp-tutorial/
	$ ls
	mapping.conf  output-10-tree.jpg  README.md

Step 2: Obtaining input data
----------------------------

The input data to the core phylogenomics pipeline consists of a reference genome (in FASTA format) and a set of sequencing reads (in FASTQ format).  The reference genome and sequencing reads are only a small section from the larger dataset which makes this overall pipeline a bit faster to run.  To see a walkthrough using the entire dataset please go to [READMELargePhylogeny.md](READMELargePhylogen.md).

The data can be obtained with the following commands.

	$ cp /Course/MI_workshop_2014/day7/cholera-files-subsample.tar.gz .
	$ tar -xvf cholera-files-subsample.tar.gz

This will download and extract the data into two directories.  The first directory **cholera-files-subsample/reference/** contains the reference genome.  In this case, it is the region from 2mbp to 2.4mbp on chromosome I of *V. cholerae* 2010EL-1786, which can also be obtained from http://www.ncbi.nlm.nih.gov/nuccore/NC_016445.1.  This file looks like:

	$ ls cholera-files-subsample/reference/
	2010EL-1786-c1_2000_2400kb.fasta

	$ head cholera-files-subsample/reference/2010EL-1786-c1_2000_2400kb.fasta
	>gi|360034408|ref|NC_016445.1|_2000000_2400000
	CCCGCTCGCCACGCTTTGGCCATAGTGCTGCCTTCTACGATGTGTAAACCGTGCAACTTAATGCCATCGGTGCCTACCTT
	CAGTACTTGCTGTAACGTGGTGAGGTTTTCAGTGCGCTCTTCACCGGGTAACCCAACAATCAAGTGAGTACACACTTTGA
	...

The second directory, __cholera-files-subsample/fastq/__, contains the sequencing reads for all the other samples we will use to build a phylogenetic tree in FASTQ format.  These were downloaded from NCBI's [Sequence Read Archive](http://www.ncbi.nlm.nih.gov/sra/) reduced in coverage to 10x, and then filtered so we kept only those reads that map to the subregion on the reference genome.  The directory looks like:

	$ ls cholera-files-subsample/fastq/
	2010EL-1749.fastq  2010EL-1798.fastq  2012V-1001.fastq  C6706.fastq  VC-14.fastq  VC-18.fastq  VC-1.fastq   VC-26.fastq
	2010EL-1796.fastq  2011EL-2317.fastq  3554-08.fastq     VC-10.fastq  VC-15.fastq  VC-19.fastq  VC-25.fastq  VC-6.fastq

	$ head cholera-files-subsample/fastq/2010EL-1749.fastq
	@HWUSI-EAS109E_0007_FC62MZGAAXX:6:59:5084:8496
	GAAACTGAGCTTATCCACTCCAGCAACTGCCAGCAC
	+
	ccccccacc[b^X`BBBBBBBBBBBBBBBBBBBBBB
	@HWUSI-EAS109E_0007_FC62MZGAAXX:6:45:6427:12268
	GATAACTACGATTCGTTTACTTACAACCTGTACCAA
	...

For information on exactly how these files were generated please see [get_data.sh](../dataset/get_data.sh).

Step 3: Running the Core SNP pipeline
-------------------------------------

The command __snp_phylogenomics_control__ can used to generate a set of SNPs given the input data we just downloaded and build a whole genome phylogeny from a multiple alignment of these SNPs.  There are a number of different methods to building a whole genome phylogeny implemented in this pipeline but the method we will focus on for this tutorial is the reference mapping method.  

The reference mapping method can be run using the __--mode mapping__ parameter.  This requires as input the reference FASTA file, the FASTQ sequencing reads and a configuration file defining other parameters for the reference mapping mode.  For this tutorial, the configuration file is named __mapping.conf__ and looks like:

	%YAML 1.1
	---
	min_coverage: 2
	freebayes_params: '--pvar 0 --ploidy 1 --left-align-indels --min-mapping-quality 30 --min-base-quality 30 --min-alternate-fraction 0.75'
	smalt_index: '-k 13 -s 6'
	smalt_map: '-n 1 -f samsoft -r -1 -y 0.5'

The main parameter you will want to keep an eye on here is the __min_coverage__ parameter which defines the minimum coverage in a particular position to be included within the results.  For this tutorial we will leave the minimum coverage at 2 since the mean coverage for the downloaded data was 10.  For other data sets with different mean coverage values this number could be adjusted.

In order to run the pipeline, the following command can be used:

	$ snp_phylogenomics_control --mode mapping --input-dir cholera-files-subsample/fastq/ --reference cholera-files-subsample/reference/2010EL-1786-c1_2000_2400kb.fasta --output output-10-subsample --config mapping.conf
	Running core SNP phylogenomic pipeline on Wed Apr 23 11:53:50 CDT 2014
	Core Pipeline git Commit: c09e778dc9c51d9301b438b334f4c523de87bb4d
	vcf2pseudoalign git Commit: a2c73962ac48310c289b700976715c2d319d3227
	
	Parameters:
	...

When finished, you should expect to see the following output:

	================
	= Output Files =
	================
	tree: /home/aaron/microbialinformatics2014/core-snp-tutorial/output-10-subsample/phylogeny/pseudoalign.phy_phyml_tree.txt
	matrix: /home/aaron/microbialinformatics2014/core-snp-tutorial/output-10-subsample/pseudoalign/matrix.csv
	pseudoalignment: /home/aaron/microbialinformatics2014/core-snp-tutorial/output-10-subsample/pseudoalign/pseudoalign.phy
	stage: mapping-final took 0.00 minutes to complete
	pipeline took 8.08 minutes to complete

Step 4: Example Results (optional)
----------------------------------

If the pipeline fails to run, then the below steps can be performed with some example results that have already been computed.  These can be obtained with the commands.

	$ cp /Course/MI_workshop_2014/day7/output-10-subsample-example.tar.gz ./
	$ tar -xvvzf output-10-subsample-example.tar.gz

This will extract the example data to a directory named **output-10-subsample-example/**.

Step 5: Examine Results
-----------------------

The main file you will want to check out is __output-10-subsample/phylogeny/pseudoalign.phy_phyml_tree.txt__, which is the computed phylogenetic tree.  This can be opened up using [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) and should look similar to below.

![output-10-subsample.jpg](images/output-10-subsample.jpg)

Also, the file __output-10-subsample/pseudoalign/matrix.csv__ which contains a matrix of core SNP distances among all the input isolates.

	$ column -t output-10-subsample/pseudoalign/matrix.csv
	strain                      2010EL-1749  C6706  2010EL-1786-c1_2000_2400kb  2012V-1001  VC-14  VC-15  VC-18  VC-25  VC-26  2010EL-1796  2010EL-1798  2011EL-2317  VC-1  VC-10  3554-08  VC-19  VC-6
	2010EL-1749                 0            21     4                           2           3      3      3      3      3      2            2            2            6     6      3        3      3
	C6706                       21           0      21                          21          20     20     20     20     20     19           19           19           19    19     18       18     18
	2010EL-1786-c1_2000_2400kb  4            21     0                           4           3      3      3      3      3      2            2            2            6     6      3        3      3
	2012V-1001                  2            21     4                           0           3      3      3      3      3      2            2            2            6     6      3        3      3
	VC-14                       3            20     3                           3           0      2      2      0      0      1            1            1            5     5      2        2      2
	VC-15                       3            20     3                           3           2      0      0      2      2      1            1            1            5     5      2        2      2
	VC-18                       3            20     3                           3           2      0      0      2      2      1            1            1            5     5      2        2      2
	VC-25                       3            20     3                           3           0      2      2      0      0      1            1            1            5     5      2        2      2
	VC-26                       3            20     3                           3           0      2      2      0      0      1            1            1            5     5      2        2      2
	2010EL-1796                 2            19     2                           2           1      1      1      1      1      0            0            0            4     4      1        1      1
	2010EL-1798                 2            19     2                           2           1      1      1      1      1      0            0            0            4     4      1        1      1
	2011EL-2317                 2            19     2                           2           1      1      1      1      1      0            0            0            4     4      1        1      1
	VC-1                        6            19     6                           6           5      5      5      5      5      4            4            4            0     0      3        3      3
	VC-10                       6            19     6                           6           5      5      5      5      5      4            4            4            0     0      3        3      3
	3554-08                     3            18     3                           3           2      2      2      2      2      1            1            1            3     3      0        0      0
	VC-19                       3            18     3                           3           2      2      2      2      2      1            1            1            3     3      0        0      0
	VC-6                        3            18     3                           3           2      2      2      2      2      1            1            1            3     3      0        0      0

Also, the file __output-10-subsample/pseudoalign/pseudoalign-positions.tsv__ which includes every variant that was used by the pipeline for genetating the phylogenetic tree as well as those that were filtered out.

	$ head output-10-subsample/pseudoalign/pseudoalign-positions.tsv | column -t
	#Chromosome                                    Position  Status             Reference  2010EL-1749  2010EL-1796  2010EL-1798  2011EL-2317  2012V-1001  3554-08  C6706  VC-1  VC-10  VC-14  VC-15  VC-18  VC-19  VC-25  VC-26  VC-6
	gi|360034408|ref|NC_016445.1|_2000000_2400000  13149     filtered-mpileup   A          N            A            A            A            A           N        G      A     A      A      A      A      A      A      A      A
	gi|360034408|ref|NC_016445.1|_2000000_2400000  17132     valid              A          A            A            A            A            A           A        C      A     A      A      A      A      A      A      A      A
	...
	
This file contains a list of all variants detected by the pipeline, one per line.  Each variant is given a status, with *valid* indicating that the variants at that position were used for further analysis.  *Note: since reference mapping was performed with respect to the region starting at 2mbp on chromosome I, all positions are indicated relative to this region.*

A quick method to count the total number of 'valid' variants used to generate the phylogenetic tree and SNP matrix is with the following command:

	$ grep --count -P "\tvalid\t" output-10-subsample/pseudoalign/pseudoalign-positions.tsv
	28

Questions
=========

1. The **minimum coverage** setting within the **mapping.conf** file can have a large effect on the total number of valid positions used to generate the tree.  Please try re-running the pipeline with a minimum coverage of *5*.  What effect does this have on the total number of *valid* variants used to generate the phylogenetic tree?  What effect does this have on the phylogenetic tree generated?

[Answers](Answers.md)
