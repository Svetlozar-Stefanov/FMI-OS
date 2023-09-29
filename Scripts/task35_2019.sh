#!/bin/bash

last_opened=$(stat -c '%X' $0)

while read -r file; do
	mod=$(stat -c '%Y' $file)
	birth=$(stat -c '%W' $file)

	mkdir -p ./extracted
	if (( $birth > $last_opened )) || (( $mod > $last_opened )); then
		name=$(echo $file | cut -d'_' -f1)
		time=$(echo $file | cut -d'-' -f2 | cut -d'.' -f1)
		tar -tf $file | egrep '*/meow.txt$' | xargs -I{} cp {} "extracted/$name_$time"
	fi
done <<< find $1 -type f -name *_report-*.tgz
