Core SNP Phylogenomics
======================

Introduction
------------

Whole genome phylogenies are useful as a method for depicting the evolutionary relationships among a set of isolates or strains.  Unlike phylogenies based on a single gene or a small set of genes, whole genome phylogenies attempt to use data from the whole genome for constructing a phylogeny.  Some potential methods to generate whole genome phylogenies include:

* **Distance based**:  Generate a whole genome phylogeny from a distance matrix calculated based on whole genome data.  This will be explored a bit more in the [Feature Frequency Profiling Phylogeny](../ffp-phylogeny) lab later today.
* **Core-gene based**:  Identify a set of orthologous genes within the core genome of a set of isolates (see the [OrthoMCL](../orthomcl) lab) and use these orthologous genes to generate a phylogeny.
* **Reference mapping and variant calling**:  Perform reference mapping and variant calling from a set of sequencing reads to a reference genome and construct an alignment of variants.  Use this alignment to generate a whole genome phylogeny.

This lab will explore the **reference mapping** approach using a [core phylogenomics pipeline](https://github.com/apetkau/core-phylogenomics) developed at the NML.  An introductory presentation on the pipeline can be found at [Core SNP Pipeline](https://www.corefacility.ca/wiki/pub/BioinformaticsWorkshop/WorkshopMay2014/Day7PetkauCoreSNPIntroduction2014.pdf), but the stages, in brief, are as follows.

![pipeline overview](pipeline-overview.jpg)

1. Pre-process Data (FASTQ sequencing reads and FASTA reference file).
2. Reference mapping using [SMALT](http://www.sanger.ac.uk/resources/software/smalt/).
3. Variant calling using [FreeBayes](https://github.com/ekg/freebayes) and [SAMtools/BCFtools](http://samtools.sourceforge.net/mpileup.shtml).
4. Merging and filtering variant calls.
5. Aligning SNPs into an alignment SNP table.
6. Building a Maximum Likelihood tree with [PhyML](http://www.atgc-montpellier.fr/phyml/).
7. Examining tree with [FigTree](http://tree.bio.ed.ac.uk/software/figtree/).

A number of other options for building a whole genome phylogeny using the **reference mapping** method include.

* **Wombac**: <http://www.vicbioinformatics.com/software.wombac.shtml>
* **CSI Phylogeny**: <http://cge.cbs.dtu.dk/services/CSIPhylogeny/>
* **REALPHY**: <http://realphy.unibas.ch/fcgi/realphy>

Lab 1: Building a Core SNP Phylogenomic Tree
--------------------------------------------

This lab walks through how to run the core phylogenomics pipeline to generate a set of SNPs and a phylogenetic tree based on whole genome sequencing data.  This tutorial assumes you have have the pipeline installed and that you have some familiarity with working on the command line in Linux.

### Step 1: Constructing a Working Directory

To construct and switch to a working directory and obtain a copy of these instructions the following commands can be used.

	$ git clone https://github.com/apetkau/microbial-informatics-2014.git
	$ cd microbial-informatics-2014/labs/core-snp/
	$ ls
	Answers.md  images  mapping.conf  READMELargePhylogeny.md  README.md

### Step 2: Obtaining input data

The input data to the core phylogenomics pipeline consists of a reference genome (in FASTA format) and a set of sequencing reads (in FASTQ format).  The reference genome and sequencing reads are only a small section from the larger dataset which makes this overall pipeline a bit faster to run.  To see a walkthrough using the entire dataset please go to [READMELargePhylogeny.md](READMELargePhylogeny.md).

The data can be obtained with the following commands.

	$ cp /Course/MI_workshop_2014/day7/cholera-files-subsample.tar.gz .
	$ tar -xvf cholera-files-subsample.tar.gz

This will download and extract the data into two directories.  The first directory **cholera-files-subsample/reference/** contains the reference genome.  In this case, it is the region from 2mbp to 2.4mbp on chromosome I of *V. cholerae* 2010EL-1786.  This file looks like:

	$ ls cholera-files-subsample/reference/
	2010EL-1786-c1_2000_2400kb.fasta

	$ head cholera-files-subsample/reference/2010EL-1786-c1_2000_2400kb.fasta
	>gi|360034408|ref|NC_016445.1|_2000000_2400000
	CCCGCTCGCCACGCTTTGGCCATAGTGCTGCCTTCTACGATGTGTAAACCGTGCAACTTAATGCCATCGGTGCCTACCTT
	CAGTACTTGCTGTAACGTGGTGAGGTTTTCAGTGCGCTCTTCACCGGGTAACCCAACAATCAAGTGAGTACACACTTTGA
	...

The second directory, __cholera-files-subsample/fastq/__, contains the sequencing reads for all the other samples we will use to build a phylogenetic tree in FASTQ format.  These were downloaded from NCBI's [Sequence Read Archive](http://www.ncbi.nlm.nih.gov/sra/) reduced in coverage to 10x, and then filtered so we kept only those reads that map to the subregion on the reference genome.  The directory looks like:

	$ ls cholera-files-subsample/fastq/
	2010EL-1749.fastq  2010EL-1798.fastq  2012V-1001.fastq  C6706.fastq  VC-14.fastq  ...

	$ head cholera-files-subsample/fastq/2010EL-1749.fastq
	@HWUSI-EAS109E_0007_FC62MZGAAXX:6:59:5084:8496
	GAAACTGAGCTTATCCACTCCAGCAACTGCCAGCAC
	+
	ccccccacc[b^X`BBBBBBBBBBBBBBBBBBBBBB
	@HWUSI-EAS109E_0007_FC62MZGAAXX:6:45:6427:12268
	GATAACTACGATTCGTTTACTTACAACCTGTACCAA
	...

For information on exactly how these files were generated please see [get_data.sh](../dataset/get_data.sh).

### Step 3: Running the Core SNP pipeline

The command __snp_phylogenomics_control__ can used to generate a set of SNPs given the input data we just downloaded and build a whole genome phylogeny from a multiple alignment of these SNPs.  There are a number of different methods to building a whole genome phylogeny implemented in this pipeline but the method we will focus on for this tutorial is the reference mapping method.  

The reference mapping method can be run using the __--mode mapping__ parameter.  This requires as input the reference FASTA file, the FASTQ sequencing reads and a configuration file defining other parameters for the reference mapping mode.  For this tutorial, the configuration file is named __mapping.conf__ and looks like:

	%YAML 1.1
	---
	min_coverage: 2
	freebayes_params: '--pvar 0 --ploidy 1 --left-align-indels --min-mapping-quality 30 \
	 --min-base-quality 30 --min-alternate-fraction 0.75'
	smalt_index: '-k 13 -s 6'
	smalt_map: '-n 1 -f samsoft -r -1 -y 0.5'

The main parameter you will want to keep an eye on here is the __min_coverage__ parameter which defines the minimum coverage in a particular position to be included within the results.  For this tutorial we will leave the minimum coverage at 2 since the mean coverage for the downloaded data was 10.  For other data sets with different mean coverage values this number could be adjusted.

In order to run the pipeline, the following command can be used:

	$ snp_phylogenomics_control --mode mapping --input-dir cholera-files-subsample/fastq/ \
	   --reference cholera-files-subsample/reference/2010EL-1786-c1_2000_2400kb.fasta \
	   --output output-10-subsample --config mapping.conf
	Running core SNP phylogenomic pipeline on Wed Apr 23 11:53:50 CDT 2014
	Core Pipeline git Commit: c09e778dc9c51d9301b438b334f4c523de87bb4d
	vcf2pseudoalign git Commit: a2c73962ac48310c289b700976715c2d319d3227
	
	Parameters:
	...

When finished, you should expect to see the following output:

	================
	= Output Files =
	================
	tree: /path/to/output-10-subsample/phylogeny/pseudoalign.phy_phyml_tree.txt
	matrix: /path/to/output-10-subsample/pseudoalign/matrix.csv
	pseudoalignment: /path/to/output-10-subsample/pseudoalign/pseudoalign.phy
	stage: mapping-final took 0.00 minutes to complete
	pipeline took 8.08 minutes to complete

### Step 4: Example Results (optional)

If the pipeline fails to run, then the below steps can be performed with some example results that have already been computed.  These can be obtained with the commands.

	$ cp /Course/MI_workshop_2014/day7/output-10-subsample-example.tar.gz ./
	$ tar -xvvzf output-10-subsample-example.tar.gz

This will extract the example data to a directory named **output-10-subsample-example/**.

### Step 5: Examine Results

The main file you will want to check out is __output-10-subsample/phylogeny/pseudoalign.phy_phyml_tree.txt__, which is the computed phylogenetic tree.  This can be opened up using [FigTree](http://tree.bio.ed.ac.uk/software/figtree/) and should look similar to below.

![output-10-subsample.jpg](images/output-10-subsample.jpg)

Also, the file __output-10-subsample/pseudoalign/matrix.csv__ which contains a matrix of core SNP distances among all the input isolates.

	$ column -t output-10-subsample/pseudoalign/matrix.csv
	strain                      2010EL-1749  C6706  2010EL-1786-c1_2000_2400kb  2012V-1001 ...
	2010EL-1749                 0            21     4                           2          ...
	C6706                       21           0      21                          21         ...
	2010EL-1786-c1_2000_2400kb  4            21     0                           4          ...
	2012V-1001                  2            21     4                           0          ...
	VC-14                       3            20     3                           3          ...
	VC-15                       3            20     3                           3          ...
	VC-18                       3            20     3                           3          ...
	VC-25                       3            20     3                           3          ...
	VC-26                       3            20     3                           3          ...
	2010EL-1796                 2            19     2                           2          ...
	2010EL-1798                 2            19     2                           2          ...
	2011EL-2317                 2            19     2                           2          ...
	VC-1                        6            19     6                           6          ...
	VC-10                       6            19     6                           6          ...
	3554-08                     3            18     3                           3          ...
	VC-19                       3            18     3                           3          ...
	VC-6                        3            18     3                           3          ...

Also, the file __output-10-subsample/pseudoalign/pseudoalign-positions.tsv__ which includes every variant that was used by the pipeline for genetating the phylogenetic tree as well as those that were filtered out.

	$ head output-10-subsample/pseudoalign/pseudoalign-positions.tsv | column -t
	#Chromosome          Position  Status             Reference  2010EL-1749  2010EL-1796  ...
	..._2000000_2400000  13149     filtered-mpileup   A          N            A            ...
	..._2000000_2400000  17132     valid              A          A            A            ...
	...
	
This file contains a list of all variants detected by the pipeline, one per line.  Each variant is given a status, with *valid* indicating that the variants at that position were used for further analysis.  *Note: since reference mapping was performed with respect to the region starting at 2mbp on chromosome I, all positions are indicated relative to this region.*

A quick method to count the total number of 'valid' variants used to generate the phylogenetic tree and SNP matrix is with the following command:

	$ grep --count -P "\tvalid\t" output-10-subsample/pseudoalign/pseudoalign-positions.tsv
	28

Questions
---------

### Question 1

The **minimum coverage** setting within the **mapping.conf** file can have a large effect on the total number of valid positions used to generate the tree.  Please try re-running the pipeline with a minimum coverage of *5*.  What effect does this have on the total number of *valid* variants used to generate the phylogenetic tree?  What effect does this have on the phylogenetic tree generated?

### Question 2

The above tutorial generates a phylogeny only from a 400kbp fragment of the whole genome.  It would be expected that a more complete picture can be obtained by extracting variants using the entire genome, but this takes more time to run.  An example set of results obtained from running the pipeline on the entire genome (see the walkthrough [here](READMELargePhylogeny.md) for more information) can be obtained by running the following.
    
```bash
$ cp /Course/MI_workshop_2014/day7/output-10-example.tar.gz ./
$ tar -xvvzf output-10-example.tar.gz
```

This will extract the results into a directory __output-10-example/__.  Please examine the resulting whole genome phylgeny and the number of positions used to generate the phylogeny.  How does using the whole genome compare to only using a fragment of the genome?

[Answers](Answers.md)
