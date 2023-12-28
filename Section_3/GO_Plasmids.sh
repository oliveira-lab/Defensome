#!/bin/csh

#########################################################################
# File Name: GO_Plasmids.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Searches plasmids using PlasClass and PlasFlow"
        echo ""
        echo "Requires: PlasClass v.0.1.1 (or higher) (Pellow et al, 2020), PlasFlow v.1.1 (or higher) (Krawczyk et al, 2018) and a fasta file"
        echo ""
        echo "Usage: GO_Plasmids.sh <*.fna>"
        echo ""
    exit 0
endif

set fasta_file = "$1"

#########################################################################


echo "Running PlasClass"

module load plasclass/0.1.1

python /env/products/plasclass/0.1.1/bin/classify_fasta.py -f $fasta_file

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running PlasFlow"

PlasFlow.py --input $fasta_file --output $fasta_file.tsv --threshold 0.7

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
