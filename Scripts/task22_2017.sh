#!/bin/bash

if [[ $USER != 'root' ]]; then
	echo You need root permissions to run this script
	exit 1
fi

if (( $# != 1 )); then
	echo Invalid number of parameters
	exit 2
fi

user=$1

if (($(cut -d: -f1 /etc/passwd | grep -c $user) < 1)); then
	echo Not a valid user
fi

u_processes=$(ps -u $user  -o user | tail -n+2 | wc -l | cut -d ' ' -f1)

echo Uers with more processes than $user:
ps -eo user | tail -n+2 | sort | uniq -c | awk -v up=$u_processes '$1 > up { print $2; }'

echo Average process runtime:
time=$(ps -eo user,etimes | awk -v u=$user -v n=0 -v p=0 '$1 != u { n += 1; p += $2 } END { printf "%d", p/n;}')
printf '%(%H:%M:%S)T\n' $time

two_time=$(( 2 * $time ))

IFS=$'\n'
for process in $(ps -u $user -o pid,etimes | tr -s ' ' | sed 's/^[ ]*//g' | tail -n+2); do
	pid=$(echo $process | cut -d' ' -f1)
	ct=$(echo $process | cut -d' ' -f2)

	echo $process

	if (( ct < time )); then	
		kill -15 $pid
	fi
done
