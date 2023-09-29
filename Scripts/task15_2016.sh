#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo 'Invalid number of parameters'
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo 'Not a directory'
		exit 2
fi

for link in $(find ${1} -type l 2>/dev/null); do
	if [[ !  -e $(readlink ${link}) ]]; then
		echo ${link}
	fi
done
