#!/system/bin/sh


LOGDISK=$(getprop persist.sys.lenovo.log.disk)
      
am broadcast -a android.intent.action.SAVE_LENOVO_LOG_DONE --es path $LOGDISK"/log" 	 

