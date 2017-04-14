#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022

#yexh1 LOGFILE="/data/local/log/aplog/dmesglog"
if [ -z "$1" ]; then
	LOGDIR=$(getprop persist.sys.lenovo.log.path)
else 
	LOGDIR=$1  
fi

RADIO_LOGFILE=$LOGDIR"/radio" #yexh1 
/system/bin/logcat -r8096 -b radio -n 16 -v time -f $RADIO_LOGFILE "AT:S *:V"
