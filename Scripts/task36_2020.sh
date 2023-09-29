#!/bin/bash

echo 'hostname,phy,vlans,hosts,failover,VPN-3DES-AES,peers,VLAN Trunk Ports,license,SN,key' > $1

while read file; do
	printf '%s,' $(echo $file | sed 's/.*\///g' | sed 's/.log//g')

	while read line; do
		if [[ $line =~ 'Licensed features for this platform:' ]]; then
			continue
		fi

		if [[ $line =~ 'This platform has a' ]]; then
			printf '%s,' $(echo $line | sed 's/This platform has a //g' | sed 's/ license.//g')
			continue
		fi

		printf '%s,' $(echo $line | cut -d':' -f2 | sed 's/ //g')
	done <<< $(cat $file)
	printf '\n'
done <<< $(find $2 -name "*.log") | sed 's/,$//g' >> $1
