#!/bin/csh

#########################################################################
# File Name: GO_EggNOG-mapper.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Functional annotation of genes with EggNOG-mapper."
        echo ""
        echo "Requires: EggNOG-mapper v.2.1.9 (or higher) (Cantalapiedra et al, 2021) and a multifasta file"
        echo ""
        echo "Usage: GO_EggNOG-mapper.sh <multifasta.faa>"
        echo ""
    exit 0
endif

set multifasta = "$1"

#########################################################################


echo "Running EggNOG-mapper"

module load eggnog-mapper/2.1.9

emapper.py -i $multifasta -o out_eggNOG --cpu 8

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
