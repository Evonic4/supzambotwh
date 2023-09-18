#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

fhome=/usr/share/zntwh_bot/
bui=$(sed -n 11"p" $fhome"settings.conf" | tr -d '\r')
log=$fhome"rex_log.txt"
f_text=$1
echo > $log

function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" rex_"$bui": "$1 >> $log
}


logger "start "$f_text

dl=$(wc -m $f_text | awk '{ print $1 }')
logger "dl="$dl

if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	logger "sv="$sv
	i1=0
	
	for (( i=1;i<=$sv;i++)); do
		logger "--------i="$i"------"
		[ "$i" -gt "$sv" ] && logger "i="$i" > sv="$sv" break" && break
		str_col=$(grep -cv "^----------" $f_text)
		logger "str_col="$str_col
		
		again2="yes"
		i1=0
		odl=0
		while [ "$again2" = "yes" ]
			do
			logger "odl="$odl
			i1=$((i1+1))
			logger "i1="$i1
			test=$(sed -n $i1"p" $f_text | tr -d '\r')
			len1=${#test}
			len1=$((len1+1))
			logger "len1="$len1
			od2=$((odl+len1))
			logger "od2="$od2
			if [ "$od2" -gt "4000" ]; then
				logger "start rez"
				i1=$((i1-1))
				logger "new i1="$i1
				head -n $i1 $f_text > $fhome"rez"$i".txt"
				tcol=$((str_col-i1))
				logger "tcol="$tcol
				tail -n $tcol $f_text > $fhome"rez_tmp.txt"
				logger "rez-------------------->rez"$i".txt"
				cp -f $fhome"rez_tmp.txt" $f_text
				
				#read var1
				again2="no"
			else
				logger "not rez"
				odl=$od2
			fi
			if [ "$i1" -gt "$str_col" ]; then
				logger "end rez i1="$i1
				cp -f $f_text $fhome"rez"$i".txt"
				again2="no"
				break
			fi
		done
	done
	rm -f $fhome"rez_tmp.txt"
else
	cp -f $f_text $fhome"rez1.txt"
fi

