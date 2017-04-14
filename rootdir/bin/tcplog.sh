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

TCP_LOGFILE=$LOGDIR"/tcp" #yexh1 
/system/xbin/tcpdump -s 1500 -w $TCP_LOGFILE -C 12 -W 6  -Z root -i any host not 192.168.100.2 and host not 127.0.0.1
