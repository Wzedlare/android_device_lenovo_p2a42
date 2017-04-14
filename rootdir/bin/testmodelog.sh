#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd	
#Authors: liuyc7@lenovo.com




DIR=/sdcard/testmodelog
if [ -d $DIR ];then
  echo "$DIR already exist."
else
  mkdir $DIR
	echo "$DIR mkdir ok."
fi

cat /proc/kmsg > /sdcard/testmodelog/testmode_kmsg.txt &
echo "cat /proc/kmsg > /sdcard/testmodelog/testmode_kmsg.txt"
logcat -v time > /sdcard/testmodelog/testmode_logcat.txt &
echo "logcat -v time > /sdcard/testmodelog/testmode_logcat.txt"
getprop > /sdcard/testmodelog/property
#chown -R media_rw:media_rw /sdcard/testmodelog
