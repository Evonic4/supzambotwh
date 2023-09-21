#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

home_trbot=/usr/share/zntwh_bot/
fhome=$home_trbot

line=$1
meaning=$2
meaning3=$3
meaning4=$4

meaning5=$5
meaning6=$6
meaning7=$7

meaning8=$8
meaning9=$9

! [ -z "$meaning3" ] && meaning=$meaning" "$meaning3
! [ -z "$meaning4" ] && meaning=$meaning" "$meaning4

! [ -z "$meaning5" ] && meaning=$meaning" "$meaning5
! [ -z "$meaning6" ] && meaning=$meaning" "$meaning6
! [ -z "$meaning7" ] && meaning=$meaning" "$meaning7

! [ -z "$meaning8" ] && meaning=$meaning" "$meaning8
! [ -z "$meaning9" ] && meaning=$meaning" "$meaning9

echo "line="$line", meaning="$meaning > $fhome"to-config-log.txt"

str_col=$(grep -cv "^TTTTT" $fhome"sett.conf")
echo "str_col="$str_col >> $fhome"to-config-log.txt"
rm -f $fhome"settings1.conf" && touch $fhome"settings1.conf"

for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $fhome"sett.conf")
if [ "$i" -eq "$line" ]; then
	echo "i=line="$i >> $fhome"to-config-log.txt"
	echo $meaning >> $fhome"settings1.conf"
else
	echo $test >> $fhome"settings1.conf"
fi
done

cp -f $fhome"settings1.conf" $fhome"sett.conf"

