#!/bin/csh

#########################################################################
# File Name: GO_DefenseFinder.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Detection of anti-MGE defense genes / systems using DefenseFinder."
        echo ""
        echo "Requires: DefenseFinder v1.0.8 (or higher) (Tesson et al, 2022) and *.faa files"
        echo ""
        echo "Usage: GO_DefenseFinder.sh <path_fasta_files> <path_output_files>"
        echo ""
    exit 0
endif

set path_fasta_files = "$1"
set path_output_files = "$2"

#########################################################################


echo "Running DefenseFinder"

module load defense-finder/1.0.8

foreach f ("$path_fasta_files"/*.faa)
    set fasta_filename = `basename $f`
    set output_dir = "$path_output_files/$fasta_filename:r"
    defense-finder run $f --preserve-raw -o $output_dir
end

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
