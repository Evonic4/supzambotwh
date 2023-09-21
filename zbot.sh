#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

#zntwh_bot
ver="v0.1"

fhome=/usr/share/zntwh_bot/
fhsender=$fhome"sender/"
fhsender1=$fhsender"1/"
fhsender2=$fhsender"2/"
sender_id=$fhome"sender_id.txt"
touch $fhome"number_list.txt"
#autat=0
fPID=$fhome"pid_zbot.txt"

function Init2()
{
logger "init start"
#load conf
chat_id1=$(sed -n 2"p" $fhome"sett.conf" | tr -d '\r')
#echo $chat_id1 | tr " " "\n" > $fhome"chats.txt"
#chat_id1=$(sed -n 1"p" $fhome"chats.txt" | tr -d '\r')

sec4=$(sed -n "6p" $fhome"sett.conf" | tr -d '\r')
opov=$(sed -n "7p" $fhome"sett.conf" | tr -d '\r')
port_wh=$(sed -n "8p" $fhome"sett.conf" | tr -d '\r')
bname=$(sed -n 11"p" $fhome"sett.conf" | tr -d '\r')
progons=$(sed -n 13"p" $fhome"sett.conf" | tr -d '\r')
logging_level=$(sed -n 14"p" $fhome"sett.conf" | tr -d '\r')
startopo=$(sed -n 15"p" $fhome"sett.conf" | tr -d '\r')
user1=$(sed -n 21"p" $fhome"sett.conf" | tr -d '\r')
pass1=$(sed -n 22"p" $fhome"sett.conf" | tr -d '\r')
urlpoint1=$(sed -n 23"p" $fhome"sett.conf" | tr -d '\r')
urlpoint2=$(sed -n 24"p" $fhome"sett.conf" | tr -d '\r')
urlpoint=$urlpoint1$urlpoint2
#echo "machine "$urlpoint2" login "$user1 "password "$pass1 > $fhome"cr.txt" #запуск в 

s_mute=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
tmode=$(sed -n 16"p" $fhome"sett.conf" | tr -d '\r')
progsz=$(sed -n 25"p" $fhome"sett.conf" | tr -d '\r')
ztich=$(sed -n 26"p" $fhome"sett.conf" | tr -d '\r')

mdt_start=$(sed -n 17"p" $fhome"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g'| tr -d '\r')
mdt_end=$(sed -n 18"p" $fhome"sett.conf" |sed 's/\://g'|sed 's/\-//g'|sed 's/ //g' | tr -d '\r')
#pochto=$(sed -n 21"p" $fhome"sett.conf" | tr -d '\r')

snu=0	#номер файла sender_queue
tinp_ok=0
tinp_err=0
kkik=0
}


function logger()
{
local date1=`date '+ %Y-%m-%d %H:%M:%S'`
echo $date1" zbot_"$bname": "$1
}







ticket_status ()
{
[ "$logging_level" == "1" ] && logger "ticket_status start"
ttst=$(echo $text | awk '{print $2}' | tr -d '\r')
logger "ticket_status ttst="$ttst

curl -s -m 13 --netrc-file $fhome"cr.txt" $urlpoint/api/v1/tickets/search?query=number:$ttst | jq '.' > $fhome"zticket.txt" #'.assets.Ticket'
[ "$logging_level" == "1" ] && logger "ticket_status superlog" && cat $fhome"zticket.txt"

str_col2=$(grep -cv "^#" $fhome"zticket.txt")
logger "ticket_status str_col2="$str_col2

if [ "$str_col2" -gt "6" ]; then

statet=$(cat $fhome"zticket.txt" | grep -m1 state_id | awk '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
groupt=$(cat $fhome"zticket.txt" | grep -m1 group_id | awk '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
priorityt=$(cat $fhome"zticket.txt" | grep -m1 priority_id | awk '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
titlett=$(cat $fhome"zticket.txt" | grep -m1 title | sed 's/: /TQ4534534/g' | awk -F"TQ4534534" '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')

customer1=$(cat $fhome"zticket.txt" | grep -A8 User | grep firstname | sed 's/: /TQ4534534/g' | awk -F"TQ4534534" '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
customer2=$(cat $fhome"zticket.txt" | grep -A8 User | grep lastname | sed 's/: /TQ4534534/g' | awk -F"TQ4534534" '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
customer3=$(cat $fhome"zticket.txt" | grep -A8 User | grep login | sed 's/: /TQ4534534/g' | awk -F"TQ4534534" '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
customer=$customer1" "$customer2" "$customer3

statet1=$(sed -n $statet"p" $fhome"t_st.txt" | tr -d '\r')
groupt1=$(sed -n $groupt"p" $fhome"t_gr.txt" | tr -d '\r')
priorityt1=$(sed -n $priorityt"p" $fhome"t_pr.txt" | tr -d '\r')

ticket_id=$(cat $fhome"zticket.txt" | grep -m1 "\"id\":" | sed 's/: /TQ4534534/g' | awk -F"TQ4534534" '{print $2}' | sed 's/\"/ /g' | sed 's/\,/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//')
url=$urlpoint"/#ticket/zoom/"$ticket_id


echo "Ticket="$ttst > $fhome"tst.txt"
echo $titlett >> $fhome"tst.txt"
echo "customer: "$customer >> $fhome"tst.txt"
echo $url >> $fhome"tst.txt"
echo >> $fhome"tst.txt"
echo "group: "$groupt1 >> $fhome"tst.txt"
echo "state: "$statet1 >> $fhome"tst.txt"
echo "priority: "$priorityt1 >> $fhome"tst.txt"
echo "---- " >> $fhome"tst.txt"

logger "ticket_status send"
#rm -f $fhome

else
logger "ticket_status NO send"
echo "ticket not found" > $fhome"tst.txt"
fi

otv=$fhome"tst.txt"
send;

}


roborob () 
{
local d1=""
local d2=""
local ttrgtrgf=""
local tmprbs1=""
#logger "roborob text="$text
otv=""
logger "roborob start"

if [ "$text" = "/start" ] || [ "$text" = "/?" ] || [ "$text" = "/help" ] || [ "$text" = "/h" ]; then
	logger "roborob help"
	otv=$fhome"help.txt"
	send;
fi
if [ "$text" = "/bs" ] || [ "$text" = "/status" ]; then
	logger "roborob bs"
	#opov
	[ "$opov" -eq "0" ] && tmprbs1="Managed"
	[ "$opov" -eq "1" ] && tmprbs1="Messenger"
	echo $tmprbs1" bot "$bname" "$ver > $fhome"ss.txt"
	
	#API zammad status up/down
	[ -f $fhome"check_api2.txt" ] && ttrgtrgf=$(sed -n 1"p" $fhome"check_api2.txt" | tr -d '\r') && echo "Zammad API status "$ttrgtrgf >> $fhome"ss.txt"
	
	#port wh
	check_wh_port=$(netstat -tupln | grep -c $port_wh)
	[ "$check_wh_port" == "0" ] && echo "Port webhook CLOSED" >> $fhome"ss.txt"
	[ "$check_wh_port" == "1" ] && echo "Port webhook OPEN" >> $fhome"ss.txt"
	
	#mute
	s_mute=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
	[ "$s_mute" == "0" ] && echo "Mute OFF" >> $fhome"ss.txt"
	[ "$s_mute" == "1" ] && echo "Mute ON" >> $fhome"ss.txt"
	
	#Night mode
	tmode=$(sed -n 16"p" $fhome"sett.conf" | tr -d '\r')
	d1=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
	d2=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
	[ "$tmode" == "0" ] && echo "Night mode OFF "$d1" - "$d2 >> $fhome"ss.txt"
	[ "$tmode" == "1" ] && echo "Night mode ON "$d1" - "$d2 >> $fhome"ss.txt"
	[ -f $fhome"ticket_nm_buf.txt" ] && echo $(cat $fhome"ticket_nm_buf.txt") >> $fhome"ss.txt"
	
	#Notification about API unavailability 
	local naustatus1=0
	naustatus1=$(sed -n "27p" $fhome"sett.conf" | tr -d '\r')
	[ "$naustatus1" -eq "0" ] && echo "Notification about API unavailability OFF" >> $fhome"ss.txt"
	[ "$naustatus1" -gt "0" ] && echo "Notification about API unavailability every "$naustatus1" min ON" >> $fhome"ss.txt"
	
	#telegram API errors
	sumi=$((tinp_ok+tinp_err))
	[ "$sumi" -gt "0" ] && echo "Telegram api send_err:"$(sed -n 1"p" $fhome"err_send.txt" | tr -d '\r')", input_err:"$(echo "scale=2; $tinp_err/$sumi * 100" | bc) >> $fhome"ss.txt"
	
	otv=$fhome"ss.txt"
	send;
fi

#Notification about API unavailability every 5 min
if [ "$text" = "/nau on" ] || [ "$text" = "/nau ON" ] || [ "$text" = "/nau On" ]; then
	logger "roborob nau ON"
	$fhome"to-config.sh" 27 1 &
	echo "Notification about API unavailability ON every 5 min" > $fhome"otv_nau.txt"
	otv=$fhome"otv_nau.txt";	send;
fi
if [ "$text" = "/nau off" ] || [ "$text" = "/nau OFF" ] || [ "$text" = "/nau Off" ]; then
	logger "roborob nau OFF"
	$fhome"to-config.sh" 27 0 &
	echo "Notification about API unavailability OFF" > $fhome"otv_nau.txt"
	logger "roborob nau OFF"
	otv=$fhome"otv_nau.txt";	send;
fi
if [ "$text" = "/nau" ] || [ "$text" = "/nau status" ]; then
	local naustatus=$(sed -n "27p" $fhome"sett.conf" | tr -d '\r')
	logger "roborob nau status="$naustatus
	[ "$naustatus" == "0" ] && echo "Notification about API unavailability OFF" > $fhome"otv_nau.txt"
	[ "$naustatus" == "1" ] && echo "Notification about API unavailability every 5 min ON" > $fhome"otv_nau.txt"
	otv=$fhome"otv_nau.txt";	send;
fi
#admin management 
if [[ "$text" == "/com"* ]]; then
	logger "roborob com"
	echo $text | tr " " "\n" > $fhome"com_conf.txt"
	local com1=""
	local com2=""
	com1=$(sed -n 2"p" $fhome"com_conf.txt" | tr -d '\r')
	com2=$(sed -n 3"p" $fhome"com_conf.txt" | tr -d '\r')
		
	if [[ $com1 =~ ^[0-9]+$ ]]; then
		older_conf=$(sed -n $com1"p" $fhome"sett.conf" | tr -d '\r')
		logger "configure com1="$com1" com2="$com2" older_conf="$older_conf
		echo "Configure "$older_conf" -> "$com2 > $fhome"configure.txt"
		$fhome"to-config.sh" $com1 $com2 &
		otv=$fhome"configure.txt"
		send;
	fi
fi
if [[ "$text" == "/ts"* ]]; then
	logger "roborob ticket_status"
	ticket_status;
fi
if [ "$text" = "/nm on" ] || [ "$text" = "/nm ON" ] || [ "$text" = "/nm On" ]; then
	logger "roborob nm ON"
	d1=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
	d2=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
	$fhome"to-config.sh" 16 1 &
	echo "Night mode on "$d1" - "$d2 > $fhome"otv_tmode.txt"
	otv=$fhome"otv_tmode.txt";	send;
fi
if [ "$text" = "/nm off" ] || [ "$text" = "/nm OFF" ] || [ "$text" = "/nm Off" ]; then
	logger "roborob nm OFF"
	d1=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
	d2=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
	$fhome"to-config.sh" 16 0 &
	echo "Night mode off "$d1" - "$d2 > $fhome"otv_tmode.txt"
	otv=$fhome"otv_tmode.txt";	send;
fi
if [ "$text" = "/nm status" ] || [ "$text" = "/nm stat" ] || [ "$text" = "/nm Status" ] || [ "$text" = "/nm STATUS" ] || [ "$text" = "/nm" ]; then
	tmode=$(sed -n 16"p" $fhome"sett.conf" | tr -d '\r')
	d1=$(sed -n 17"p" $fhome"sett.conf" | tr -d '\r')
	d2=$(sed -n 18"p" $fhome"sett.conf" | tr -d '\r')
	logger "roborob nm status="$tmode
	[ "$tmode" == "0" ] && echo "Night mode off" > $fhome"otv_tmode.txt"
	[ "$tmode" == "1" ] && echo "Night mode on "$d1" - "$d2 > $fhome"otv_tmode.txt"
	[ -f $fhome"ticket_nm_buf.txt" ] && echo $(cat $fhome"ticket_nm_buf.txt") >> $fhome"otv_tmode.txt"
	
	otv=$fhome"otv_tmode.txt";	send;
fi

if [ "$text" = "/mute on" ] || [ "$text" = "/mute ON" ] || [ "$text" = "/mute On" ]; then
	logger "roborob mute ON"
	$fhome"to-config.sh" 20 1 &
	echo "mute on" > $fhome"otv_mute.txt"
	otv=$fhome"otv_mute.txt";	send;
fi
if [ "$text" = "/mute off" ] || [ "$text" = "/mute OFF" ] || [ "$text" = "/mute Off" ]; then
	logger "roborob mute OFF"
	$fhome"to-config.sh" 20 0 &
	echo "mute off" > $fhome"otv_mute.txt"
	otv=$fhome"otv_mute.txt";	send;
fi
if [ "$text" = "/mute status" ] || [ "$text" = "/mute" ] || [ "$text" = "/mute st" ]; then
	s_mute=$(sed -n 20"p" $fhome"sett.conf" | tr -d '\r')
	[ "$s_mute" == "0" ] && echo "Mute OFF" > $fhome"otv_mute.txt"
	[ "$s_mute" == "1" ] && echo "Mute ON" > $fhome"otv_mute.txt"
	logger "roborob mute "$s_mute
	otv=$fhome"otv_mute.txt";	send;
fi

logger "roborob end otv="$otv
}




sender_queue ()
{
snu=$(sed -n 1"p" $sender_id | tr -d '\r')
snu=$((snu+1))
echo $snu > $sender_id
}


send1 () 
{
sender_queue;
echo $fhsender2"_"$snu".txt" > $fhome"sender.txt"
mv -f $otv $fhsender2"_"$snu".txt"
mv -f $fhome"sender.txt" $fhsender1"_"$snu".txt"
logger "send1 start snu="$snu
}




send ()
{
dl=$(wc -m $otv | awk '{ print $1 }')
logger "send start dl="$dl
if [ "$dl" -gt "4000" ]; then
	sv=$(echo "$dl/4000" | bc)
	sv=$((sv+1))
	echo "sv="$sv
	$fhome"rex.sh" $otv
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




input ()  		
{
logger "input start"
$fhome"cucu1.sh"

if [ "$(cat $fhome"in.txt" | grep "\"ok\":true,")" ]; then	
	tinp_ok=$((tinp_ok+1))
	logger "input OK "$tinp_ok
else
	tinp_err=$((tinp_err+1))
	logger "input ERROR "$tinp_err":   "$(grep "curl:" $fhome"in_err.txt")
fi
}



starten_furer ()  				
{

again2="yes"
while [ "$again2" = "yes" ] #крутим, пока $again1 будет равно "yes"
do
$fhome"cucu1.sh"
if [ "$(cat $fhome"in.txt" | grep "\"ok\":true,")" ]; then	
	logger "start input OK"
	again2="no"
else
	logger "start input ERROR"
fi
sleep 1
done


if [ "$starten" -eq "1" ]; then
	[ "$logging_level" == "1" ] && logger "starten_furer"
	upd_id=$(cat $fhome"in.txt" | jq ".result[].update_id" | tail -1 | tr -d '\r')
	logger "starten_furer upd_id="$upd_id"<"
	if ! [ -z "$upd_id" ]; then
		echo $upd_id > $fhome"lastid.txt"
		else
		echo "0" > $fhome"lastid.txt"
	fi
	logger "starten_furer upd_id="$upd_id
	starten=0
fi
}


parce ()
{
logger "parce"
mi=0
date1=`date '+ %d.%m.%Y %H:%M:%S'`
mi_col=$(cat $cuf"in.txt" | grep -c update_id | tr -d '\r')
logger "parce col mi_col ="$mi_col
upd_id=$(sed -n 1"p" $fhome"lastid.txt" | tr -d '\r')
logger "parce upd_id ="$upd_id

if [ "$mi_col" -gt "0" ]; then
for (( i=1;i<$mi_col;i++)); do
	mi=$(cat $fhome"in.txt" | jq ".result[$i].update_id" | tr -d '\r')
	logger "parce update_id="$mi

	[ -z "$mi" ] && mi=0
	[ "$mi" == "null" ] && mi=0
	
	logger "parce cycle upd_id="$upd_id", i="$i", mi="$mi
	if [ "$upd_id" -ge "$mi" ] || [ "$mi" -eq "0" ]; then
		ffufuf=1
		else
		ffufuf=0
	fi
	[ "$logging_level" == "1" ] && logger "parce cycle ffufuf="$ffufuf
	
	
	if [ "$ffufuf" -eq "0" ]; then
		chat_id=$(cat $fhome"in.txt" | jq ".result[$i].message.chat.id" | sed 's/-/z/g' | tr -d '\r')
		[ "$logging_level" == "1" ] && logger "parce chat_id="$chat_id
		if [ "$(echo $chat_id1|sed 's/-/z/g'| tr -d '\r'| grep $chat_id)" ]; then
			logger "parse chat_id="$chat_id" -> OK"
			text=$(cat $fhome"in.txt" | jq ".result[$i].message.text" | sed 's/\"/ /g' | sed 's/^[ \t]*//;s/[ \t]*$//' | tr -d '\r')
			[ "$logging_level" == "1" ] && logger "parse text="$text
			#echo $text > $home_trbot"t.txt"
			roborob;
			
			logger "parce ok"
		else
			logger "parce dont! chat_id="$chat_id" NOT OK"
		fi
	fi
	if [ "$ffufuf" -eq "1" ]; then
		logger "parce lastid >= mi"
	fi
done
[ "$ffufuf" -eq "0" ] && echo $mi > $fhome"lastid.txt" && logger "parce mi -> lastid.txt"
fi
#[ "$mi" -gt "0" ] && echo $mi > $fhome"lastid.txt" && logger "parce mi > lastid"
[ "$logging_level" == "1" ] && logger "parce end"
}


#auth_stat()
#{
#logger "auth_stat check credentials Zammad"
#curl -s -m 15 --netrc-file $fhome"cr.txt" $urlpoint/api/v1/tickets/search?query=number:$ztich | jq '.' > $fhome"zticket_ch.txt"
#if [ "$(grep error $fhome"zticket_ch.txt")" ]; then
#	logger "auth_stat ERROR:"$(grep "error\":" $fhome"zticket_ch.txt" | awk -F":" '{print $2}' | sed 's/"//g' | sed 's/,//g' | sed 's/^[ \t]*//;s/[ \t]*$//')
#	autat=0
#	echo "Invalid BasicAuth credentials Zammad" > $fhome"ss.txt"
#else
#	logger "auth_stat OK"
#	autat=1
#fi
#}











#-----------------------start 🗣
PID=$$
echo $PID > $fPID

Init2;
coolk=0
starten=1
#kkik1=$progsz

logger " "
logger "start zammad bot "$bname" logging_level="$logging_level
starten_furer;

#start
[ "$opov" -eq "0" ] && tmps1="managed"
[ "$opov" -eq "1" ] && tmps1="messenger"
[ "$startopo" == "1" ] && echo "Start "$tmps1" zammad bot "$bname > $fhome"start.txt" && otv=$fhome"start.txt" && send;

while true
do
sleep $sec4

tinp_ok1=$tinp_ok
[ "$opov" == "0" ] && input;
[ "$opov" == "0" ] && [ "$tinp_ok" -gt "$tinp_ok1" ] && parce;


kkik=$(($kkik+1))
#kkik1=$(($kkik1-1))
[ "$kkik" -ge "$progons" ] && Init2
#[ "$kkik1" -eq "0" ] && auth_stat && kkik1=$progsz

done


rm -f $fPID




