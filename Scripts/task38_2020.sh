#!/bin/bash

package=$2
repo=$1

package_name=$(echo $package | sed 's/.*\///g')
package_version=$(cat $package/version)

tar --xz -cf $repo/packages/temp.tar.xz $package/tree
checksum=$(sha256sum $repo/packages/temp.tar.xz | cut -d' ' -f1)

if [[ $(cat $repo/db) =~ $package_name-$package_version ]]; then
	toRem=$(grep "$package_name-$package_version" $repo/db)
	ch=$(echo $toRem | cut -d' ' -f2)
	sed -i "/$toRem/d" $repo/db 
	find $repo/packages -name "$ch.tar.xz" | xargs -I{} rm {}
fi

mv $repo/packages/temp.tar.xz $repo/packages/$checksum.tar.xz
name="$package_name-$package_version $checksum"
echo $name >> $repo/db
sort -o $repo/db $repo/db
