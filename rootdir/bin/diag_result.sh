#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

#LOGDISK="/data/local/log/lastlog"
LOGDISK=$(getprop persist.sys.lenovo.crash.path)

OUTDISK=$(getprop persist.sys.lenovo.crash.disk)

RESULT_MINI=$OUTDISK"/log_out/diagnose_mini.txt"
RESULT_TXT=$OUTDISK"/log_out/diagnose.txt"

KERNEL_MINI=$LOGDISK"/kernel_mini.txt"
KERNEL_TXT=$LOGDISK"/kernel.txt"

ANDROID_MINI=$LOGDISK"/system_mini.txt"
ANDROID_TXT=$LOGDISK"/system.txt"



if [ -s $KERNEL_MINI -o -s $ANDROID_MINI ]; then

	cd $OUTDISK	
	if [ ! -e $OUTDISK"/log_out" ]; then
	    mkdir log_out
	fi       

    ACOUNT=$(getprop persist.sys.lenovo.Acrash.cnt)
    KCOUNT=$(getprop persist.sys.lenovo.Kcrash.cnt)

    echo "PHONE_CRASH: Kernel $KCOUNT times; Android $ACOUNT times\n" > $RESULT_MINI
	echo "*******PHONE_CRASH_KERNEL_BIGIN******" >> $RESULT_MINI
	[ -s $KERNEL_MINI ] && cat $KERNEL_MINI >> $RESULT_MINI
	echo "*******PHONE_CRASH_KERNEL_END******" >> $RESULT_MINI
	echo "\n*******PHONE_CRASH_ANDROID_BIGIN******" >> $RESULT_MINI
	[ -s $ANDROID_MINI ] && cat $ANDROID_MINI >> $RESULT_MINI	
	echo "*******PHONE_CRASH_ANDROID_END******" >> $RESULT_MINI


    echo "PHONE_CRASH: Kernel $KCOUNT times; Android $ACOUNT times\n" > $RESULT_TXT
	echo "*******PHONE_CRASH_KERNEL_BIGIN******" >> $RESULT_TXT
	[ -s $KERNEL_TXT ] && cat $KERNEL_TXT >> $RESULT_TXT
	echo "*******PHONE_CRASH_KERNEL_END******" >> $RESULT_TXT
	echo "\n*******PHONE_CRASH_ANDROID_BIGIN******" >> $RESULT_TXT
	[ -s $ANDROID_TXT ] &&cat $ANDROID_TXT >> $RESULT_TXT	
	echo "*******PHONE_CRASH_ANDROID_END******" >> $RESULT_TXT

    cd $OUTDISK && chmod -R 777 log_out
        #for mtk platform: copy the /data/aee_exp
	AEEEXP="/data/aee_exp" 
	cd $OUTDISK"/log_out" && rm -rf aee_exp
	[ -d $AEEEXP ] && cp -a $AEEEXP $OUTDISK"/log_out/aee_exp"

fi


        setprop ctl.start am_diag_done
	#am broadcast -a android.intent.action.DIAG_RESULT_LOG_DONE 
 	#send diagnose done broadcast


