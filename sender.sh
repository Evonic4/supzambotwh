#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#переменные
fhome=/usr/share/zntwh_bot/
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"		#
fhsender2=$fhsender"2/"		#
fPID=$fhome"sender_pid.txt"

#sender_id=$fhome"sender_id.txt"
sender_list=$fhome"sender_list.txt"


function Init2() 
{
logger "Init2"
#rm -rf $fhsender
mkdir -p $fhsender1
mkdir -p $fhsender2
#echo 0 > $sender_id

ssec1=$(sed -n 10"p" $fhome"sett.conf" | tr -d '\r')
#logger "ssec1="$ssec1
bname=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
token=$(sed -n "1p" $fhome"sett.conf" | tr -d '\r')
proxy=$(sed -n 5"p" $fhome"sett.conf" | tr -d '\r')
bicons=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
kartinka=$(sed -n 3"p" $fhome"sett.conf" | tr -d '\r')
muter1=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
ssec=$(sed -n 19"p" $fhome"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
logging_level=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
chat_id=$(sed -n "2p" $fhome"sett.conf" | sed 's/z/-/g' | tr -d '\r')

kkik=0
sendok=0
senderr=0
#integrity;		#проверка запущены ли процессы
}



integrity ()
{
logger "integrity<<<<<<<<<<<<<<<<<<<"

local ab3p=""
local trbp=""
local sap=""
ab3p=$(ps af | grep $(sed -n 1"p" $fhome"wh_pid.txt" | tr -d '\r') | grep wh.sh | awk '{ print $1 }')
trbp=$(ps af | grep $(sed -n 1"p" $fhome"zbot_pid.txt" | tr -d '\r') | grep zbot.sh | awk '{ print $1 }')
sap=$(ps af | grep $(sed -n 1"p" $fhome"subass_pid.txt" | tr -d '\r') | grep subnuclear_assembler.sh | awk '{ print $1 }')

#ab3p=$(ps axu| awk '{ print $1 }' | grep $(sed -n 1"p" $fhome"wh_pid.txt")
#trbp=$(ps axu| awk '{ print $1 }' | grep $(sed -n 1"p" $fhome"zbot_pid.txt")
#sap=$(ps axu| awk '{ print $1 }' | grep $(sed -n 1"p" $fhome"subass_pid.txt")

logger "whp="$ab3p
logger "trbp="$trbp
logger "sap="$sap

[ -z "$ab3p" ] && logger "start wh.sh" && $fhome"wh.sh" &
sleep 1
[ -z "$sap" ] && logger "start subnuclear_assembler.sh" && $fhome"subnuclear_assembler.sh" &
[ -z "$trbp" ] && logger "start zbot.sh" && $fhome"zbot.sh" &
sleep 1
}



function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" sender_"$bname": "$1
}



function sender()
{
#logger "sender"

find $fhsender1 -maxdepth 1 -type f -name '*.txt' | sort > $sender_list
str_col=$(grep -cv "^---" $sender_list)
#logger "sender str_col="$str_col

if [ "$str_col" -gt "0" ]; then
for (( i=1;i<=$str_col;i++)); do
test=$(sed -n $i"p" $sender_list | tr -d '\r')
logger "sender str_col>0"

logger "sender test="$test
bicons=$(sed -n 12"p" $fhome"sett.conf" | tr -d '\r')
muter1=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
mess_path=$(sed -n "1p" $test | tr -d '\r')			#путь к мессаджу

	
if ! [ -z "$test" ] && ! [ -z "$mess_path" ]; then
	
	[ "$muter1" == "0" ] && muter="false"
	[ "$muter1" == "1" ] && muter="true"
	
	logger "sender mess_path="$mess_path
	logger "sender bicons="$bicons
	logger "sender muter="$muter
	
	
	directly
	
	#statistic
	if [ "$(cat $fhome"out2.txt" | grep "\"ok\":true,")" ]; then	
		sendok=$((sendok+1))
		logger "send OK "$sendok
		rm -f $test
		rm -f $mess_path
	else
		errc=$(grep "curl" $fhome"out2_err.txt")
		senderr=$((senderr+1))
		logger "send ERROR "$senderr":   "$errc
	fi
fi

sleep $ssec1
done

sums=$((sendok+senderr))
[ "$sums" -gt "0" ] && echo $(echo "scale=2; $senderr/$sums * 100" | bc) > $fhome"err_send.txt"

fi


}


pravka_teg () 
{
#все теги наХ
sed 's/</ /g' $mess_path > $fhome"sender_pravkateg1.txt"
sed 's/>/ /g' $fhome"sender_pravkateg1.txt" > $fhome"sender_pravkateg2.txt"
sed 's/B000000000001/<b>/g' $fhome"sender_pravkateg2.txt" > $fhome"sender_pravkateg_b01.txt"
sed 's/B000000000002/<\/b>/g' $fhome"sender_pravkateg_b01.txt" > $fhome"sender_pravkateg_b02.txt"
cp -f $fhome"sender_pravkateg_b02.txt" $mess_path
}


directly () {
logger " "
logger "sender directly"
[ "$(grep -c "<" $mess_path)" -gt "0" ] || [ "$(grep -c ">" $mess_path)" -gt "0" ] && pravka_teg

IFS=$'\x10'
text=`cat $mess_path`
echo "token="$token
echo "chat_id="$chat_id
echo $text

if ! [ -z "$text" ]; then
if [ -z "$proxy" ]; then
[ "$bicons" == "0" ] && curl -k -m $ssec -L -X POST https://api.telegram.org/bot$token/sendMessage -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
[ "$bicons" != "0" ] && curl -k -m $ssec -L -X POST https://api.telegram.org/bot$token/sendMessage -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$kartinka" "$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"

else
[ "$bicons" == "0" ] && curl -k -m $ssec --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage  -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
[ "$bicons" != "0" ] && curl -k -m $ssec --proxy $proxy -L -X POST https://api.telegram.org/bot$token/sendMessage  -d disable_notification=$muter -d chat_id="$chat_id" -d 'parse_mode=HTML' --data-urlencode "text="$kartinka" "$text 1>$fhome"out2.txt" 2>$fhome"out2_err.txt"
fi

fi

unset IFS


[ "$logging_level" == "1" ] && logger "sender responce:"
[ "$logging_level" == "1" ] && cat $fhome"out2.txt"
[ "$logging_level" == "1" ] && cat $fhome"out2_err.txt"

}








PID=$$
echo $PID > $fPID
logger "sender start"
cp -f $fhome"settings.conf" $fhome"sett.conf"

Init2;
integrity	#первый старт

while true
do
sleep 1
sender;

kkik=$(($kkik+1))
[ "$kkik" -ge "$progons" ] && Init2

done



rm -f $fPID

