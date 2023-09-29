#!/bin/bash

if (( $# != 3 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo Invalid file name
	exit 2
fi

filename=$1
key1=$2
key2=$3

IFS=$'\n'
rep=''

for line in $(cat $filename); do
	key=$(echo $line | cut -d= -f1)
	val=$(echo $line | cut -d= -f2)

	if [[ $key1 == $key ]]; then
		rep=$(echo $val | tr -d ' ')
		echo $key=$val
	elif [[ $key2 == $key ]]; then
		val=$(echo $val | tr -d $rep | sed 's/^[ ]*//g')
		echo $key=$val
	else
		echo $key=$val
	fi
done
