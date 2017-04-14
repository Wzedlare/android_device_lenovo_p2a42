#!/system/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/system/bin/}

MID=`cat /sys/block/mmcblk0/device/manfid`
MID=${MID#0x0000}

# If we have an upgrade script for this manufactuer, execute it.
if [ -x /system/bin/emmc_ffu_${MID}.sh ] ; then
  /system/bin/sh /system/bin/emmc_ffu_${MID}.sh
else
  echo "Manufacturer: Other"
  echo "Result: PASS"
  echo "$SCRIPT: no action required" > /dev/kmsg
fi
