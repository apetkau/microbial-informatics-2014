Answers
=======

Answer 1
--------

Running ffp with a kmer length of 10, 15, or 20 will generate a more diverse profile for each genome, but at the cost of taking longer to run.  The following table describes the running time and resulting trees.

| K-mer Length | Time (s) | Result                             |
|:------------:|:--------:|:----------------------------------:|
| 5            | 2.7      | ![tree-5.jpg](images/tree-5.jpg)   |
| 10           | 2.7      | ![tree-10.jpg](images/tree-10.jpg) |
| 15           | 5.7      | ![tree-15.jpg](images/tree-15.jpg) |
| 20           | 131      | ![tree-20.jpg](images/tree-20.jpg) |

Notice how the branch lengths are increasing and the genomes are beginning to visibly cluster as the kmer length increases.

Answer 2
--------

| K-mer Length | Time (s) | Result                                     |
|:------------:|:--------:|:------------------------------------------:|
| 5            | 2.9      | ![tree-5-dna.jpg](images/tree-5-dna.jpg)   |
| 10           | 113      | ![tree-10-dna.jpg](images/tree-10-dna.jpg) |

Note: The publication at http://www.ncbi.nlm.nih.gov/pmc/articles/PMC2806744/ describes a method for selecting the best parameters and also shows that the trees will converge quickly to a stable solution as the k-mer length increases.  They also describe a method for computing statistical support for the branching order of the major groups.  Also, see the publication http://www.pnas.org/content/108/20/8329.
