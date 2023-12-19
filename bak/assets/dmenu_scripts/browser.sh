#! /usr/bin/bash

query=$(cat /home/niki/.config/dmenu/defaults | dmenu -fn "JetBrains Mono:size=15" -p "Query:" )

if [ $query -z ]; then
	exit
fi

grep -Fx "$query" /home/niki/.config/dmenu/defaults
if [ $? == 1 ]; then
	echo "$query" >> /home/niki/.config/dmenu/defaults
fi

firefox "https://www.google.com/search?q=$query"
