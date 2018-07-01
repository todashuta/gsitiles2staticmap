#!/bin/sh

if [ $# -ne 5 ]; then
	echo "実行するには5個の引数が必要です" 1>&2
	exit 1
fi

tiletype="seamlessphoto"
src_ext=".jpg"
#tiletype="std"
#src_ext=".png"

urlfmt="https://cyberjapandata.gsi.go.jp/xyz/${tiletype}/%s/%s/%s${src_ext}"

cachedir="./_cache/$tiletype"
mkdir -p "$cachedir" || exit 1
now="./$(date +%Y%m%dT%H%M%S%z)"
mkdir -p "$now" || exit 1

zoomlevel=$1
topleft_x=$2
topleft_y=$3
bottomright_x=$4
bottomright_y=$5

for y in $(seq $topleft_y $bottomright_y); do
	for x in $(seq $topleft_x $bottomright_x); do
		out="${cachedir}/${zoomlevel}-${x}-${y}${src_ext}"
		echo "$out" >> "$now/tiles.txt"

		if [ ! -f "$out" ]; then
			url=$(printf "$urlfmt" "$zoomlevel" "$x" "$y")
			wget "$url" -O "$out"
		fi
	done
done

rows=$(expr $bottomright_y - $topleft_y + 1)
cols=$(expr $bottomright_x - $topleft_x + 1)

montage -tile ${cols}x${rows} -geometry 256x256 $(cat "$now/tiles.txt") "$now/combined.jpg"
