Preparing PHYLOViZ Input
========================

After running the data through the core SNP pipeline as described in https://github.com/apetkau/microbial-informatics-2014/tree/master/labs/core-snp the following commands were run on the input file __output-10-example/pseudoalign/pseudoalign-positions.tsv__.

	$ head output-10-example/pseudoalign/pseudoalign-positions.tsv | column -t
	#Chromosome                    Position  Status             Reference  2010EL-1749  2010EL-1796  2010EL-1798  2011EL-2317  2012V-1001  3554-08  C6706  VC-1  VC-10  VC-14  VC-15  VC-18  VC-19  VC-25  VC-26  VC-6
	gi|360034408|ref|NC_016445.1|  17885     valid              T          T            T            T            T            T           T        G      T     T      T      T      T      T      T      T      T
	gi|360034408|ref|NC_016445.1|  24001     filtered-coverage  T          T            T            -            T            T           T        G      T     T      T      T      T      T      T      T      T

	$ positions2phyloviz.pl -i output-10-example/pseudoalign/pseudoalign-positions.tsv -b lab1-snp --reference-name 2010EL-1786
	Date: Thu Apr 17 15:52:18 CDT 2014
	Working on output-10-example/pseudoalign/pseudoalign-positions.tsv
	Kept 360 valid positions
	Skipped 1413 positions
	Found 2 duplicate SNP profiles
	SNP profile information written to lab1-snp-profile.tsv
	SNP type/strain mapping written to lab1-snp-strains.tsv	

This command builds the input files necessary for PHYLOViZ, __lab1-snp-profile.tsv__ and __lab1-snp-strains.tsv__.

The file __lab1-snp-profile.tsv__ contains a tabular SNP profile of each strain, with rows representing a new strain and columns representing a SNP at a particular position in the strain.  This looks as follows:

	$ head lab1-snp-profile.tsv | column -t
	ST  gi|360034408|ref|NC_016445.1|_17885  gi|360034408|ref|NC_016445.1|_28297  ...
	1   T                                    A                                    ...
	2   T                                    A                                    ...
	3   T                                    A                                    ...
	...

The first column represents a **Sequence Type** for each strain.  That is, an assigned ID to each unique combination of SNPs in the profile.  The later columns represent the particular nucleotide at a particular position, identified by the first line.  So, for example, the letter **T** in the second line represents a nucleotide **T** at position **17885** on contig **gi|360034408|ref|NC_016445.1|** for the sequence type **1**.

The file __lab1-snp-strains.tsv__ contains a mapping of the Sequence Type in the SNP Profile to a particular strain ID.  This looks as follows:

	$ head lab1-snp-strains.tsv
	ST  Strain
	1   2010EL-1786
	2   2010EL-1749
	3   2010EL-1796
	3   2010EL-1798
	...

Note: It is possible for more than one strain to have the same Sequence Type identifier, which indicates that both strains SNP profiles are identical.

Extra information was added as separate columns to __lab1-snp-strains.tsv__ based on data from http://mbio.asm.org/content/4/4/e00398-13 and http://mbio.asm.org/content/2/4/e00157-11.abstract.
