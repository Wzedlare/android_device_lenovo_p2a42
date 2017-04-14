#!/system/bin/sh

umask 022
LOGDIR=/data/local/log/aplog
LOGFILE=$LOGDIR/tzbsp_log
FUSE_FILE=/data/system/tzbsp/fuseflag

TARGET_PRODUCT=$(getprop ro.build.product)
#if [ "$TARGET_PRODUCT" != "passion" ];then
#	echo -e "No need to export tzbsp debug info\n"
#	exit 0
#fi

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
if [ -e $TZDBG/log ];then
	/system/bin/cat $TZDBG/log > $LOGFILE &
	TZDBG_JID=`pidof cat`
fi

sleep 1
#echo -e $TZDBG_JID >>/data/security/jid

if [ ! -e $FUSE_FILE ];then
	mkdir -p /data/system/tzbsp
	touch $FUSE_FILE
fi

if [ -e $LOGFILE ];then
	SEC_INFO=`cat $LOGFILE|grep secure_boot`
	if [ -n "$SEC_INFO" ];then
		SEC_INFO="secure_boot,Yes"
	else
		SEC_INFO="secure_boot,No"
	fi
	if [ -z "`grep secure_boot $FUSE_FILE`" ];then
		echo "$SEC_INFO" >>$FUSE_FILE
	fi
fi

#what we just need is debug info of PIL image loading
kill -9 $TZDBG_JID
