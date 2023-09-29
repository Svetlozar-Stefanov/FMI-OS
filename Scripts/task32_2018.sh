#!/bin/bash

if (( $# != 2 )); then
	echo Invalid number of parameters
	exit 1
fi

while IFS=, read -r id l1 l2 l3; do
	reg=^[0-9]*\,$l1\,$l2\,$l3$
	egrep --color $reg $1 | sort -n -t',' -k1 | head -n1
done <<< $(cat $1) | sort | uniq > $2
