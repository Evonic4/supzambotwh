#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/zntwh_bot/
fwh=$fhome"wh/"
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
fPID=$fhome"pid_wh.txt"
sender_list=$fhome"sender_list.txt"



function Init() 
{
logger "Init"

opov=$(sed -n "7p" $ftb"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
logging_level=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
bname=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
tmode=$(sed -n 16"p" $ftb"sett.conf" | tr -d '\r')
mdt_start=$(sed -n 17"p" $ftb"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g'| tr -d '\r')
mdt_end=$(sed -n 18"p" $ftb"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g' | tr -d '\r')

port=$(sed -n 8"p" $fhome"sett.conf" | tr -d '\r')
ssec=$(sed -n 9"p" $fhome"sett.conf" | tr -d '\r')
urlpoint1=$(sed -n 23"p" $fhome"sett.conf" | tr -d '\r')
urlpoint2=$(sed -n 24"p" $fhome"sett.conf" | tr -d '\r')
urlpoint=$urlpoint1$urlpoint2
}

function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" wh_"$bname": "$1
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
mv -f $otv $fhsender2$number".txt"
echo $fhsender2$number".txt" > $fhsender1$number".txt"
}


night_mode ()  	
{
tmode=$(sed -n 16"p" $ftb"sett.conf" | tr -d '\r')
if [ "$tmode" == "1" ]; then
	mdt1=$(date '+%H%M%S')
	logger "night_mode mdt1="$mdt1" mdt_start="$mdt_start" mdt_end="$mdt_end
	#mdt_start="000000"
	#mdt_end="090000"
	if [ "$mdt1" \> "$mdt_start" ] && [ "$mdt1" \< "$mdt_end" ]; then
		n_mode=1
	else
		n_mode=0
		#ex_night_mode;
	fi
else
	n_mode=0
fi
logger "night_mode check n_mode="$n_mode
}





wh_parce ()
{
logger "wh_parce "$fwh$ttt".txt"
local str_col8=0
test=$fwh$ttt".txt"

		number=""
		number=$(tail -n1 $test | jq '.' | grep number | head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
		[ "$logging_level" == "1" ] && logger "wh_parce number="$number
		str_col8=$(grep -c $number $home"number_list.txt")
		[ "$logging_level" == "1" ] && logger "wh_parce str_col8="$str_col8
		
		if ! [ -z "$number" ] && [ "$str_col8" -eq "0" ]; then
			logger "wh_parce ticket "$number" NEW"
			echo $number >> $home"number_list.txt"
		
			title=$(tail -n1 $test | jq '.' | grep title |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			ticket_id=$(tail -n1 $test | jq '.' | grep ticket_id |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			url=$urlpoint"/#ticket/zoom/"$ticket_id
			firstname=$(tail -n1 $test | jq '.' | grep firstname |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			lastname=$(tail -n1 $test | jq '.' | grep lastname |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			login=$(tail -n1 $test | jq '.' | grep login |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			organization=$(tail -n1 $test | jq '.' | grep organization |  head -n 1 | awk -F":" '{print $2}' | sed 's/\"/ /g' | sed 's/,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
			logger "wh_parce number="$number
			logger "wh_parce title="$title
			logger "wh_parce ticket_id="$ticket_id
			logger "wh_parce url="$url
			logger "wh_parce firstname="$firstname
			logger "wh_parce lastname="$lastname
			logger "wh_parce login="$login
			logger "wh_parce organization="$organization
			
			echo "new ticket:" > $fhome"zammad1.txt"
			echo $number >> $fhome"zammad1.txt"
			echo $title >> $fhome"zammad1.txt"
			echo $firstname" "$lastname" "$login >> $fhome"zammad1.txt"
			! [ "$organization" == "null" ] && echo "("$organization")" >> $fhome"zammad1.txt"
			echo $url >> $fhome"zammad1.txt"
			echo "----" >> $fhome"zammad1.txt"
			
			night_mode;
			if [ "$n_mode" -eq "0" ]; then
				otv=$fhome"zammad1.txt"
				send;
			else
				echo $number >> $fhome"ticket_nm_buf.txt"
			fi
		else
			logger "wh_parce ticket "$number" OLD"
			
		fi

}



#START
PID=$$
echo $PID > $fPID

ttt=1;
[ -f $fhome"ttt.txt" ] && ttt=$(sed -n 1"p" $fhome"ttt.txt" | tr -d '\r')
Init;
logger "start wh port="$port


while true 
do
nc -l -q 1 -p $port > $fwh$ttt".txt"
if [ $(grep -c number $fwh$ttt".txt") -gt "0" ]; then
	wh_parce;
	rm -f $fwh$ttt".txt"
else
	logger "wh_parce "$fwh$ttt".txt bimbo"
	rm -f $fwh$ttt".txt"
fi

ttt=$((ttt+1))
#[ -f $fwh$ttt".txt" ] && ttt=$((ttt+1)) && logger "ttt="$ttt && echo $ttt > $fhome"ttt.txt"
[ "$ttt" -gt "922337203685477580" ] && ttt=1 && logger "ttt is 1" && echo $ttt > $fhome"ttt.txt"

sleep $ssec
done


rm -f $fPID


#tail -n1 ./4.txt | jq '.' | grep number
#tail -n1 ./4.txt | jq '.' | grep title
#tail -n1 ./4.txt | jq '.' | grep ticket_id
#https://support.mixvel.com/#ticket/zoom/6735

