#!/bin/sh

cachedir="./_cache"
mkdir -p "$cachedir" || exit 1
now="./$(date +%Y%m%dT%M%H%S%z)"
mkdir -p "$now" || exit 1

if [ $# -ne 5 ]; then
	echo "実行するには5個の引数が必要です" 1>&2
	exit 1
fi

zoomlevel=$1
topleft_x=$2
topleft_y=$3
bottomright_x=$4
bottomright_y=$5

for y in $(seq $topleft_y $bottomright_y); do
	for x in $(seq $topleft_x $bottomright_x); do
		echo "$cachedir/${zoomlevel}-${x}-${y}.jpg" >> "$now/tiles.txt"
		if [ ! -f "$cachedir/${zoomlevel}-${x}-${y}.jpg" ]; then
			wget "https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/${zoomlevel}/${x}/${y}.jpg" -O "$cachedir/${zoomlevel}-${x}-${y}.jpg"
		fi
	done
done

rows=$(expr $bottomright_y - $topleft_y + 1)
cols=$(expr $bottomright_x - $topleft_x + 1)

montage -tile ${cols}x${rows} -geometry 256x256 $(cat "$now/tiles.txt") "$now/combined.jpg"
