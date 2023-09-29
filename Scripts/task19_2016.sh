#!/bin/bash

larger_file(){
	lines1=$(grep -c $1 $1)
	lines2=$(grep -c $2 $2)

	if (( $lines1 >= $lines2 )); then
		echo $1
	else
		echo $2
	fi
}

if (( $# != 2 )); then
	echo Invalid number of parameters!
	exit 1
fi

first_filename=$1
second_filename=$2

if [[ ! -f $first_filename || ! -f $second_filename ]]; then
	echo 'Invalid filename'
	exit 2
fi

file=$(larger_file $first_filename $second_filename)

cut -d' ' -f4- $file | sort



