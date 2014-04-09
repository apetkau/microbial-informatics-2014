Feature Frequency Profiling Phylogeny Tutorial
==============================================

This project contains a tutorial for clustering genomes by frequences of kmers using <http://sourceforge.net/projects/ffp-phylogeny/> software.  This uses a custom version of ffp-phylogeny available at <https://github.com/apetkau/ffp-3.19-custom>.

Steps
=====

Step 1: Download Software
-------------------------

Download software from <https://github.com/apetkau/ffp-3.19-custom> and install using the following steps:

```bash
$ git clone https://github.com/apetkau/ffp-3.19-custom.git
$ cd ffp-3.19-custom/
	
$ ./configure --disable-gui --prefix=`pwd`/../software
$ make
$ make install

$ export PATH=`pwd`/../software/bin:$PATH
```

Once these steps are complete, you can test if the software is installed by running `ffpre`.  For example:

```bash
$ ffpre
Usage: ffpre [OPTION]... [FILE]... 
Try `ffpre --help' for more information
```

Step 2: Input Files
-------------------

Input files are provided within the **assemblies/** directory.  These consist of the assembled contigs for the genomes in FASTA format.  There are 123 files in total, which can be seen by running the command:

```bash
$ ls assemblies/*.fa | wc -l
123
```

The files look as follows:

```bash
$ ls assemblies/*.fa
assemblies/2009V-1046.fa
assemblies/2009V-1085.fa
assemblies/2009V-1096.fa
...
```

The contents of the files look as follows:

```bash
$ head assemblies/2009V-1046.fa
```

Step 3: Generate genome name list
---------------------------------

In order to build a tree using `ffp` a list of all the names of each genome must be provided, one genome per line.  These must be in the same order as is processed by the commands in step 4.  Each name must be unique and can be no more than 50 characters (original version was no more than 10 characters).  This file can be generated with the following commands:

```bash
$ ls assemblies/*.fa | sed -e 's/^assemblies\///' -e 's/\.fa$//' > genome_names.txt
```

This will generate a file **genome_names.txt** that looks like the following:

```bash
$ head genome_names.txt
2009V-1046
2009V-1085
2009V-1096
...
```

Note: Adding or modifying any of the genomes within the **assemblies/** directory will require re-generating the **genome_names.txt** file.

Step 4: Build Phylogeny
-----------------------

In order to build the phylogeny the following command can be used:

```bash
$ ffpry -l 5 assemblies/*.fa | ffpcol | ffprwn | ffpjsd -p genome_names.txt | ffptree > tree.txt
```

Step 5: View with FigTree
-------------------------

```bash
$ figtree tree.txt
```

This should produce a tree similar to below.

![tree.jpg](tree.jpg)

Questions
=========

Question 1
----------

The constructed tree used a kmer length of 5 by default `ffpry -l 5`.  What effect do you think adjusing this value would have on the final result?  Please adjust this value to 10 by running:

```bash
ffpry -l 10 assemblies/*.fa | ffpcol | ffprwn | ffpjsd -p genome_names.txt | ffptree > tree_10.txt
```

What effect does this have on the resulting tree?  Try adjusting to 15 and 20.
