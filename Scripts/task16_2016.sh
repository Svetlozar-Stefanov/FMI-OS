#!/bin/bash

if (( $# != 1)); then
	echo 'Invalid number of parameters'
	exit 1
fi

echo $1

rgx='^[0-9]+$'

if [[ ! $1 =~ $rgx ]]; then
	echo 'Parameter is not a valid number'
	exit 2
fi

if [[ ! $USER != 'root' ]]; then
	IFS=$'\n'
	for process in $( ps -aux | tr -s ' ' | tail -n+2); do
		rss=$(echo ${process} | cut -d' ' -f6)
		pid=$(echo ${process} | cut -d' ' -f2)
		if (( $rss < $1 )); then
			echo $process - live
		else
			echo $process - DIE
			kill -TERM $pid
		fi
	done
fi	 
