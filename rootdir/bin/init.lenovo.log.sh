#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

LOGDISK="/sdcard"
setprop persist.sys.lenovo.log.disk "/sdcard"


# setup log service. For eng variant, we set all log on.
if [ $(getprop persist.sys.lenovo.log) = TRUE ]; then

	COUNT=$(getprop persist.sys.lenovo.log.index)
	if [ -z "$COUNT" ]; then
		COUNT=0
	fi
	COUNT=$(($COUNT + 1))
	setprop persist.sys.lenovo.log.index $COUNT

	FILENAME=$(date +%Y_%m_%d_%H_%M_%S)
	FILENAME="Log""$COUNT""_"$FILENAME
	cd $LOGDISK

	if [ ! -e $LOGDISK"/log" ]; then
    	    mkdir log
	fi

	LOGSIZE=`/sbin/busybox du -shm $LOGDISK"/log" | /sbin/busybox awk '{print $1}'`       
	setprop persist.sys.lenovo.log.size $LOGSIZE
	#if log size big than limit, permit logging
	if [ $LOGSIZE -ge $(getprop persist.sys.lenovo.log.limit) ]; then	    
                 #echo $LOGSIZE $(getprop persist.sys.lenovo.log.limit)	
                setprop ctl.start am_loglimit          
                 #am broadcast -a android.intent.action.LENOVO_LOG_OVERLIMIT --es log_size $LOGSIZE   #send broadcast		 
	fi

	cd $LOGDISK"/log"
	mkdir $FILENAME

        setprop persist.sys.lenovo.log.path $LOGDISK"/log/"$FILENAME
        setprop persist.sys.lenovo.log.folder $FILENAME

        if [ $(getprop persist.sys.lenovo.log.system) = TRUE ]; then
		    setprop ctl.stop mainlog
            setprop ctl.start mainlog
            setprop ctl.start eventslog
        else
            setprop ctl.stop mainlog
            setprop ctl.stop eventslog
        fi
        if [ $(getprop persist.sys.lenovo.log.kernel) = TRUE ]; then
            setprop ctl.start kernellog
        else
            setprop ctl.stop kernellog
        fi
        if [ $(getprop persist.sys.lenovo.log.qxdm) = TRUE ]; then
            setprop ctl.start qxdmlog
        else
            #setprop ctl.stop qxdmlog
            /system/bin/diag_mdlog -k
        fi
        if [ $(getprop persist.sys.lenovo.log.other) = TRUE ]; then            
            setprop ctl.start tcplog
            setprop ctl.start radiolog
            #setprop persist.bt.btsnoop true
            setprop ctl.start qsee_log
            setprop ctl.start qsee_bsp_log
        else
            setprop ctl.stop tcplog
            setprop ctl.stop radiolog
            #setprop persist.bt.btsnoop false
        fi  
else
    setprop ctl.stop kernellog
    setprop ctl.stop mainlog
    setprop ctl.stop eventslog
    setprop ctl.stop tcplog
    setprop ctl.stop radiolog
    #setprop ctl.stop qxdmlog
    /system/bin/diag_mdlog -k
    #setprop persist.bt.btsnoop false
    setprop ctl.stop qsee_log
    setprop ctl.stop qsee_bsp_log
fi

#cd $LOGDISK && chown -R media_rw:media_rw log 




