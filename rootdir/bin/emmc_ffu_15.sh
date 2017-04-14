#!/system/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/system/bin/}

MID=`cat /sys/block/mmcblk0/device/manfid`
if [ "$MID" != "0x000015" ] ; then
  echo "Result: FAIL"
  echo "$SCRIPT: manufacturer not supported" > /dev/kmsg
  exit
fi
echo "Manufacturer: Samsung"

# Skip anything other than this model of Sandisk eMMC
PNM=`cat /sys/block/mmcblk0/device/name`
FIRMWARE_VERSION=`cat /sys/block/mmcblk0/device/firmware_version`
FIRMWARE_VERSION=${FIRMWARE_VERSION#0x}
echo "Device Name: $PNM"
echo "Firmware Version: $FIRMWARE_VERSION"

# eMMC
#   - 32G TLC BWBD3R
#   - 64G TLC CWBD3R
#eMCP 5.1
#   - 16G eMMC + 24G LP3: RE1BMB
#   - 32G eMMC + 24G LP3: RX1BMB
#   - 32G eMMC + 32G LP3: RX14MB
#   - 64G eMMC + 24G LP3: RC1BMB
#   - 64G eMMC + 32G LP3: RC14MB
case "$PNM" in
  "BWBD3R" | "CWBD3R")
    if [ "$FIRMWARE_VERSION" -ge "2" ] ; then
      echo "Result: PASS"
      echo "$SCRIPT: firmware already updated" > /dev/kmsg
      exit
    fi
    ;;
  "RE1BMB" | "RX1BMB" | "RX14MB" | "RC1BMB" | "RC14MB")
    if [ "$FIRMWARE_VERSION" -ge "12" ] ; then
      echo "Result: PASS"
      echo "$SCRIPT: firmware already updated" > /dev/kmsg
      exit
    fi
    ;;
  *)
    echo "Result: PASS"
    echo "$SCRIPT: no action required" > /dev/kmsg
    exit
    ;;
esac

CID=`cat /sys/block/mmcblk0/device/cid`
PRV=${CID:18:2}
echo "Product Revision: $PRV"

# Flash the firmware
echo "Starting upgrade..."
sync
/system/bin/emmc_ffu -yR
STATUS=$?

if [ "$STATUS" != "0" ] ; then
  echo "Result: FAIL"
  echo "$SCRIPT: firmware update failed ($STATUS)" > /dev/kmsg
  exit
fi

FIRMWARE_VERSION=`cat /sys/block/mmcblk0/device/firmware_version`
FIRMWARE_VERSION=${FIRMWARE_VERSION#0x}
echo "New Firmware Version: $FIRMWARE_VERSION"

if [ "$FIRMWARE_VERSION" -lt "2" ] ; then
  echo "Result: FAIL"
  echo "$SCRIPT: firmware update failed ($FIRMWARE_VERSION)" > /dev/kmsg
  exit
fi

echo "Result: PASS"
echo "$SCRIPT: firmware updated successfully" > /dev/kmsg
