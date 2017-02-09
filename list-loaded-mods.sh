#!/usr/bin/bash
# print list of loaded kernel modules as pacman whitelist

kver=$(uname -r)

while read line
do
	arr=($line)
	file=$(modinfo -n ${arr[0]})
	path=${file/$kver/*}
	echo "NoExtract = !usr${path}"
done </proc/modules
