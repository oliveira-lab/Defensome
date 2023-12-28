#!/bin/csh

#########################################################################
# File Name: GO_ICEs_IMEs.sh
# Author(s): Angelina Beavogui
# Institution: Genoscope, Evry, France
# Mail: beavogui67@gmail.com
# Date: 07/11/2023
#########################################################################


if ("$1" == "-h" || "$1" == "-help") then
        echo ""
        echo "Searches Integrative conjugative elements (ICEs) and integrative mobilizable elements (IMEs) using ICEfinder."
        echo ""
        echo "Requires: ICEfinder v.2.6.32-696.10.2.el6.x86_64 (or higher) (Liu et al, 2019) and *.gbk files"
        echo ""
        echo "Usage: GO_ICEs_IMEs.sh <path_gbk_files>"
        echo ""
    exit 0
endif

set path_gbk_files = "$1"

#########################################################################


echo "Running ICEfinder"

module load icefinder/1.0

ICEfinder_prepare out_icefinder $path_gbk_files | awk 'NR>1' > tmp.sh
chmod a+x tmp.sh
./tmp.sh

tput setaf 2; echo "Done!"; tput sgr0

#########################################################################

