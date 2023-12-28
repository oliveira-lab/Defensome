#!/bin/csh

#########################################################################
# File Name: GO_AXT.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Create *.axt needed to calculate nonsynonymous (Ka) and synonymous (Ks) substitution rates"
        echo ""
        echo "Requires: ParaAT (https://github.com/wonaya/ParaAT), blast+ v.2.11.0, silix v.1.2.11, fasta protein and nucleotide file (gene_name.faa and gene_name.fa) "
        echo ""
        echo "Usage: GO_AXT.sh <gene_name>"
        echo "Exemple: GO_AXT.sh IetA"
    exit 0
endif

set gene="$1"

#########################################################################


echo "Running all steps needed to obtain *.axt file"

module load blast+/2.11.0
module load silix/1.2.11
module load perl/5.16.3
module load muscle/3.8.1551

makeblastdb -dbtype prot -in ""$gene"".faa
blastp -query "$gene".faa -db "$gene".faa -outfmt 6 -out "$gene"_out -evalue 0.001
silix -i 0.8 "$gene".faa "$gene"_out | sort > "$gene"_silix
awk '(count[$1]++ < 1) { data[$1] = $0; }END{for (x in data) if (count[x] == 1) print data[x]; }' "$gene"_silix | sort > temp4
awk 'FNR==NR{a[$0];next}!($0 in a)' temp4 "$gene"_silix > temp5
awk '{print $2}' temp5 | sort > temp6
perl -ne 'if(/^>(\S+)/){$p=$i{$1}}$p?print:chomp;$i{$_}=1 if @ARGV' temp6 "$gene".fa |awk '{if($1~">") print $1; else print $0}' |awk 'BEGIN {RS=">";FS="\n";OFS=""} NR>1 {print ">"$1; $1=""; print}' |awk 'NR%2{printf "%s ",$0;next;}1' | sort -k1,1 | tr ' ' '\n/' > temp.cds
perl -ne 'if(/^>(\S+)/){$p=$i{$1}}$p?print:chomp;$i{$_}=1 if @ARGV' temp6 "$gene".faa |awk '{if($1~">") print $1; else print $0}' |awk 'BEGIN {RS=">";FS="\n";OFS=""} NR>1 {print ">"$1; $1=""; print}' |awk 'NR%2{printf "%s ",$0;next;}1' | sort -k1,1 | tr ' ' '\n/' > temp.pep
awk '{if ($1 in data) {data[$1] = data[$1] " " $2;} else {data[$1] = $2;}} END {for (key in data) {split(data[key], pairs, " "); for (i = 1; i < length(pairs); i++) {for (j = i + 1; j <= length(pairs); j++) {print pairs[i], pairs[j];}}}}' temp5 > temp.homologs
perl ParaAT.pl -h temp.homologs -n temp.cds -a temp.pep -p proc -o output_"$gene" -f axt # to make axt
cat output_"$gene"/*.axt > "$gene".axt
rm temp*

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################
