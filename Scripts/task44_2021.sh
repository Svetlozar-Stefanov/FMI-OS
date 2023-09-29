#!/bin/bash

if [[ $# != 2 ]]; then
	echo Invalid number of parameters
fi

if [[ ! -e $1 ]]; then
	echo Bin file does not exist
fi

size=$(($(stat -c '%s' $1) / 16))
echo "uint32_t arrN = $size" > $2
printf 'uint16_t arr[] = { ' >> $2
for (( i=1; i<=size; i++ )); do
	printf '%d' $((2#$(head $1 -c$(( 16 * i)) | tail -c16 | rev)))
	if (( $i != $size )); then
		printf ', '
	else
		printf ' };\n'
	fi
done >> $2
