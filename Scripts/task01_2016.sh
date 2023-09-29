#!/bin/bash

file_name=$1

n_lines=$(grep '^.*[02468]\+.*$' $file_name | grep -vc '^.*[a-w]\+.*$')

printf "Number of matching lines: %d\n" $n_lines
