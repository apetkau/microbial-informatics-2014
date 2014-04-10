Ortholog Detection with OrthoMCL
================================

This tutorial covers ortholog detection using [OrthoMCL](http://orthomcl.org/common/downloads/software/v2.0/).  Instead of running all the software for OrthoMCL manually, we will take advantage of the [OrthoMCL Pipeline](https://github.com/apetkau/orthomcl-pipeline) to automate this process.

Step 1: Obtaining input Data
============================

The input data for OrthoMCL consists of a set of genes.  This can be downloaded from:

	$ wget http://url-to-data/annotations-cholera.tar.gz
	$ tar -xvvzf annotations-cholera.tar.gz

This will extract the annotated genomes into a directory __annotations/__.  This directory looks as follows:

	$ ls annotations/
	2010EL-1749.faa  2010EL-1796.faa  2010EL-1798.faa  2011EL-2317.faa  2012V-1001.faa  3554-08.faa  C6706.faa  VC-10.faa  VC-14.faa  VC-15.faa  VC-18.faa  VC-19.faa  VC-1.faa  VC-25.faa  VC-26.faa  VC-6.faa
	2010EL-1749.ffn  2010EL-1796.ffn  2010EL-1798.ffn  2011EL-2317.ffn  2012V-1001.ffn  3554-08.ffn  C6706.ffn  VC-10.ffn  VC-14.ffn  VC-15.ffn  VC-18.ffn  VC-19.ffn  VC-1.ffn  VC-25.ffn  VC-26.ffn  VC-6.ffn

The files __*.faa__ contains the genes as amino acid sequences.  The files __*.ffn__ contain the genes as nucleotide sequences.  For example:

	$ head annotations/2010EL-1749.faa
	>2010EL-1749_00001 Stalked cell differentiation-controlling protein
	MDARLFDNTQTLRASVLCGLSFFWALIAFLMALINFWSTRLVELASLELVCAFYSLYIYS
	LAKRRIHTKQQVYLYLFILTGTTLFATYMKPLMMGVYIWSCFVPILFYIFTSARFAFVTS
	...

	$ head annotations/2010EL-1749.ffn
	>2010EL-1749_00001 Stalked cell differentiation-controlling protein
	ATGGATGCTAGGTTATTTGACAATACACAAACGCTTCGAGCTTCAGTGCTATGCGGCCTA
	AGTTTCTTTTGGGCTTTGATCGCTTTCTTGATGGCGCTGATCAATTTCTGGTCAACACGG
	...


