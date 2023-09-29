#!/bin/bash

if (( $# != 1 )); then
	echo 'Invalid number of parameters'
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo 'Not a valid file name'
	exit 2
fi

cut -d' ' -f4- $1 | 
awk -v i=1 '{printf "%d. %s\n", i, $0; i+=1 }' |
sort -t' ' -k2
