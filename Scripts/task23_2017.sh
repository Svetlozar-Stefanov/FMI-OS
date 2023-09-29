#!/bin/bash

fn=''
ct=0

for home_dir in $(cat /etc/passwd | cut -d':' -f6); do
	rcnt=$(find $home_dir -type f -printf '%f:%C@\n' 2> /dev/null | sort -nr -t':' -k2 | head -n1)
	if [[ $rcnt == '' ]]; then
		continue
	fi

	t=$(echo $rcnt | cut -d ':' -f2 | cut -d '.' -f1 )
	echo $ct cmp $t
	if (( ct < t )); then
		ct=$t
		fn=$(echo $rcnt | cut -d':' -f1)
		echo CHANGED
	fi
done

echo $fn was most recently changed at $ct
