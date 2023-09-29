#!/bin/bash

function get_input {
while read -r line; do
	if [[ $line =~ ^[0-9]+$ || $line =~ ^-[0-9]+$ ]]; then
		echo $line
	fi
done
}

input=$($(get_input) | sort | uniq)

biggest=0
while read -r n; do
	if (( $n < 0 )); then
		n=$((-1*$n))
	fi
	if (( $biggest < $n )); then
		biggest=$n
	fi
done <<< $input

while read -r n; do
	if [[ $n =~ $biggest ]]; then
		echo $n
	fi
done <<< $input
