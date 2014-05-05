Generating Dataset
==================

This directory contains information on how the dataset for these labs was generated.  The detailed commands can be found at [get_data.sh](get_data.sh) but the basic steps are as follows.

1. Download all sequence reads listed in [files.txt](files.txt) from NCBI.
2. Reduce the amount of reads stored.
3. Assemble genomes using SPAdes.
4. Annotate genomes using Prokka.
5. Reduce reads further for reference mapping/core SNP analysis.
