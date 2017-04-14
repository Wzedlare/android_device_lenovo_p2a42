#!/system/bin/sh


enabled_mtk=$(getprop debug.MB.Running 0)
enabled_qcom=$(getprop persist.sys.lenovo.log FALSE)
NOT_EXIST_PATH="\\"
LOGPATH=$NOT_EXIST_PATH

# get LOGFILE for MTK platform
if [ $enabled_mtk = "1" ]; then
	LOGPATH=$(getprop debug.MB.realpath $NOT_EXIST_PATH)
fi

# get LOGFILE for QCOM platform
if [ $enabled_qcom = "TRUE" ]; then
	LOGPATH=$(getprop persist.sys.lenovo.log.path $NOT_EXIST_PATH)
fi

# check if output path exists
if [ -d $LOGPATH ]; then
	LOGFILE=$LOGPATH"/lenovo_dumpsys.txt"

	# start dump sys
	log -p w -t lenovo_dumpsys.sh start lenovo_dumpsys into $LOGFILE

	echo "\n============== begin ============================\n" >> $LOGFILE
	date >> $LOGFILE

	echo "\n ================== dumpsys activity activities:\n" >> $LOGFILE
	dumpsys activity activities | tee >> $LOGFILE

	echo "\n ================== dumpsys window -a:\n" >> $LOGFILE
	dumpsys window -a | tee >> $LOGFILE

	echo "\n ================== dumpsys SurfaceFlinger:\n" >> $LOGFILE
	dumpsys SurfaceFlinger | tee >> $LOGFILE

	echo "\n ================== dumpsys activity:\n" >> $LOGFILE
	dumpsys activity | tee >> $LOGFILE

	echo "\n============== end ============================\n" >> $LOGFILE

	# refresh MTP
	# am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://$LOGFILE
else
	# path does not exists
	log -p w -t lenovo_dumpsys.sh output path does not exists: $LOGPATH
fi

