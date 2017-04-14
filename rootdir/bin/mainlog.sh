#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022

if [ $(getprop persist.sys.lenovo.log) = FALSE ]; then
	exit 0
fi
if [ $(getprop persist.sys.lenovo.system) = FALSE ]; then
	exit 0
fi
BOOT_LOGFILE="/data/local/log/aplog/all_log_boot.txt" 
BOOT_LOG="/data/local/log/aplog" 

if [ $(getprop sys.boot_completed) = 1 ]; then
	LOGDIR=$(getprop persist.sys.lenovo.log.path)
	[ -e $BOOT_LOGFILE ] && cp $BOOT_LOGFILE $LOGDIR/ && rm $BOOT_LOGFILE
	MAIN_LOGFILE=$LOGDIR"/mainlog" #yexh1 
	/system/bin/logcat -r8096 -n 256 -v threadtime -f $MAIN_LOGFILE
else 
	#wait for phone is decrypt and need add some delay
	if [ $(getprop ro.crypto.state) = encrypted ]; then
		while [ 1 ]
		do
			if [ $(getprop vold.decrypt) = trigger_restart_framework ]; then
				sleep 10;
				break;
			fi
			sleep 2
		done
	fi
	mkdir -p $BOOT_LOG
	MAIN_LOGFILE=$BOOT_LOGFILE 
	/system/bin/logcat -b all -r8096 -n 1 -v threadtime -f $MAIN_LOGFILE
fi


