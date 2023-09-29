#!/bin/bash

if (( $# < 1 || $# > 2 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo First parameter not a valid directory
	exit 2
fi

function link_info(){
c=0
for link in $( find $1 -type l ); do
	file=$(readlink $link)
	if [[ ! -e $file ]]; then
		c=$(( c + 1 ))
	else
		echo "$link -> $file"
	fi
done

echo Broken symlinks: $c
}

if (( $# == 2 )); then
	link_info $1 > $2
else
	link_info $1
fi
