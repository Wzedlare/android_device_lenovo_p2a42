#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

if [ -z "$1" ]; then        
	SAVEFLAG=$(getprop persist.sys.lenovo.log.save)
else
        SAVEFLAG=$1
fi


LOGDISK=$(getprop persist.sys.lenovo.log.disk)
LOGFOLDER=$(getprop persist.sys.lenovo.log.folder)

LASTKMSG="/data/local/log/lastkmsg" 
LASTLOG="/data/local/log/lastlog" 
GPSLOG_DIR=/data/gps/log
ANR_DIR=/data/anr
RECOVERY_DIR=/cache/recovery
CRASH_DIR=/data/tombstones
#BT_ENABLE=$APLOG_DIR/bluetooth.enable
BT_DIR=/data/misc/bluedroid
BT_ETC_DIR=/system/etc/bluetooth
WLAN_DIR=/data/misc/wifi
WLAN_FW_DIR=/sdcard/wlan_logs
DROPBOX_DIR=/data/system/dropbox
BOOTLOADER_LOG=/dev/block/bootdevice/by-name/logs
MODEM_DUMP_DIR=/sdcard/ramdump

mkdir -p $LOGDISK"/log"

# 
if [ $SAVEFLAG = TRUE ]; then

	APLOG_DIR=$LOGDISK"/log/"$LOGFOLDER
        mkdir -p $APLOG_DIR

	#ps -t -p -P | tee > $APLOG_DIR/ps.txt
	#top -n 1 -m 10 | tee > $APLOG_DIR/top.txt
	cat /proc/interrupts | tee > $APLOG_DIR/interrupts.txt
	cat /proc/meminfo | tee  > $APLOG_DIR/meminfo.txt
	source savelog_ddr_emmc.sh
	dumpsys meminfo | tee > $APLOG_DIR/meminfo_dump.txt
	dumpsys alarm | tee > $APLOG_DIR/alarm.txt
	dumpsys power | tee > $APLOG_DIR/power.txt

	if [ -z $(getprop sys.shutdown.requested) ]; then
		dumpsys batterystats | tee > $APLOG_DIR/batterystats.txt
		dumpsys audio | tee > $APLOG_DIR/audio_service.txt
		dumpsys media.audio_flinger | tee >> $APLOG_DIR/audio_service.txt
		dumpsys media.audio_policy | tee >> $APLOG_DIR/audio_service.txt
		dumpsys media_session | tee >> $APLOG_DIR/audio_service.txt
		dumpsys media_router | tee >> $APLOG_DIR/audio_service.txt
	fi

	getprop > $APLOG_DIR/prop.txt
	iptables -L >  $APLOG_DIR/iptables.txt
	iptables -L -t nat  >  $APLOG_DIR/iptables_nat.txt
	iptables -L -t mangle > $APLOG_DIR/iptables_mangle.txt
	iptables -L -t raw > $APLOG_DIR/iptables_raw.txt
	[ -e /system/etc/version.conf ] && cp /system/etc/version.conf $APLOG_DIR/
        
	DATAAPLOG="/data/local/log/aplog"
	[ -d $DATAAPLOG ]  && cp -a $DATAAPLOG/* $APLOG_DIR && cd $DATAAPLOG && rm -rf *

	APLOG_DIR=$LOGDISK"/log"
	mkdir -p $APLOG_DIR
                 

	cd $APLOG_DIR  && rm -fr lastkmsg lastlog gps anr recovery tombstones bluetooth wlan dropbox bootloader
	[ -d $LASTKMSG ] && cp -a $LASTKMSG $APLOG_DIR/lastkmsg
	[ -d $LASTLOG ] && cp -a $LASTLOG $APLOG_DIR/lastlog
	[ -d $GPSLOG_DIR ] && cp -a $GPSLOG_DIR $APLOG_DIR/gps
	[ -d $ANR_DIR ] &&  cp -a $ANR_DIR $APLOG_DIR/anr
	[ -d $RECOVERY_DIR ] && cp -a $RECOVERY_DIR $APLOG_DIR/recovery
	[ -d $CRASH_DIR ] && cp -a $CRASH_DIR $APLOG_DIR/tombstones
	[ -d $BT_ETC_DIR ] && cp -a $BT_ETC_DIR $APLOG_DIR/bluetooth
	[ -d $BT_DIR ] && cp $BT_DIR/* $APLOG_DIR/bluetooth
	[ -d $WLAN_DIR ] && cp -a $WLAN_DIR $APLOG_DIR/wlan
	[ -d $WLAN_FW_DIR ] && cp -a $WLAN_FW_DIR $APLOG_DIR/wlan
	[ -d $DROPBOX_DIR ] && mkdir -p $APLOG_DIR/dropbox && cp -a $DROPBOX_DIR/system_server* $APLOG_DIR/dropbox
	[ -L $BOOTLOADER_LOG ] && mkdir bootloader && dd if=$BOOTLOADER_LOG of=$APLOG_DIR/bootloader/logs.txt
	[ -d $MODEM_DUMP_DIR ] && mkdir -p modem && cp -a $MODEM_DUMP_DIR $APLOG_DIR/modem && rm -rf $MODEM_DUMP_DIR

fi

if [ $SAVEFLAG = CLEAN ]; then
	cd $LOGDISK

	if [ -e $LOGDISK"/log" ]; then
    	        cd log
		if [ $(getprop persist.sys.lenovo.log) = TRUE ]; then
		    rm -rf !($LOGFOLDER)
		else
		    rm -rf *
		fi
	fi
fi

if [ $SAVEFLAG = FALSE ]; then
	cd $LOGDISK

	if [ -e $LOGDISK"/log" ]; then
    	        cd log
		if [ $(getprop persist.sys.lenovo.log) = TRUE ]; then
		    rm -rf !($LOGFOLDER)
		else
		    rm -rf *
		fi
	fi

	cd $LOGDISK
	if [ -e $LOGDISK"/log_out" ]; then
    	        cd log_out
		rm -rf *		
	fi
fi


cd $LOGDISK && chown -R media_rw:media_rw log

setprop ctl.start am_savelog
#am broadcast -a android.intent.action.SAVE_LENOVO_LOG_DONE --es path $LOGDISK"/log"  


