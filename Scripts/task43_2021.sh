#!/bin/bash

date=$(date +'%Y%m%d00')

for file in "$*"; do
	i=1
	while read line; do
		mod=$(echo $line | tr -s ' ' | sed 's/^[[:space:]]*//g' | sed 's/[[:space:]]*$//g')
		if (( $i == 1 )); then
			serial=$(echo $mod | cut -d' ' -f7)
			if [[ $serial != '(' ]]; then
				if (( $date > $serial )); then
					serial=$date
				else
					serial=$((serial + 1))
				fi
				echo $(echo $mod | cut -d' ' -f1-6) $serial $(echo $mod | cut -d' ' -f8-11)
				break
			else
				echo $line
			fi
		else if [[ $i == 2 ]]; then
			serial=$(echo $mod | tr -d ' ' | cut -d ';' -f1)
			if (( $date > $serial )); then
				serial=$date
			else
				serial=$((serial + 1))
			fi
			echo $serial \; serial
		else
			echo $line
		fi
		fi
		i=$(( i + 1 ))
	done <<< $(cat $file) > $file
done
