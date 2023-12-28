#!/bin/csh

#########################################################################
# File Name: GO_Integrons.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Computes integrons from a FASTA file using IntegronFinder."
        echo ""
        echo "Requires: IntegronFinder v.2.0.a1 (or higher) (Cury et al, 2016) and a fasta file"
        echo ""
        echo "Usage: GO_Integrons.sh <*.fasta>"
        echo ""
    exit 0
endif

set fasta_file = "$1"

#########################################################################


echo "Running IntegronFinder"

module load integron_finder/2.0.a1

integron_finder $fasta_file --local_max 


tput setaf 2; echo "Done!"; tput sgr0

#########################################################################

