#!/bin/bash

if (( $# != 3 )); then
	echo "ERROR: Invalid number of parameters"
	exit 1
fi

num_reg="^([[:digit:]]+\.)?[[:digit:]]+$"

if [[ ! $1 =~ $num_reg ]]; then
	echo "ERROR: First argument not a number"
	exit 2
fi

pre_sym=$2
u_sym=$3

prefix_row=$(egrep --color "^[^,]*,$pre_sym,([[:digit:]]+\.)?[[:digit:]]+$" prefix.csv)
base_row=$(egrep --color "^[^,]*,$u_sym,[^,]*" base.csv)

if [[  -z $prefix_row ]]; then
	echo "Could not find prefix"
	exit 3
fi

decimal=$(echo $prefix_row | cut -d',' -f3)
num=$(awk "BEGIN { printf(\"%.5f\n\", $1 * $decimal) }")

if [[ -z $base_row ]]; then

	echo "Could not find base"
	exit 4
fi

unit=$(echo $base_row | cut -d',' -f1)
measure=$(echo $base_row | cut -d',' -f3)

echo $num $u_sym \($measure, $unit\)
