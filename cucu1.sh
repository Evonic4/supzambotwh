#!/bin/bash
export PATH="$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"

ftb=/usr/share/zntwh_bot/
fPID=$ftb"pid_cucu1.txt"

#Z1=$1

if ! [ -f $fPID ]; then	
	PID=$$
	echo $PID > $fPID
	ssec=5
	token=$(sed -n 1"p" $ftb"settings.conf" | tr -d '\r')
	proxy=$(sed -n 5"p" $ftb"settings.conf" | tr -d '\r')
	ssec=$(sed -n 19"p" $ftb"settings.conf" | tr -d '\r')
	logging_level=$(sed -n 14"p" $fhome"settings.conf" | tr -d '\r')

	if [ -z "$proxy" ]; then
		curl -k -s -L -m $ssec https://api.telegram.org/bot$token/getUpdates 1>$ftb"in0.txt" 2>$ftb"in0_err.txt"
	else
		curl -k -s -m $ssec --proxy $proxy -L https://api.telegram.org/bot$token/getUpdates 1>$ftb"in0.txt" 2>$ftb"in0_err.txt"
	fi

	mv -f $ftb"in0.txt" $ftb"in.txt"
	mv -f $ftb"in0_err.txt" $ftb"in_err.txt"
	
	[ "$logging_level" == "1" ] && logger "cucu1 responce:"
	[ "$logging_level" == "1" ] && cat $fhome"in.txt"
	[ "$logging_level" == "1" ] && cat $fhome"in_err.txt"

fi
rm -f $fPID
