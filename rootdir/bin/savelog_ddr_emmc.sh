#!/system/bin/sh

#Copyright (c) 2015 Lenovo Co. Ltd
#Authors: yexh1@lenovo.com

	info_lpddr="$(cat /sys/ram/info)"
	info_lpddr_mr5="$(cat /sys/ram/mr5)"
	info_lpddr_mr6="$(cat /sys/ram/mr6)"
	info_lpddr_mr7="$(cat /sys/ram/mr7)"
	info_lpddr_mr8="$(cat /sys/ram/mr8)"
	info_emmc_cid="$(cat /sys/block/mmcblk0/device/cid)"
	info_emmc_name="$(cat /sys/block/mmcblk0/device/name)"
	info_emmc_prv="$(cat /sys/block/mmcblk0/device/prv)"
	info_emmc_size=$(cat /sys/block/mmcblk0/size)
	info_emmc_size_GB=$((${info_emmc_size}/1024/1024*512/1024))
	info="lpddr="$info_lpddr",mr5="$info_lpddr_mr5",mr6="$info_lpddr_mr6",mr7="$info_lpddr_mr7",mr8="$info_lpddr_mr8
	echo "$info" > $APLOG_DIR/ddr_emmc.txt
	info="emmc_cid="$info_emmc_cid",emmc_size="$info_emmc_size_GB"GB"",emmc_name="$info_emmc_name",emmc_prv="$info_emmc_prv
	echo "$info" >> $APLOG_DIR/ddr_emmc.txt
#am broadcast -a android.intent.action.SAVE_LENOVO_LOG_DONE --es path $LOGDISK"/log"  


