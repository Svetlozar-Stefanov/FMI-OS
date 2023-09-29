#!/bin/bash

if (( $# != 1 )); then
	echo "ERROR: invalid number of parameters"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "ERROR: parameter not a valid directory"
	exit 2
fi

duplicates=0
files_in_dir=$(find $1 -type f)
size_before=$(echo $(du -sb $1) | tr -s ' ' | cut -d' ' -f1)
store="$1unique"

while read file1; do
	if [[ ! -e $file1 ]]; then
		continue
	fi
	n1=$(echo $file1 | egrep -o '[^\/]+$')
	cs1=$(sha256sum $file1 | cut -d' ' -f1)
	while read file2; do
		cs2=$(sha256sum $file2 | cut -d' ' -f1)
		if [[ $file1 != $file2 && $cs1 == $cs2 ]]; then
			duplicates=$(( duplicates + 1))
			if [[ ! -d $store ]]; then
				mkdir $store
			fi
			if [[ ! -e "$store/$n1" ]]; then
				cp $file1 "$store/$n1"
			fi
			rm $file2
			ln -s "unique/$n1" $file2
			echo "$file2 -> "$store/$n1""
		fi

		done <<< $(find $1 -type f -not -wholename '*\/unique\/*')
		if [[ -e "$store/$n1" ]]; then
			rm $file1
			ln -s "unique/$n1" $file1
			echo "$file1 -> "$store/$n1""
		fi
done <<< $(find $1 -type f -not -wholename '*\/unique\/*')

size_after=$(echo $(du -sb $1) | tr -s ' ' |  cut -d' ' -f1)

echo Duplicates: $duplicates
echo Before: $size_before After: $size_after
