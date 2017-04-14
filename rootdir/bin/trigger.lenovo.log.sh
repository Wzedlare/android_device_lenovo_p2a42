#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

#in rc file, starting lenovolog with class main, it will work abnormal.
#so I add the trigger.lenovo.log.sh file to trigger it. and add this delay. lenovolog will work well.
#and start logging from system boot.

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
while [ 1 ]
do
	if [ $(getprop sys.boot_completed) = 1 ]; then
		break;
	fi
	sleep 2
done

sleep 5    
 
setprop ctl.start lenovolog
setprop ctl.start lastkmsg 
