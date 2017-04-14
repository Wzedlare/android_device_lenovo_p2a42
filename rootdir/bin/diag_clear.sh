#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: yexh1@lenovo.com

OUTDISK=$(getprop persist.sys.lenovo.crash.disk)


if [ -e $OUTDISK"/log_out" ]; then
    cd $OUTDISK	
    rm -rf log_out
fi       






