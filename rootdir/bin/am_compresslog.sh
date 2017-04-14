#!/system/bin/sh

      
LOGDISK=$(getprop persist.sys.lenovo.log.disk)
FOLDER=$LOGDISK"/log_out"

FILE=$(getprop persist.sys.lenovo.log.outfile)	


am broadcast -a android.intent.action.COMPRESS_LENOVO_LOG_DONE --es path $FOLDER --es path_result $FILE	 

