#!/bin/bash

if (( $# != 1 )) && (( $# != 2 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo First parameter not directory
	exit 2
fi

if (( $# == 2 )) && [[ ! $2 =~ ^[0-9]+$ ]]; then
	echo Second parameter not a number
	exit 3
fi

if (( $# == 2 )); then
	find $1 -type d \( -links +$2 -o -links $2 \) -printf '%f %n\n'
else
	for link in $(find $1 -type l); do
		if [[ ! -e $(readlink $link) ]]; then
			echo $link
		fi
	done
fi
