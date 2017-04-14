#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

#LOGDISK="/data/local/log/lastlog"
LOGDISK=$(getprop persist.sys.lenovo.crash.path)
OUTDISK=$(getprop persist.sys.lenovo.crash.disk)

setprop persist.sys.lenovo.Kcrash.cnt 0
setprop persist.sys.lenovo.Acrash.cnt 0   


if [ -e $OUTDISK"/log_out" ]; then
    cd $OUTDISK	
    rm -rf log_out
fi      


if [ -e $LOGDISK ]; then
    cd $LOGDISK	
    rm -rf *
fi  

  






