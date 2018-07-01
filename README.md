gsitiles2staicmap
=================

特定のズームレベルの地理院タイル(衛星写真)を取得して結合した画像を生成します

Usage
-----

    $ sh gsitiles2staicmap.sh {ズームレベル} {左上タイルX} {左上タイルY} {右下タイルX} {右下タイルY}
    $ sh gsitiles2staicmap.sh {Zoom Level} {Topleft X} {Topleft Y} {Bottomright X} {Bottomright Y}

Example
-------

    # Osaka Station
    $ sh gsitiles2staicmap.sh 18 229732 104096 229740 104101

Requirements
------------

- wget command
- montage command (ImageMagick)

License
-------

MIT
