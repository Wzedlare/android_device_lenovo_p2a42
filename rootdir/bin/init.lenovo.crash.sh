#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

setprop persist.sys.lenovo.crash.out "/sdcard/log_out"
setprop persist.sys.lenovo.crash.disk "/sdcard"

LOGDISK=$(getprop persist.sys.lenovo.crash.path)


if [ $1 = KE ]; then

	setprop ctl.start last_dmsglog
else
	setprop ctl.start last_mainlog
	sleep 8
	setprop ctl.stop last_mainlog
	sleep 8	
	if [ -s $LOGDISK"/mainlog" ]; then
	    	setprop ctl.start diag_system
	fi
fi




