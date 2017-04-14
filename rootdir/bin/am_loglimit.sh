#!/system/bin/sh


LOGSIZE=$(getprop persist.sys.lenovo.log.size) 
      
am broadcast -a android.intent.action.LENOVO_LOG_OVERLIMIT --es log_size $LOGSIZE   #send broadcast		 

