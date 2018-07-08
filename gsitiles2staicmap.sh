#!/bin/sh

if [ ! $# -gt 4 ]; then
	echo "実行するには最低5個の引数が必要です" 1>&2
	echo "Usage:" 1>&2
	echo "$0 ZoomLevel TopLeftX TopLeftY BottomRightX BottomRightY [Tile Type]" 1>&2
	exit 1
fi

urls='
seamlessphoto	https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/${zoomlevel}/${x}/${y}.jpg
std	https://cyberjapandata.gsi.go.jp/xyz/std/${zoomlevel}/${x}/${y}.png
'

tiletype=$6
[ -z "$tiletype" ] && tiletype=seamlessphoto || :

res=$(echo "$urls" | grep -v '^$' | grep "^$tiletype\s")
if [ -z "$res" ]; then
	echo "該当するものがありません: $tiletype" 1>&2
	exit 1
fi
url=$(echo "$res" | awk '{print $2}')
src_ext=".${url##*.}"  # 拡張子

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
			u=$(eval echo "$url")
			wget "$u" -O "$out"
		fi
	done
done

rows=$(expr $bottomright_y - $topleft_y + 1)
cols=$(expr $bottomright_x - $topleft_x + 1)

montage -tile ${cols}x${rows} -geometry 256x256 $(cat "$now/tiles.txt") "$now/combined.jpg"
