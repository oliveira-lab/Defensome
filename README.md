# The defensome of complex bacterial communities (supplementary material)
Support wrapper scripts for Beavogui et al. (2023) BioRxiv.

## Description

Bacteria have developed various defense mechanisms to avoid infection and killing in response to the fast evolution and turnover of viruses and other genetic parasites. Such pan-immune system (or defensome) encompasses a growing number of defense lines that include well-studied innate and adaptive systems such as abortive infection, CRISPR-Cas and restriction-modification, but also newly found ones whose mechanisms are still poorly understood. While the abundance and distribution of defense systems is well-known in complete and culturable genomes, there is a void in our understanding of their diversity and richness in complex microbial communities. In Beavogui et al., we performed a large-scale in-depth analysis of the defensomes of high-quality bacterial population genomes reconstructed from soil, marine, and human gut environments. Here we present the collection of wrapper scripts used in this work. 
[(Beavogui et al., 2023, BioRxiv)](https://www.biorxiv.org/content/10.1101/2023.08.12.553040v2). 

PLEASE NOTE: Our pipeline includes a set of wrapper shell scripts that allow to reconstitute the major analyses steps of this publication. However, this pipeline requires multiple dependencies, which have to be installed prior to its use. 

## Sections
Details on the requirements and usage of all shell wrapper scripts can be accessed by **scriptname -h (or -help)**.

### 1) MAG annotation
* **GO_Prokka.sh** performs the annotation of each MAG using [Prokka](https://pubmed.ncbi.nlm.nih.gov/24642063/). It takes as input the path of the folder containing the fasta file(s) with extension \*\.fna, as well as the path for the output results folder.

### 2) Identification of anti-MGE defense genes and systems
* **GO_DefenseFinder.sh** detection of anti-MGE defense genes / systems by [DefenseFinder](https://pubmed.ncbi.nlm.nih.gov/35538097/). It takes as input the path of the folder containing the fasta file(s) with extension \*\.faa, as well as the path for the output results folder.
* **GO_EggnogMapper.sh** performs the functional annotation of genes with [EggNOG-mapper](https://pubmed.ncbi.nlm.nih.gov/34597405/). It takes a multifasta file as input.

### 3) Identification of MGEs
* **GO_ICEs_IMEs.sh** detects Integrative Conjugative Elements (ICEs) and Integrative Mobilizable Elements (IMEs) using [ICEfinder](https://pubmed.ncbi.nlm.nih.gov/30407568/). It takes the path of the folder containing the gbk file(s).
* **GO_Integron.sh** detects integrons using [Integron Finder](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4889954/). It takes a fasta file as input.
* **GO_Plasmids.sh** detects plasmids using [PlasClass](https://pubmed.ncbi.nlm.nih.gov/32243433/) and [PlasFlow](https://pubmed.ncbi.nlm.nih.gov/29346586/). It takes a fasta file as input.
* **GO_Prophages.sh** detects prophages using [Virsorter2](https://pubmed.ncbi.nlm.nih.gov/33522966/). It takes in the path of the folder containing the fasta file(s) with extension \*\.fna, as well as the path for the output results folder.

### 4) Phylogenetic analyses
* **GO_Phylogenetic_Tree_RAxML.sh** construction of phylogenetic tree using [RAxML](https://pubmed.ncbi.nlm.nih.gov/24451623/). It takes the path of the folder containing the fasta file(s) with extension \*\.faa. It then performs an alignment with [MAFFT](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC135756/) and trims poorly aligned regions with [BMGE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3017758/).
* **GO_Phylogenetic_Tree_iqtree.sh** construction of phylogenetic tree using [iqtree2](https://academic.oup.com/mbe/article/37/5/1530/5721363). It takes the path of the folder containing the fasta file(s) with extension \*\.faa. It then performs an alignment with [Muscle](https://www.nature.com/articles/s41467-022-34630-w) and trims poorly aligned regions with [BMGE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3017758/). 
* **convert_fasta_to_phy.sh** converts the fasta alignment into a phylip file for running iqtree.

### 5) Variant analysis of the defensome
* **GO_SNPs.sh** Searches genetic diversity (SNPs + indels) using [Freebayes](https://arxiv.org/abs/1207.3907). It takes as input the fasta file and the two associated fastq files.
* **GO_AXT.sh** Pipline to obtain *\\.axt files, for use with the [KaKs_calculator software](https://ngdc.cncb.ac.cn/tools/kaks).