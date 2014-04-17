Minimum Spanning Tree with Phyloviz
===================================

Introduction
============

Tutorial
========

This tutorial will go through constructing a minimum spanning tree from SNP, MLST, and other typing data.  The software we will use for constructing these trees is [phyloviz](http://www.phyloviz.net).

Constructing a Working Directory
--------------------------------

To construct a working directory and obtain a copy of these instructions the following commands can be used.

	$ git clone http://gitlab.corefacility.ca/aaron.petkau/microbialinformatics2014.git
	$ cd microbialinformatics2014/mst-tutorial/
	$ ls
	README.md

Obtaining Input Data
--------------------

	$ cp /Course/MI_workshop/ ./
	tar -xvvzf 

This will extract the necessary files for this tutorial into a directory.

Starting Phyloviz
-----------------

In order to start phyloviz the following command can be entered in a terminal.

	$ phyloviz

This should launch phyloviz which should look similar to the following.

![images/phyloviz-start.jpg](images/phyloviz-start.jpg)

Lab 1: Minimum Spanning Tree with SNP Data
------------------------------------------

This lab will walk you through building a minimum spanning tree using SNP data.  The SNP data we will be using was generated using the methods described in the tutorial on [Core SNP Phylogenies](http://gitlab.corefacility.ca/aaron.petkau/microbialinformatics2014/blob/master/core-snp-tutorial/README.md).  In particular, the input file is the __pseudoalign-positions.tsv__ file, which was taken through the steps described at in [PrepareInput.md](PrepareInput.md).

Please follow the below steps to generate a minimum spanning tree.

1. Load Dataset.
    a. Click on **File > Load Dataset**
    b. Name this dataset *Lab1*.  Set the **Dataset Type** to *SNP*.  When finished, click Next.  This should bring you to a **Typing Data** screen.
    c. Click on **Browse...** and find the file *lab1-snp-profile.tsv*.  This file contains a set of sequence types (in column *ST*) defined based on the SNP data at different positions.  Click **Next** to continue.  This file looks similar to the following.
	
	```
	ST  gi|360034408|ref|NC_016445.1|_17885  gi|360034408|ref|NC_016445.1|_28297
	1   T                                    A
	2   T                                    A
	3   T                                    A
	```
	
    d. Click on **Browse...** and find the file *lab1-snp-strains.tsv*.  This file contains a mapping of the sequence types (in column *ST*) to strain ids.  Please make sure that the **Key** drop down menu is set to *ST* to indicate that this column contains the sequence types.  Click **Finish** to finish loading the data.  The file that was loaded looks similar to below.
	
	```
	ST  Strain
	1   2010EL-1786
	2   2010EL-1749
	3   2010EL-1796
	```
	
2. Examine Data
3. Run goeBURST
4. View Results

Questions
=========

