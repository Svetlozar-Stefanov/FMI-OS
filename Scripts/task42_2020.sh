#!/bin/bash

if [[ $USER != 'oracle' && $USER != 'grid' ]]; then
	echo Cannot run this script with current user
fi

while read line; do
	path=/u01/app/$USER/$line
	echo $(stat -c '%s' $path) $path
done <<< $($ORACLE_HOME/bin/adrci -exec="show homes" | tail -n+2)
