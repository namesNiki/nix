#! /bin/bash

font=

bookmarks=$( cat /etc/nixos/assets/bookmarks | dmenu -fn "JetBrains Mono:size=15" -p Bookmarks)

if [ $bookmarks == Add ]; then
	new_bookmark=$(echo "Exit" | dmenu -fn "JetBrains Mono:size=15" -p "Type in the new name" )	

	if [ $new_bookmark == Exit ]; then
		exit
	fi

	echo $new_bookmark >> /etc/nixos/assets/bookmarks
	exit
fi

if [ $bookmarks -z ]; then
	exit
fi

firefox $bookmarks
