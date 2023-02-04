#!/usr/bin/bash

# https://www1.thepiratebay3.to/torrent/54184594/Arcane_S01_1080p_WEBRip_x265
if [[ -z "$1" ]]; then 
	read -rp "Please provide the search term: " query
else
	query=$*
fi

query="${query// /%20}"

info_hash=$(curl -s "https://piratebayorg.net/api.php?url=/q.php?q=${query}&cat=200" |
	jq -r '.[] | .info_hash + ", " + .size + ", [S:" + (.seeders|tostring) + " L:" + .leechers + "], " + .name' |
	numfmt -d ',' --field 2 --to=iec |
	fzf -d ',' --with-nth 2.. |
	cut -d ',' -f 1)

[[ -z $info_hash ]] && { echo 'None selected. Aborting!'; exit 1; }

magnet="magnet:?xt=urn:btih:${info_hash}"

read -rp "Do you want to download the file (y/N)? " ans

echo "$magnet" | xclip -sel c

if [[ $ans == 'y' ]]; then
	echo "Downloading file"
	aria2c --seed-ratio=1.0 -d "$HOME/Videos" "$magnet"
else
	echo "Magnet link copied to clipboard"
fi

