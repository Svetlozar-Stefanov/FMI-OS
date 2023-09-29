#!/bin/bash

function get_input {
while read -r line; do
	if [[ $line =~ ^[0-9]+$ || $line =~ ^-[0-9]+$ ]]; then
		echo $line
	fi
done
}

function digit_sum {
	sum=0
	n=$1
	if (( n < 0 )); then
		n=$((-1*$n))
	fi
	while (( n > 0 )); do
		mod=$((n % 10))
		sum=$((sum + mod))
		n=$(( n / 10 ))
	done
	echo $sum
}

input=$(get_input | sort | uniq)

while read -r n; do
	echo $(digit_sum $n) $n
done <<< $input | sort -nr -t' ' -k1 | sort -n -t' ' -k2 | head -n1 | cut -d' ' -f2 
