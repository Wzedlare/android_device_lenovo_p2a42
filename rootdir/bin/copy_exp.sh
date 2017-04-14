#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

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

OUTDISK=$(getprop persist.sys.lenovo.crash.disk)

	LOG=$OUTDISK"/mtklog"
	if [ -e $LOG ]; then		
		AEEEXP="/data/aee_exp" 
		LASTLOG="/data/local/log/lastlog" 
		cd $LOG  && rm -fr aee_exp_new lastlog
		[ -d $AEEEXP ] && cp -a $AEEEXP $LOG"/aee_exp_new"  
		[ -d $LASTLOG ] && cp -a $LASTLOG $LOG/lastlog       
		exit 0
	fi

	LOG=$OUTDISK"/log"
	if [ -e $LOG ]; then		
		LASTLOG="/data/local/log/lastlog" 
		cd $LOG  && rm -fr lastlog
		[ -d $LASTLOG ] && cp -a $LASTLOG $LOG/lastlog 
	fi


