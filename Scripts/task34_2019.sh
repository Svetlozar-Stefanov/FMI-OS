#!/bin/bash

N=10

rp=0
for param in "$@"; do
	if [[ $param == -n ]]; then
		rp=1
		continue
	fi

	if (( $rp == 1 )); then
		N=$parm
		rp=0
		continue
	fi
	idf=$(echo $param | cut -d'.' -f1)
	awk -v idf=$idf '{ for (i=1; i<= NF; i++){ printf "%s ",$i; if( i == 2 ) printf "%s ", idf;} printf "\n" }' $param
done <<< "$*"
