#!/bin/bash

if (( $# != 3 )); then
	echo 'Invalid number of parameters'
	exit 1
fi


if [[ ! -f $1 ]]; then
	echo 'First parameter not a file'
	exit 2
fi

if [[ ! -d $3 ]]; then
	echo 'Third Parameter not a directory'
	exit 3
fi

if [[ -e $2 ]]; then
	rm $2
fi

commreg='^#.*$'
lreg='^\{.*\}\;$'

while read file; do
	valid=1
	i=1
	while read line; do
		if [[ ! $line =~ $commreg ]] && 
			[[ ! $line =~ $lreg ]] && 
			[[ ! $line =~ ^[[:space:]]*$ ]]; then

		if (( $valid == 1 )); then
				echo Error in $file:
			fi
			valid=0
			echo Line $i: $line
		fi
		i=$((i+1))
	done <<< $(cat $file)
	
	if (( $valid == 1 )); then
		name=$(echo $file | egrep -o  '[^/]+.cfg$' | cut -d'.' -f1)
		cat $file >> $2

		passreg=$name:.+ 
		if [[ ! $(cat $1) =~ $passreg ]]; then
			pass=$(pwgen 16 1)
			echo "$name:$pass" >> $1
		fi
	fi
done <<< $(find $3 -type f -name *.cfg)
