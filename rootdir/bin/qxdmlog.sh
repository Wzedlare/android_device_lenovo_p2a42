#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

umask 022


#LOGDIR=$(getprop persist.sys.lenovo.log.path)

CFGFILE=$(getprop persist.sys.lenovo.log.qxdmcfg)

LOGDISK=$(getprop persist.sys.lenovo.log.disk)
LOGFOLDER=$(getprop persist.sys.lenovo.log.folder)

LOGDIR=$LOGDISK"/log/"$LOGFOLDER

chmod 777 $CFGFILE

if [ ! -s $CFGFILE ]; then
	setprop persist.sys.lenovo.log.qxdm FALSE
	setprop persist.sys.lenovo.log.qxdmcfg " "
else
    #use this to flag the qxdm log has been opened in this boot 
    setprop  sys.lenovo.log.qxdm "opened"
	#kill the diag_mdlog process at first
	/system/bin/diag_mdlog -k
	# -s set the single log size in MB , -n set the number of file saved
	/system/bin/diag_mdlog -s 512 -n 6 -f $CFGFILE -o $LOGDIR
fi
