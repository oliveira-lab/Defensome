#!/bin/csh

#########################################################################
# File Name: GO_Phylogenetic_Tree_RAxML.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Construction of phylogenetic tree using RAxML (Stamatakis, 2014)"
        echo ""
        echo "Requires: MAFFT v.7.490, BMGE v.2.0, RAxML v.8.2.12 (or higher) and *.faa file"
        echo ""
        echo "Usage: GO_Phylogenetic_Tree_RAxML.sh <path_fasta_files>"
        echo ""
    exit 0
endif

set path_fasta_files = "$1"

#########################################################################


echo "Running MAFFT"

foreach f ("$path_fasta_files"/*.faa)
    set fasta_filename = `basename $f`
    set output_dir = "$fasta_filename:r"

    awk 'BEGIN {RS=">"} /30S|50S/ && /L2|L3|L4|L5|L6|L14|L16|L18|L22|L24|S3|S8|S10|S17|S19/ && $0 !~ /L20|L21|L23|L25|L26|L27|L28|L29|L30|L31|L32|L33|L34|L35|L36/ {print ">"$0}' $f | awk '{if($1~">") print substr($1,1,8)"_"$2,$NF; else print $0}' | awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' | awk '{print $1,$2,$3}' | awk '{if($2!~"[a-z][a-z]") print $0}' |  sort -k1,1 -k2.3n | awk '{print $3}' | tr -d '\n' | awk '{print ">" ORS $0}' | awk -v var=$f '/^>/{print ">" substr(var,1,length(var)-4); next} 1' > $output_dir.out
end

cat *.out > Concatenate.fa
rm *.out

module load mafft/7.490
mafft --maxiterate 1000 --globalpair Concatenate.fa > Concatenate_Aligned.fa

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running BMGE"

module load bmge/2.0

BMGE -i Concatenate_Aligned.fa -t AA -of Concatenate_Aligned_trimmed.fa

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running RAxML"

module load raxml/8.2.12

raxmlHPC-PTHREADS-AVX -f a -m PROTGAMMAAUTO -N autoMRE -p 12345 -x 12345 -s Concatenate_Aligned_trimmed.fa -n Tree 

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################