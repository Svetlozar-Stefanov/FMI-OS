#!/bin/bash

if (( $# != 2 )); then
	echo "ERROR: invalid number of arguments"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "ERROR: dir1 does not exist"
	exit 2
fi

if [[ ! -d $2 ]]; then
	mkdir "./$2"
fi

if [[ $(ls -A $2) != "" ]]; then
	echo "ERROR: dir2 is not empty"
	exit 3
fi

find $1 -mindepth 1 -type d | sed "s/$1/$2/g" | xargs -I{} mkdir -p {}
while read file; do
	cp $file $(echo $file | sed "s/$1/$2/g")
done <<< $(find $1 -mindepth 1 -type f -not -name '.*.swp')
