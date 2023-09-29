#!/bin/bash

if (( $# != 1 )); then
	echo "ERROR: invalid number of parameters"
	exit 6
fi

if [[ ! $1 =~ ^[[:digit:]]$ ]] || (( $1 < 1 )); then
	echo "ERROR: iarameter not a number"
	exit 7
fi

if [[ $USER != 'oracle' && $USER != 'grid' ]]; then
	echo "ERROR: unauthorized user"
	exit 1
fi

if [[ -z $ORACLE_BASE ]]; then
	echo "ERROR: ORACLE_BASE not set"
	exit 2
fi

if [[ -z $ORACLE_HOME ]]; then
	echo "ERROR: ORACLE_HOME not set"
	exit 3
fi

if [[ ! -e $ORACLE_HOME/bin/sqlplus ]]; then
	echo "ERROR: sqlplus not found"
	exit 4
fi

if [[ -z $ORACLE_SID ]]; then
	echo "ERROR: ORACLE_SID not set"
	exit 5
fi

s_sqlplus="$ORACLE_HOME/bin/sqlplus"
role="SYSDBA"
if [[ $USER == "grid" ]]; then
	role="SYSASM"
fi

diagnostic_dest=$($s_sqlplus -SL "/ as $role" @a.sql | head -n4 | tail -n1)
if [[ $diagnostic_dest == "" ]]; then
	diagnostic_dest=$ORACLE_BASE
fi

if [[ -z "$diagnostic_dest/diag" ]]; then
	echo "ERROR: could not find diag"
	exit 8
fi

diag="$diagnostic_dest/diag"

if [[ $USER == 'grid' ]]; then
	echo crs: $(find "$diag/crs/$(hostname -s)/crs/trace/" -type f -not -mtime $1 \( -name *_[0-9]+.trc -o -name *_[0-9]+.trm \) | wc -c) 
	echo tnslsnr: $(find "$diag/tnslsnr/$(hostname -s)" -type d -not -mtime $1 \( -name */alter/*_[0-9]+.xml -o -name */trace/*_[0-9]/*_[0-9]+.log \) | wc -c)
else
	echo rdms: $(find "$diag/rdbms" -mindepth 2 -maxdepth 2 -not -mtime $1  \( -name *_[0-9]+.trc -o -name *_[0-9].trm \))
fi
