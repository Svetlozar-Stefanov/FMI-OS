#!/bin/bash

IFS=$'\n'
reg='^[^2367][0-9]{2}.*$'

for user in $(cat /etc/passwd); do
	name=$(echo $user | cut -d: -f1)
	homedir=$(echo $user | cut -d: -f6)
	if [[ ! -e $homedir ]]; then
		echo $user
	elif [[ $(stat -c '%a' $homedir) =~ $reg ]]; then
		echo $user
	fi
done
		



