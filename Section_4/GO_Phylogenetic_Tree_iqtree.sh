#!/bin/csh

#########################################################################
# File Name: GO_Phylogenetic_Tree_iqtree.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Construction of a phylogenetic tree using iqtree"
        echo ""
        echo "Requires: Muscle v.5.1 (Edgar, 2022), BMGE v.2.0 (Criscuolo, 2010), convert_fasta_to_phy.py, iqtree v.2.2.6 (or higher) (Minh et al, 2020) and a *.faa file"
        echo ""
        echo "Usage: GO_Phylogenetic_Tree_iqtree.sh <path_fasta_files>"
        echo ""
    exit 0
endif

set path_fasta_files = "$1"

#########################################################################


echo "Running Muscle"


foreach f ("$path_fasta_files"/*.faa)
    set fasta_filename = `basename $f`
    set output_dir = "$fasta_filename:r"

    awk 'BEGIN {RS=">"} /30S|50S/ && /L2|L3|L4|L5|L6|L14|L16|L18|L22|L24|S3|S8|S10|S17|S19/ && $0 !~ /L20|L21|L23|L25|L26|L27|L28|L29|L30|L31|L32|L33|L34|L35|L36/ {print ">"$0}' $f | awk '{if($1~">") print substr($1,1,8)"_"$2,$NF; else print $0}' | awk '/^>/ {printf("%s%s\t",(N>0?"\n":""),$0);N++;next;} {printf("%s",$0);} END {printf("\n");}' | awk '{print $1,$2,$3}' | awk '{if($2!~"[a-z][a-z]") print $0}' |  sort -k1,1 -k2.3n | awk '{print $3}' | tr -d '\n' | awk '{print ">" ORS $0}' | awk -v var=$f '/^>/{print ">" substr(var,1,length(var)-4); next} 1' > $output_dir.out
end

cat *.out > Concatenate.fa
rm *.out

./muscle5.1.linux_intel64 -super5 Concatenate.fa -output Concatenate_Aligned.fa --threads 30

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running BMGE"

module load bmge/2.0

BMGE -i Concatenate_Aligned.fa -t AA -of Concatenate_Aligned_trimmed.fa

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################


echo "Running iqtree"

python3.8 convert_fasta_to_phy.py --input-fasta Concatenate_Aligned_trimmed.fa --output-phy file.phy

./iqtree2 -pre Tree -s file.phy -nt 56 -cmax 15 -bb 1000 -alrt 1000 -m TESTNEW -safe

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################