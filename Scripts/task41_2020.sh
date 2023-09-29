#!/bin/bash

if (( $# != 3 )); then
	echo Invalid number of parameters
	exit 1
fi

file=$1
key=$2
val=$3

output=''
contained=0

while read line; do
	mod=$(echo $line | sed 's/[#].*$//g' | tr -d ' ')

	if [[ $mod == '' ]]; then
		echo $line
		continue 
	fi

	k=$(echo $mod | cut -d= -f1)
	v=$(echo $mod | cut -d= -f2)

	if [[ $key == $k && $val != $v ]]; then
		echo \# $line \# edited at $(date) by $USER
		echo $key = $val \# added at $(date) by $USER
		contained=1
	else
		echo $line
	fi
done <<< $(cat $file) > $file

if (( $contained == 0 )); then
	echo $key = $val \# added at $(date) by $USER >> $file
fi
