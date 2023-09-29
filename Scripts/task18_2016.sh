#!/bin/bash

number_reg='^[0-9]+$'

if (( $# != 2 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! $1 =~ $number_reg || ! $2 =~ $number_reg ]]; then
	echo Parameter is not of correct type
	exit 2
fi

mkdir -p  a b c

for file in $(find $(pwd) -type f -name '[!.]*'); do
	lines=$(wc -l $file | cut -d' ' -f1)
	
	if (( $lines < $1 )); then
		mv $file a
	elif (( $lines < $2 )); then
		mv $file b
	else
		mv $file c
	fi
done
