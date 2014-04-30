Feature Frequency Profiling Phylogeny Tutorial
==============================================

This project contains a tutorial for clustering genomes by frequences of kmers using <http://sourceforge.net/projects/ffp-phylogeny/> software.  This uses a custom version of ffp-phylogeny available at <https://github.com/apetkau/ffp-3.19-custom>.

Introduction
============

Tutorial
========

Step 1: Construct Working Directory
-----------------------------------

To construct a working directory for this lab and obtain a copy of the instructions the following commands can be used.

	$ git clone https://github.com/apetkau/microbial-informatics-2014.git
	$ cd microbial-informatics-2014/labs/ffp-phylogeny/
	$ ls
	Answers.md  images  README.md

Step 2: Download Software
-------------------------

Download software from <https://github.com/apetkau/ffp-3.19-custom> and install using the following steps:

```bash
$ git clone https://github.com/apetkau/ffp-3.19-custom.git
$ cd ffp-3.19-custom/
$ mkdir software
	
$ ./configure --disable-gui --prefix=`pwd`/software
$ make
$ make install

$ echo export PATH=`pwd`/software/bin:\$PATH >> ~/.bashrc
$ source ~/.bashrc
$ cd ..
$ ls
Answers.md  ffp-3.19-custom  images  README.md
```

Once these steps are complete, you can test if the software is installed by running `ffpre`.  For example:

```bash
$ ffpre
Usage: ffpry [OPTION]... [FILE]... 
Try `ffpry --help' for more information
```

Step 3: Input Files
-------------------

The input files for this software are assembled genomes in FASTA format.  The input data for this tutorial can be obtained with the following commands.

```bash
$ cp /Course/MI_workshop/day7/contigs-cholera.tar.gz ./
$ tar -xvf contigs-cholera.tar.gz
```

The above commands will create a directory __contigs/__ containing the assembled genomes in FASTA format.  This directory looks as follows.

```bash
$ ls contigs
2010EL-1749.fasta  2010EL-1796.fasta  2011EL-2317.fasta  3554-08.fasta  VC-10.fasta  VC-15.fasta  VC-19.fasta  VC-25.fasta  VC-6.fasta
2010EL-1786.fasta  2010EL-1798.fasta  2012V-1001.fasta   C6706.fasta    VC-14.fasta  VC-18.fasta  VC-1.fasta   VC-26.fasta
$ head contigs/2010EL-1749.fasta
>NODE_1_length_53485_cov_3.80401_ID_1
CTAAAAGGGGAGGGAACTGGATTTGTGTTCACTTGGAGTTTATTGCAGATTGTTGAGGGA
TAACGTGTTTATAGACATTTTAGAGTTAAAGCCTTAACTCTAAATCATTCGTTTCGGATT
```

Step 4: Generate genome name list
---------------------------------

In order to build a tree using `ffp` a list of all the names of each genome must be provided, one genome per line.  These must be in the same order as is processed by the commands in step 4.  Each name must be unique and can be no more than 50 characters (original version was no more than 10 characters).  This file can be generated with the following commands:

```bash
$ ls contigs/*.fasta | sed -e 's/^contigs\///' -e 's/\.fasta$//' > genome_names.txt
```

This will generate a file **genome_names.txt** that looks like the following:

```bash
$ head genome_names.txt
2010EL-1749
2010EL-1786
2010EL-1796
2010EL-1798
2011EL-2317
2012V-1001
3554-08
C6706
VC-10
VC-14
VC-15
VC-18
VC-19
VC-1
VC-25
VC-26
VC-6
```

Note: Adding or modifying any of the genomes within the **contigs/** directory will require re-generating the **genome_names.txt** file.

Step 5: Build Phylogeny
-----------------------

In order to build the phylogeny the following command can be used:

```bash
$ ffpry -l 5 contigs/*.fasta | ffpcol | ffprwn | ffpjsd -p genome_names.txt | ffptree > tree-5.txt
17 Taxa

Cycle   Type    i       Length          Type    j       Length
----------------------------------------------------------------
14      T       9       -4.80e-05       T       14      1.19e-04
...
```

This command generates a neighbor-joining tree from the set of genomes and writes the tree to a file **tree-5.txt**.

Step 6: View with FigTree
-------------------------

In order to view the generated tree the following command can be used.

```bash
$ figtree tree-5.txt
```

This should display a tree similar to below.

![tree-5.jpg](images/tree-5.jpg)


Questions
=========

Question 1
----------

The constructed tree used a kmer length of 5 by default `ffpry -l 5`.  What effect do you think adjusing this value would have on the final result?  Please adjust this value to 10 by running:

```bash
ffpry -l 10 contigs/*.fasta | ffpcol | ffprwn | ffpjsd -p genome_names.txt | ffptree > tree-10.txt
```

What effect does this have on the resulting tree?  Try adjusting to 15 and 20.

Question 2
----------

By default, the `ffpry` software will compress the nucleotide characters into one of two states: either a purine __R__ or pyrimidine __Y__.  This can be seen by examining the output of the `ffpry` program.

	$ ffpry -l 2 contigs/2010EL-1749.fasta
	RR      1988920 RY      1013697 YR      1013730

This shows the different 2-mer counts from __2010EL-1749__, encoded as either a purine or a pyramidine.

It's possible to remove the compression to only states __R__ or __Y__ and leave the 4 state nucleotide encoding by using the `-d` parameter.  For example:

	$ ffpry -d -l 2 contigs/2010EL-1749.fasta
	TA      191171  TC      476051  TG      587034  TT      662771  AC      441843  AG      452107  AT   275766   CC      397991  CG      235525  GC      296088

For a given k-mer size, this will result in more information being generated.  To construct a tree with the nucleotide counts we can use (don't forget __-d__ in `ffpcol` as well):

	$ ffpry -d -l 5 contigs/*.fasta | ffpcol -d | ffprwn | ffpjsd -p genome_names.txt | ffptree > tree-5-dna.txt

Run this for a kmer size of 5 and 10.  What differences do you notice in the tree as well as the running time?

[Answers](Answers.md)
