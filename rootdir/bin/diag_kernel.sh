#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

#LOGDISK="/data/local/log/lastlog"
LOGDISK=$(getprop persist.sys.lenovo.crash.path)

RESULT_MINI=$LOGDISK"/kernel_mini.txt"
RESULT_TXT=$LOGDISK"/kernel.txt"

DIAGNOSE_MINI=$LOGDISK"/k_temp_mini.txt"
DIAGNOSE_TXT=$LOGDISK"/k_temp.txt"

REPORT_TXT=$LOGDISK"/k_digest.txt"
LASTKMSG_LOGFILE=$LOGDISK"/lastkmsg"   #yexh1 

KE_MAGIC_KEY="KE_PANIC_TEST"
KE_KEY="] Kernel panic"
KE_WD_KEY="] Watchdog bark"
KE_SUBSYS_KEY="restart_level = SYSTEM"

function mergeK()
{
	TIME=$(date +%Y_%m_%d_%H_%M_%S)
	COUNT=$(getprop persist.sys.lenovo.Kcrash.cnt)
	if [ -z "$COUNT" ]; then
		COUNT=0
	fi
	COUNT=$(($COUNT + 1))
	setprop persist.sys.lenovo.Kcrash.cnt $COUNT
	
    	echo "\n-------***KERNEL CRASH(No. $COUNT)***-------\n Just before time: $TIME . Type: $1 " > $DIAGNOSE_MINI
	cat $DIAGNOSE_MINI >> $RESULT_MINI
	
	cat $DIAGNOSE_MINI $DIAGNOSE_TXT >> $RESULT_TXT

#we record the last 30 times of crash, each is about 300 lines
	mv $RESULT_TXT $DIAGNOSE_MINI
	tail -n 9000 $DIAGNOSE_MINI >  $RESULT_TXT

	mv $RESULT_MINI $DIAGNOSE_MINI
	tail -n 90 $DIAGNOSE_MINI >  $RESULT_MINI

	rm $DIAGNOSE_MINI
	#rm $DIAGNOSE_TXT
	rm $LASTKMSG_LOGFILE

	cd $LOGDISK && cd .. &&  chmod -R 777 lastlog

	sleep 10
	setprop sys.powerctl reboot
}

function setDigestHeader()
{
	echo "Crash tag: $1" > $REPORT_TXT
	echo "Subject: $1" >> $REPORT_TXT
	echo "Crash digest: $1" >> $REPORT_TXT
	getprop ro.build.description >> $REPORT_TXT
	getprop ro.serialno >> $REPORT_TXT
}

grep -a "$KE_MAGIC_KEY" $LASTKMSG_LOGFILE  > $DIAGNOSE_TXT

if [ -s $DIAGNOSE_TXT ]; then
	#messy log, wrong detect, need exit
	exit 0
fi

grep -a -B 280 -A 20 "$KE_SUBSYS_KEY" $LASTKMSG_LOGFILE  > $DIAGNOSE_TXT

if [ -s $DIAGNOSE_TXT ]; then
	setDigestHeader "KERNEL_PANIC"
	tail -n 50 $DIAGNOSE_TXT >>  $REPORT_TXT
	mergeK "$KE_SUBSYS_KEY"
	exit 0
fi

grep -a -B 298 -A 2 "$KE_KEY" $LASTKMSG_LOGFILE  > $DIAGNOSE_TXT

if [ -s $DIAGNOSE_TXT ]; then
	setDigestHeader "KERNEL_PANIC"
	grep -a -B 20 -A 6 "Internal error:" $DIAGNOSE_TXT  >> $REPORT_TXT	
	tail -n 26 $DIAGNOSE_TXT >>  $REPORT_TXT
	mergeK "$KE_KEY"
	exit 0
fi

grep -a -B 298 -A 2 "$KE_WD_KEY" $LASTKMSG_LOGFILE  > $DIAGNOSE_TXT

if [ -s $DIAGNOSE_TXT ]; then
	setDigestHeader "KERNEL_CRASH_WDT"
	tail -n 56 $DIAGNOSE_TXT >>  $REPORT_TXT
	mergeK "$KE_WD_KEY"
	exit 0
fi

rm $DIAGNOSE_MINI
#rm $DIAGNOSE_TXT
rm $LASTKMSG_LOGFILE



