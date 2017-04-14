#!/system/bin/sh

umask 022
LOGDIR=/data/local/log/aplog
LOGFILE=$LOGDIR/qsee_ta_log

TARGET_PRODUCT=$(getprop ro.build.product)
if [ "$TARGET_PRODUCT" == "" ];then
	echo -e "No need to export qsee log beyond PASSION\n"
	exit 0
fi

if [ -z "$1" ]; then
        mkdir -p $LOGDIR
	#LOGDIR=$(getprop persist.sys.lenovo.log.path)
else
        LOGDIR=$1
fi

if [ ! -e $LOGFILE ];then
	touch $LOGFILE
fi

TZDBG=/sys/kernel/debug/tzdbg

if [ -e $TZDBG/qsee_log ];then
	/system/bin/cat $TZDBG/qsee_log > $LOGFILE
	#TZDBG_JID=`pidof cat`
fi

#Scan the status of property to stop this cycle
#Then ouput from /data/local to /sdcard0/
#while [ "$LOG_EXPORT_STAT" != "yes" ];do
#	sleep 1
#	LOG_EXPORT_STAT=$(getprop sys.lenovo.log.qsee_stop)
#done


#kill -9 $TZDBG_JID
