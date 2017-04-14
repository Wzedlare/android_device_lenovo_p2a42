#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022

#yexh1 LOGFILE="/data/local/log/aplog/dmesglog"
if [ -z "$1" ]; then
	LOGDIR=$(getprop persist.sys.lenovo.log.path)
else 
	LOGDIR=$1  
fi

LOGFILE=$LOGDIR"/dmesglog"  #yexh1 

PMLOGSHELL_ENG="/system/bin/powerlog.sh"
PMLOGSHELL_USER="/data/local/log/powerlog.sh"

PMLOGFILE=$LOGDIR"/pmlog"  #yexh1 
SMD_LOGFILE=$LOGDIR"/smd_log"  #yexh1 
MV_FILES_SHELL="/system/bin/mv_files.sh"

#$MV_FILES_SHELL  $LOGFILE
#$MV_FILES_SHELL  $PMLOGFILE
#$MV_FILES_SHELL  $SMD_LOGFILE

while [ 1 ]
do
	echo "" >> $LOGFILE

	#if [ -e $PMLOGSHELL_ENG ]; then
	#	. $PMLOGSHELL_ENG $SMD_LOGFILE $PMLOGFILE 
	#fi

	dmesg -c >> $LOGFILE
	date  >> $LOGFILE

	LOGSIZE=`/sbin/busybox du -shm $LOGFILE | /sbin/busybox awk '{print $1}'`
       
	#if log size big than 10MB, move it
	if [ $LOGSIZE -ge 10 ]; then	    
             $MV_FILES_SHELL  $LOGFILE	
	fi
	sleep 2
done

