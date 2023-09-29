#!/bin/bash

if (( $# != 1 )); then
	echo "ERROR: Invalid number of arguments"
	exit 1
fi

if [[ ! $1 =~ [[:alnum:]]{1,4} ]]; then
	echo "ERORR: Invalid device name"i
	exit 2
fi

device=$1

to_dis=0
to_dis=$(awk -v dev=$device -v td=0 'dev==$1 && $3=="*enabled" {td=1} END { print td }' /proc/acpi/wakeup)

if (( $to_dis == 1 )); then
	$1 > /proc/acpi/wakeup
fi
