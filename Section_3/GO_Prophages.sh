#!/bin/csh

#########################################################################
# File Name: GO_Prophages.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Searches Prophages using Virsorter2."
        echo ""
        echo "Requires: Virsorter2 v.2.2.3 (or higher) (Guo et al, 2021) and a *.fna file"
        echo ""
        echo "Usage: GO_Prophages.sh <path_fasta_files> <path_output_files>"
        echo ""
    exit 0
endif

set path_fasta_files = "$1"
set path_output_files = "$2"

#########################################################################


echo "Running Virsorter2"

foreach f ("$path_fasta_files"/*.fna)
    set fasta_filename = `basename $f`
    set output_dir = "$path_output_files/$fasta_filename:r"
    virsorter run --keep-original-seq -i $f -w $output_dir --include-groups dsDNAphage,ssDNA --min-length 5000 --min-score 0.9 -j 28 all 
    checkv end_to_end $output_dir/final-viral-combined.fa $output_dir/checkv -t 1 -d /data/checkv-db-v1.2
end

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
