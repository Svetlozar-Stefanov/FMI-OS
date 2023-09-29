#!/bin/bash

if (( $# != 2 )); then
	echo "ERROR: invalid number of arguments"
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo "ERROR: invalid first parameter"
	exit 2
fi

if [[ ! -d $2 ]]; then
	echo "ERROR: ivalid second parameter"
	exit 3
fi

while read file; do
	echo $file
	while read bw; do
		star=$(echo $bw | sed 's/./*/g')
		sed -i "s/\b$bw\b/$star/Ig" $file
	done <<< $(cat $1)
done <<< $( find $2 -type f -name '*.txt')
