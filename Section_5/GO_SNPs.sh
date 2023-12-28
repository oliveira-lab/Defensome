#!/bin/csh

#########################################################################
# File Name: GO_SNPs.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Searches genetic diversity (SNPs + indels) using Freebayes."
        echo ""
        echo "Requires: BWA v.0.7.17, samtools v.1.15.1, Freebayes v.1.1.0 (Garrison et al, 2012), fastq files and a fasta file"
        echo ""
        echo "Usage: GO_SNPs.sh <*.fna> <*_1.fastq> <*_2.fastq>"
        echo ""
    exit 0
endif

set fasta_files = "$1"
set fastq_1 = "$2"
set fatsq_2 = "$3"
set output_dir = "$fasta_files:r"

#########################################################################


echo "Running samtools and BWA"

module load bwa/0.7.17
module load samtools/1.15.1

samtools faidx $fasta_files
bwa index $fasta_files
bwa mem -t 8 $fasta_files $fastq_1 $fastq_2 | samtools sort -n -l 0 -T /tmp --threads 3 -m 2000M | samtools fixmate -m --threads 3 - - | samtools sort -l 0 -T /tmp --threads 3 -m 2000M | samtools markdup -T /tmp --threads 3 -r -s - -  > $output_dir.bam
samtools index $output_dir.bam

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running Freebayes"

module load freebayes/1.1.0

fasta_generate_regions.py $fasta_files.fai 1000 > $output_dir.txt
freebayes-parallel $output_dir.txt 8 -p 1 -P 0 -C 1 -F 0.025 --min-coverage 8 --min-repeat-entropy 1.0 -q 13 -m 60 --strict-vcf -f $fasta_files $output_dir.bam > $output_dir.vcf


tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
