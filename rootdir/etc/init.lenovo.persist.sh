#!/system/bin/sh
#lenovo-sw jixj 2014.6.12 add
#format /persist, and link /persist/WCNSS_qcom_wlan_nv.bin to system
#


wlan_nv_create_link() {
	if [ -e /persist/WCNSS_qcom_wlan_nv.bin ]; then
	     	echo "rm nv.bin in persist first" > /data/local/tmp/persist1.log
	   	/system/bin/rm /persist/WCNSS_qcom_wlan_nv.bin
	fi

	is_testmode=$(/system/bin/cat /proc/cmdline | /system/bin/grep "testmode")

	if [ "${is_testmode}" != "" ]; then
		if [ -e /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_ftm.bin ]; then
			echo "use ftm bin in testmode" > /data/local/tmp/persist2.log
			/system/bin/cp /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_ftm.bin /persist/WCNSS_qcom_wlan_nv.bin
		else
			echo "use st bin in testmode" > /data/local/tmp/persist2.log
			/system/bin/cp /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_st.bin /persist/WCNSS_qcom_wlan_nv.bin
		fi
        else
		if [ -e /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_st.bin  ]; then
			echo "use st bin in normal mode" > /data/local/tmp/persist2.log
			/system/bin/cp /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_st.bin /persist/WCNSS_qcom_wlan_nv.bin

		else
			echo "use qcom bin in normal mode" > /data/local/tmp/persist2.log
			/system/bin/cp /system/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv_lenovo.bin /persist/WCNSS_qcom_wlan_nv.bin
		fi
	fi
}

wlan_dictionary_create_link() {
	if [ -e /persist/WCNSS_wlan_dictionary.dat ]; then
	    /system/bin/rm /persist/WCNSS_wlan_dictionary.dat
	fi
	/system/bin/cp /system/etc/firmware/wlan/prima/WCNSS_wlan_dictionary_lenovo.dat /persist/WCNSS_wlan_dictionary.dat
}

aost_copy_file() {
	if [ -e /persist/aost ]; then
	    /system/bin/rm -r /persist/aost
	fi
	/system/bin/cp -r /system/etc/aost /persist/aost
}

#Note:it is not that graceful when formatting /persist/data/sfs,so just wrapper them out on 1st bootup stage
wrapper_out_sfs() {
	if [ ! -e /data/local/tmp/persist_sfs ];then
		touch /data/local/tmp/persist_sfs
		echo -e "[wrapper_sfs]:setprop with persist.sfs.enable" >>/data/local/tmp/persist_sfs
		if [ -d /persist/data/sfs/ ];then
			echo -e "[wrapper_sfs2]:setprop with persist.sfs.enable" >>/data/local/tmp/persist_sfs
			#/system/bin/cp -rf /persist/data/sfs/ /data/local/tmp/sfs
			/system/bin/rm -rf /persist/data/sfs/
		fi
	fi
}


aost_copy_file() {
	if [ -e /persist/aost ]; then
	    /system/bin/rm -r /persist/aost
	fi
	/system/bin/cp -r /system/etc/aost /persist/aost
}
wlan_nv_create_link
wlan_dictionary_create_link
#aost_copy_file
#wrapper_out_sfs
exit 0
