#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

LOGDISK=$(getprop persist.sys.lenovo.log.disk)
#LOGFOLDER=$(getprop persist.sys.lenovo.log.folder)
OUTFOLDER=$LOGDISK"/log_out"
SAVELOG_SHELL="/system/bin/savelog.sh"

FILENAME=$(date +%Y_%m_%d_%H_%M_%S)
OUTFILE=$OUTFOLDER/${FILENAME}.tgz
setprop persist.sys.lenovo.log.outfile $OUTFILE

mkdir -p $OUTFOLDER

tar zcf $OUTFILE  -C $LOGDISK log

cd $LOGDISK && chown -R media_rw:media_rw log_out

if [ $(getprop persist.sys.lenovo.log.save) = CLEAN ]; then
     $SAVELOG_SHELL CLEAN
fi


setprop ctl.start am_compresslog
#am broadcast -a android.intent.action.COMPRESS_LENOVO_LOG_DONE --es path $OUTFOLDER --es path_result $OUTFILE

