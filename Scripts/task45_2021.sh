#!/bin/bash

if [[ $USER != "oracle" && $USER != "grid" ]]; then 
	echo "ERROR: cannot be run unless user is oracle or grid"
	exit 42
fi

if (( $# != 1 )); then
	echo "ERROR: invalid number of arguments"
	exit 43
fi

if [[ ! $1 =~ '^[[:digit:]]+$' ]] || (( $1 < 2 )); then
	echo "ERROR: invalid argument"
	exit 44
fi

if [[ ! -z "$ORACLE_HOME" ]]; then
	echo "ERROR: ORACLE_HOME not set"
	exit 1
fi

if [[ ! -e "$ORACLE_HOME/bin/adrci" ]]; then
	echo "ERROR: adrci command does not exist"
fi

diag_dest="u01/app/$USER"

while read dir; do
	$ORACLE_HOME/adrci exec "SET HOME $diag_dest; SET HOMEPATH $dir; PURGE -AGE $(($1 * 60))"  
done <<< $($ORACLE_HOME/bin/adrci exec="SET BASE $diag_dest; SHOW HOME" | tail -n+2 |
egrep '^.*/(crs|tnslsnr|kfod|asm)/.*/.*$'

