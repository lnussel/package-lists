#!/bin/sh

echo "kde_cd:"
./gen.sh kde_cd
echo "kde default:"
./gen.sh kde_cd-default
echo "kde_cd_non_oss:"
./gen.sh kde_cd_non_oss
echo "gnome_cd:"
./gen.sh gnome_cd
echo "gnome default:"
./gen.sh gnome_cd-default
echo "gnome_cd_non-oss:"
./gen.sh gnome_cd_non_oss

echo "diffing"
for arch in i586 x86_64; do
   diff -u kde_cd.$arch.list kde_cd-default.$arch.list | fgrep -v +++ | grep ^+
   diff -u gnome_cd.$arch.list gnome_cd-default.$arch.list | fgrep -v +++ | grep ^+ 
done

echo "non-oss:"
./non_oss.sh

echo "dvd5:"
./gen.sh dvd5
./gen.sh dvd5-2

#echo "promo-dvd5:"
#./gen.sh dvd5-promo

echo "language addon:"
./gen.sh dvd5-addon_lang

./join.sh
./langaddon.sh
