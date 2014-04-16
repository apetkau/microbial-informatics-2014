Ortholog Detection with OrthoMCL: Answers
=========================================

1. A quick way to search for all the gene products in the annotated FASTA files is:

```bash
$ echo 2010EL-1749_02114,2010EL-1796_03119,2010EL-1798_02875,2011EL-2317_03311,2012V-1001_01554,3554-08_03049,VC-10_00387,VC-15_00297,VC-18_00534,VC-19_00302,VC-1_00125,VC-6_00154,Vch1786_I0090 |tr ',' '\n' | xargs -I {} grep "{}" annotations/*.fasta
annotations/2010EL-1749.fasta:>2010EL-1749_02114 DNA polymerase V subunit UmuC
annotations/2010EL-1796.fasta:>2010EL-1796_03119 DNA polymerase V subunit UmuC
annotations/2010EL-1798.fasta:>2010EL-1798_02875 DNA polymerase V subunit UmuC
annotations/2011EL-2317.fasta:>2011EL-2317_03311 DNA polymerase V subunit UmuC
annotations/2012V-1001.fasta:>2012V-1001_01554 DNA polymerase V subunit UmuC
annotations/3554-08.fasta:>3554-08_03049 DNA polymerase V subunit UmuC
annotations/VC-10.fasta:>VC-10_00387 DNA polymerase V subunit UmuC
annotations/VC-15.fasta:>VC-15_00297 DNA polymerase V subunit UmuC
annotations/VC-18.fasta:>VC-18_00534 DNA polymerase V subunit UmuC
annotations/VC-19.fasta:>VC-19_00302 DNA polymerase V subunit UmuC
annotations/VC-1.fasta:>VC-1_00125 DNA polymerase V subunit UmuC
annotations/VC-6.fasta:>VC-6_00154 DNA polymerase V subunit UmuC
annotations/2010EL-1786.fasta:>Vch1786_I0090 [cholerae O1 str. 2010EL-1786] error-prone repair protein UmuC
```

This indicates that there was only one genome that was different, 2010EL-1786.  This is because this was the only genome that wasn't annotated using prokka.  Instead, the annotations were extracted from the GenBank file on NCBI.  More information on the particular gene can be found at http://www.ncbi.nlm.nih.gov/gene/?term=Vch1786_I0090.
