#!/bin/bash

if [[ $USER == 'root' ]]; then
	echo You need root permissions to run this script
	exit 1
fi

for user in $(cut -d':' -f1 /etc/passwd); do
	biggest=$(ps h -u $user -o pid,user,rss | sort -nr -t' ' -k3 | tr -s ' ' | sed 's/^[ ]+//g' | head -n1)
	if [[ $biggest == '' ]]; then
		continue
	fi

	echo Processes for $user:
	pid=$(echo $biggest | cut -d' ' -f1)
	size=$(echo $biggest | cut -d' ' -f3)

	IFS=$'\n'
	mem=0
	i=0
	for process in $(ps h -u $user -o pid,user,rss | tr -s ' ' | sed 's/^[ ]*//g' ); do
		ppid=$(echo $process | cut -d' ' -f1)
		pmem=$(echo $process | cut -d' ' -f3)

		mem=$(( mem + pmem ))
		i=$(( i + 1 ))
		
		echo $process
	done
	
	echo $mem / $i

	mem=$((mem/i))
	if (( $size > $((mem * 2)) )); then
		echo KILL: $biggest
		kill -TERM $pid
	fi
done
