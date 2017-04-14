#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022

LOGDIR=$(getprop persist.sys.lenovo.crash.path)

LASTKMSG_LOGFILE=$LOGDIR"/lastkmsg"   #yexh1 

if [ -s /sbin/busybox ]; then
    BUSYBOX="/sbin/busybox"
else
    BUSYBOX=""
fi


LASTKMSG_SRC="/proc/last_kmsg"
if [ -f $LASTKMSG_SRC ]; then    
	cat $LASTKMSG_SRC > $LASTKMSG_LOGFILE   
fi


if [ -s $LASTKMSG_LOGFILE  ]; then
    	setprop ctl.start diag_kernel
fi
