#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo You need root permissions to run this script
	exit 1
fi

if (( $# != 3 )); then
	echo Invalid number of parameters
	exit 2
fi

if [[ ! -d $1 ]] || [[ ! -d $2 ]]; then
	echo One or more parameters are not a directory
	exit 3
fi

if [[ $(find $2 -maxdepth 0 -not -empty) != '' ]] ; then
	echo DST not empty
	exit 4
fi

SRC=$1
DST=$2
ABC=$3

 find $SRC -type f -name "*$ABC*" -exec mv {} $DST \; 2> /dev/null
