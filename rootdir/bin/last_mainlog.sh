#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022

LOGDIR=$(getprop persist.sys.lenovo.crash.path)


MAIN_LOGFILE=$LOGDIR"/mainlog" #yexh1 

rm $MAIN_LOGFILE
/system/bin/logcat  -v threadtime -f $MAIN_LOGFILE


