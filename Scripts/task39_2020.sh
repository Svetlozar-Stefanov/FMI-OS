#!/bin/bash

if (( $# != 2 )); then
	echo 'Invalid number of parameters'
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo 'First paremeter not a directory'
	exit 2
fi

SRC=$1
DST=$2

if [[ -e $DST ]]; then
	rm -r "$DST"
fi
mkdir -p "$DST/images"

while read file; do
	filename=$(echo $file | cut -d'.' -f1 | egrep -o '[^/]+$')

	name=$(echo $filename | egrep '[^/]+$' |  tr -s ' ' |
		sed 's/^[[:space:]]+//g' |
		sed 's/[[:space:]]+$//g' | 
		sed 's/([^)]*)//g')

	album=$(echo $filename | egrep --color -o '\([^)]*\)' | tail  -n1 | tr -d '(' | tr -d ')')
	if [[ "$album" == '' ]]; then
		album='misc'
	fi
	
	date=$(stat "$file" -c '%y' | cut -d' ' -f1)
	
	hs=$(sha256sum "$file" | cut -d' ' -f1)
	
	images="$DST/images/$hs.jpg"
	touch $images

	datealbum="$DST/by-date/$date/by-album/$album/by-title"	
	mkdir -p "$datealbum"
	ln -s "$images" "$datealbum/$name.jpg"

	datetitle="$DST/by-date/$date/by-title"
	mkdir -p "$datetitle"
	ln -s "$images" "$datetitle/$name.jpg"

	albumdate="$DST/by-album/$album/by-date/$date/by-title/"
	mkdir -p "$albumdate"
	ln -s "$images" "$albumdate/$name.jpg"

	byalbum="$DST/by-album/$album/by-title"
	mkdir -p "$byalbum"
	ln -s "$images" "$byalbum/$name.jpg"

    bytitle="$DST/by-title"
	mkdir -p "$bytitle"
	ln -s "$images" "$bytitle/$name.jpg"

done <<< $(find $SRC -type f -name '*.jpg')
