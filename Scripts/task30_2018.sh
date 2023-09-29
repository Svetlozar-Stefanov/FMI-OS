#!/bin/bash

if (( $# != 1 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -d $1 ]]; then 
	echo First parameter is not a directory
	exit 2
fi

chats=$(find $1 -mindepth 3 -maxdepth 4 -type f)

while read -r dir; do
	friend=$(echo $dir | cut -d'/' -f4)
	echo $friend $(wc -l $(printf "%s\n" $chats | grep $friend) | tail -n1)
done <<< $chats | sort -nr -t' ' -k2 | uniq
