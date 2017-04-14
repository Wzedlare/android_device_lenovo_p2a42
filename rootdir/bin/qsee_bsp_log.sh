#!/system/bin/sh

umask 022
LOGDIR=/data/local/log/aplog
LOGFILE=$LOGDIR/qsee_bsp_log

TARGET_PRODUCT=$(getprop ro.build.product)
TARGET_BUILD_VARIANT=$(getprop ro.build.type)

# Note: user variant is suitable for further logs output with ####3333#
# while eng variant can be read directly via adb shell from /d/tzdbg/log file 
if [ "$TARGET_BUILD_VARIANT" == "eng" ];then
	echo -e "No need export qsee bsp log with ENG version\n"
	exit 0
fi

# Note: only for PASSION class project
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

if [ -e $TZDBG/log ];then
	/system/bin/cat $TZDBG/log > $LOGFILE
fi

