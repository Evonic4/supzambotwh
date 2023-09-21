#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/zntwh_bot/
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
fPID=$fhome"pid_subass.txt"
nau1=0
sender_list=$fhome"sender_list.txt"



function Init2() 
{
logger "Init2"

opov=$(sed -n "7p" $ftb"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
logging_level=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
bname=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
tmode=$(sed -n 16"p" $ftb"sett.conf" | tr -d '\r')
mdt_start=$(sed -n 17"p" $ftb"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g'| tr -d '\r')
mdt_end=$(sed -n 18"p" $ftb"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g' | tr -d '\r')

user1=$(sed -n 21"p" $fhome"sett.conf" | tr -d '\r')
pass1=$(sed -n 22"p" $fhome"sett.conf" | tr -d '\r')
urlpoint1=$(sed -n 23"p" $fhome"sett.conf" | tr -d '\r')
urlpoint2=$(sed -n 24"p" $fhome"sett.conf" | tr -d '\r')
urlpoint=$urlpoint1$urlpoint2
echo "machine "$urlpoint2" login "$user1 "password "$pass1 > $fhome"cr.txt"
ztich=$(sed -n 26"p" $fhome"sett.conf" | tr -d '\r')

nau=$(sed -n 27"p" $ftb"sett.conf" | tr -d '\r')
}



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" subass_"$bname": "$1
}


ex_night_mode ()  	
{
if [ -f $fhome"ticket_nm_buf.txt" ]; then
	logger "ex_night_mode"
	echo "exit from night mode, affected tickets:" > $fhome"ticket_fr_nm.txt"
	echo $(cat $fhome"ticket_nm_buf.txt") >> $fhome"ticket_fr_nm.txt"
	otv=$fhome"ticket_fr_nm.txt"
	send;
	rm -f $fhome"ticket_nm_buf.txt"
fi
}

night_mode ()  	
{
tmode=$(sed -n 16"p" $ftb"sett.conf" | tr -d '\r')
if [ "$tmode" == "1" ]; then
	mdt1=$(date '+%H%M%S')
	[ "$logging_level" == "1" ] && logger "night_mode mdt1="$mdt1" mdt_start="$mdt_start" mdt_end="$mdt_end
	#mdt_start="000000"
	#mdt_end="090000"
	if [ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]; then
		n_mode=1
	else
		n_mode=0
		ex_night_mode;
	fi
else
	n_mode=0
fi
logger "night_mode check n_mode="$n_mode
}


check_api_zammad ()
{
[ "$logging_level" == "1" ] && logger "check_api_zammad"
local cscapi=0
local apierr="UP"

curl -s -m 5 --netrc-file $fhome"cr.txt" $urlpoint/api/v1/tickets/search?query=number:$ztich | jq '.' > $fhome"check_api1.txt"
cscapi=$(wc -c $fhome"check_api1.txt" | awk '{ print $1 }' | sed 's/^[ \t]*//;s/[ \t]*$//')
[ "$logging_level" == "1" ] && logger "check_api_zammad cscapi="$cscapi

if [ "$cscapi" -gt "0" ]; then
	if [ "$(grep error $fhome"check_api1.txt")" ]; then
		apierr=$(grep "error\":" $fhome"check_api1.txt" | awk -F":" '{print $2}' | sed 's/"//g' | sed 's/,//g' | sed 's/^[ \t]*//;s/[ \t]*$//')
		logger "check_api_zammad ERROR: "$apierr
		echo "ERROR: "$apierr > $fhome"check_api2.txt"
	else
		#UP
		echo $apierr > $fhome"check_api2.txt"
		logger "check_api_zammad status:"$apierr
	fi
else
	echo "DOWN" > $fhome"check_api2.txt"
	logger "check_api_zammad status: DOWN"
fi

}



send ()
{
logger "send start"

dl=$(wc -m $otv | awk '{ print $1 }')
echo "dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	echo "sv="$sv
	$ftb"rex.sh" $otv
	logger "send obrezka"
	for (( i5=1;i5<=$sv;i5++)); do
		otv=$fhome"rez"$i5".txt"
		logger "send obrezka "$fhome"rez"$i5".txt"
		send1;
		logger "send to obrezka "$fhome"rez"$i5".txt"
		rm -f $fhome"rez"$i5".txt"
	done
	
else
	send1;
fi

}

send1 () 
{
logger "send1 start"
mv -f $otv $fhsender2$$number".txt"
echo $fhsender2$$number".txt" > $fhsender1$$number".txt"
}


set_date_nau ()
{
dtna1=$(date -d "$RTIME $nau min" '+ %Y%m%d%H%M%S'| sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
echo $dtna1 > $fhome"nau_date.txt"
logger "autohcheck_nau set dtna1="$dtna1
}

autohcheck_nau ()
{
[ "$logging_level" == "1" ] && logger "autohcheck_nau"
local api_status=""

api_status=$(sed -n 1"p" $fhome"check_api2.txt" | tr -d '\r')
nau=$(sed -n 27"p" $fhome"sett.conf" | tr -d '\r')
#nau1=0	#реальный статус nau в ПО

[ "$logging_level" == "1" ] && logger "autohcheck_nau api_status="$api_status
[ "$logging_level" == "1" ] && logger "autohcheck_nau nau="$nau

if [ "$api_status" == "DOWN" ]; then
  if [ "$nau" -gt "0" ]; then
	[ "$logging_level" == "1" ] && logger "autohcheck_nau nau>0"
	if [ "$nau1" -eq "0" ]; then
		[ "$logging_level" == "1" ] && logger "autohcheck_nau nau1=0"
		nau1=1
		set_date_nau;
	fi
	if [ "$nau1" -eq "1" ]; then
		if [ -f $fhome"nau_date.txt" ]; then
		[ "$logging_level" == "1" ] && logger "autohcheck_nau nau1=1"
		dtna1=$(sed -n 1"p" $fhome"nau_date.txt" | tr -d '\r')
		dtna=$(echo $(date '+ %Y%m%d%H%M%S') | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			if [ "$dtna" -gt "$dtna1" ]; then
				logger "autohcheck_nau dtna1="$dtna1" > dtna="$dtna
				echo "Zammad API DOWN "$nau" min" > $fhome"nau_alert.txt"
				otv=$fhome"nau_alert.txt"
				send;
				set_date_nau;
			else
				logger "autohcheck_nau dtna1="$dtna1" < dtna="$dtna
			fi
		fi
		
		if ! [ -f $fhome"nau_date.txt" ]; then
			set_date_nau;
		fi
	fi
  else
	logger "autohcheck_nau nau=0"
	nau1=0
	[ -f $fhome"nau_date.txt" ] &&	rm -f $fhome"nau_date.txt" && logger "autohcheck_nau del "$fhome"nau_date.txt"
  fi
fi

if [ "$api_status" == "UP" ]; then
	[ -f $fhome"nau_date.txt" ] &&	rm -f $fhome"nau_date.txt" && logger "autohcheck_nau del "$fhome"nau_date.txt"
	nau1=0
fi

}









PID=$$
echo $PID > $fPID
logger "subass start"
Init2;
kkik1=10;
check_api_zammad;


while true
do
sleep 3
kkik=$(($kkik+1))
kkik1=$(($kkik1-1))
[ "$kkik1" -eq "0" ] && kkik1=10 && night_mode && check_api_zammad && autohcheck_nau;
[ "$kkik" -ge "$progons" ] && Init2 && kkik=0

done



rm -f $fPID

