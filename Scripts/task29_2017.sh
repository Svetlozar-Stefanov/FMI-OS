#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo You need root permissions to run this script
	exit 1
fi

r_mem=$(ps -u root -o rss | awk -v m=0 '{ m += $0; } END { print m }')

while IFS=: read -r user dir; do
	
	if [[ $user == 'root' ]]; then
		continue
	fi

	if [[ -e $dir ]] && [[ $(stat -c '%U' $dir) == $user ]]; then
		continue
	fi

	if [[ -e $dir ]] && [[ $(stat -c '%a' $dir) =~ '^[2367][0-9]*' ]]; then
		continue
	fi

	mem=$(ps -u $user -o rss | awk -v m=0 '{ m += $0; } END { print m }')

	echo root: $r_mem usr: $mem

	if (( $r_mem < $mem )); then
		ps h -u $user -o pid | xargs -I{} kill -TERM {} 
	fi

done <<< $(cat /etc/passwd | cut -d: -f1,6)
