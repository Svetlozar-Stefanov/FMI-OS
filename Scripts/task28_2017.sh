#!/bin/bash

if (( $# != 2 )); then
	echo Invalid number of parameters
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo First parameter not a file
	exit 2
fi

reg="vmlinuz\-[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\-$2$"

out=''
x=0
y=0
z=0

for file in $(find $1 -maxdepth 1 -type f | egrep  $reg); do
	ver=$(echo $file | cut -d'-' -f2)
	tx=$(echo $ver | cut -d'.' -f1)
	ty=$(echo $ver | cut -d'.' -f2)
	tz=$(echo $ver | cut -d'.' -f3)

	if (( $x <= $tx )) && (( $y <= $ty )) && (( $z < $tz)); then
		x=$tx
		y=$ty
		z=$tz
		out=$file
	fi
done

echo $out
