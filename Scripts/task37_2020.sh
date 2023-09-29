#!/bin/bash

while read site; do
	hc=0
	hnc=0
	while read line; do
		if [[ $(echo $line | cut -d' ' -f8) == 'HTTP/2.0' ]]; then
			hc=$((hc + 1))
		else
			hnc=$((hnc + 1))
		fi
	done <<< $(egrep "^.*[ ]$site[ ][-][ ]\[.*\].*$" $1)
	printf "%s HTTP/2.0: %d non-HTTP/2.0: %d\n" $site $hc $hnc
done <<< $(cut -d' ' -f2 $1 | sort | uniq -c | sort -nr | head -n3 | tr -s ' ' | cut -d' ' -f3)

awk '$9 > 302 {print $1}' $1 | sort | uniq -c
