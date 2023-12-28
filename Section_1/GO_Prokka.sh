#!/bin/csh

#########################################################################
# File Name: GO_Prokka.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "MAG annotation with Prokka"
        echo ""
        echo "Requires: Prokka v.1.15.5 (or higher) (Seemann, 2014) and *.fna files"
        echo ""
        echo "Usage: GO_Prokka.sh <path_fasta_files> <path_output_files>"
        echo ""
    exit 0
endif

set path_fasta_files = "$1"
set path_output_files = "$2"

#########################################################################


echo "Running Prokka"

module load prokka/1.14.5

foreach f ("$path_fasta_files"/*.fna)
    set fasta_filename = `basename $f`
    set output_dir = "$path_output_files/$fasta_filename:r"
    prokka $f --outdir $output_dir
end

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
