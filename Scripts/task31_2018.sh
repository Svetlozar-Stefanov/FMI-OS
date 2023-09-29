#!/bin/bash

if (( $# != 2 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -e $1 ]]; then
	echo First parameter not a file
	exit 2
fi

if [[ ! -d $2 ]]; then
	echo Second parameter not a directory
	exit 3
fi

rm -r $2/*

if [[ $(ls -A $2) ]]; then
	echo Directory not empty
	exit 4
fi

while read -r number name; do
	echo $name\;$number >> $2/dict.txt

	grep --color "$name" $1 | cut -d: -f2 >> $2/$number.txt

done <<<$(cut -d':' -f1 $1 | cut -d'(' -f1 | sed 's/[ ]*$//g' | sort | uniq | cat -n )
