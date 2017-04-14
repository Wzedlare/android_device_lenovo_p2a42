#!/system/bin/sh

PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

while getopts dp op;
do
	case $op in
		d)  dbg_on=1;;
		p)  populate_only=1;;
	esac
done
shift $(($OPTIND-1))

scriptname=${0##*/}
hw_mp=/proc/hw
config_mp=/proc/config
xml_version="unknown"
hw_cfg_file=hw_config.xml
vhw_file=/system/etc/vhw.xml
bp_file=/system/build.prop
oem_file=/oem/oem.prop
need_to_reload=2
reload_in_progress=1
reload_done=0
set -A prop_names
set -A prop_overrides
prop_names=(ro.product.device ro.product.name)

debug()
{
	[ $dbg_on ] && echo "Debug: $*"
}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

populate_hw_partition()
{
	local xml_file=$1
	local section=$2
	local node=${3:-}
	local utag
	local param
	local verify
	local rc
	local parsed_out
	local ifs
	debug "parsing '$section'"
	parsed_out=$(motobox expat -f $xml_file $section $node 2>/dev/null)
	ifs=$IFS; IFS=$'\n'
	for el in $parsed_out; do
		utag=${el% *}
		if [ ! -d $hw_mp/$utag ]; then
			notice "creating utag '$hw_mp/$utag'"
			echo $utag > $hw_mp/all/new
			rc=$?
			[ "$rc" != "0" ] && notice "'$utag' create dir failed rc=$rc"
		fi
		param=${el#* }
		debug "writing '$param' to '$hw_mp/$utag/ascii'"
		echo "$param" > $hw_mp/$utag/ascii
		rc=$?
		[ "$rc" != "0" ] && notice "'$utag' write file failed rc=$rc"
		verify=$(cat $hw_mp/$utag/ascii)
		debug "read '$verify' from '$hw_mp/$utag/ascii'"
		[ "$verify" != "$param" ] && notice "'$utag' payload validation failed"
	done
	IFS=$ifs
}

retrieve_properties()
{
	local prop_file=$1
	local token
	local value
	local ifs
	local parsed_out
	local idx=0
	if [ ! -f $prop_file ]; then
		notice "warning: unable to find '$prop_file'"
		return
	fi
	parsed_out=$(cat $prop_file)
	for prop in ${prop_names[@]}; do
		debug "searching prop [$prop] in '$prop_file'"
		value=""; ifs=$IFS; IFS=$'\n'
		for line in $parsed_out; do
			token=${line%=*}
			if [ "$token" == "$prop" ]; then
				value=${line#*=}
				prop_overrides[$idx]=$value
				debug "property's [$prop] value '$value'"
				break
			fi
		done
		IFS=$ifs
		let idx=$((idx+1))
	done
}

append_hw_variant()
{
	local variant=$1
	local value
	local idx=0
	retrieve_properties $bp_file
	debug "build props (${prop_overrides[*]})"
	if [ -f $oem_file ]; then
		retrieve_properties $oem_file
		debug "oem props (${prop_overrides[*]})"
	fi
	[ -z "$variant" ] && notice "falling back to no variant"
	for prop in ${prop_names[@]}; do
		value=${prop_overrides[$idx]}
		debug "updating prop [$prop] to override[$idx]='$value'"
		if [ -z "$value" ]; then
			let idx=$((idx+1))
			notice "empty value for property '$prop'"
			continue;
		fi
		setprop $prop "$value$variant"
		notice "$prop='$value$variant'"
		let idx=$((idx+1))
	done
}

search_hw_variant()
{
	local __result=$1
	local utag
	local param
	local value
	local token
	local suffix
	local match
	local ifs
	local parsed_out
	notice "determining hw variant"
	match="undefined"
	for var in $(motobox expat -f $vhw_file validation variants 2>/dev/null); do
		eval token=$var
		parsed_out=$(motobox expat --file $vhw_file validation variants $token 2>/dev/null)
		match="reset"; suffix=""; ifs=$IFS; IFS=$'\n'
		for el in $parsed_out; do
			debug "pair '$el'"
			utag=${el% *}
			param=${el#* }
			debug "utag '$utag' parameter '$param' match \"$match\""
			# if one of parameters did not match, just skip rest of them
			if [ "$match" != "false" ]; then
				[ -f $hw_mp/$utag/ascii ] && value=$(cat $hw_mp/$utag/ascii)
				if [ "$value" == "$param" ]; then
					match="true"; suffix=$var
				else
					match="false"; suffix=""
				fi
				debug "comparison '$param' & '$value' is \"$match\""
			fi
		done
		IFS=$ifs
		# escape loop if there is a match
		[ "$match" == "true" ] && break
	done
	case $match in
		"true") debug "variant [$suffix] matched";;
		"undefined") notice "no variants in xml";;
		*) notice "no match found for product variant";;
	esac
	eval $__result=$suffix
}

set_hw_properties()
{
	local path
	local utag
	local prefix
	local value
	local verify
	for hwtag in $(find $hw_mp -name '.system'); do
		debug "path $hwtag has '.system' in its name"
		prefix=$(cat $hwtag/ascii)
		verify=${prefix%.}
		# esure prefix ends with '.'
		if [ $prefix == $verify ]; then
			prefix="$prefix."
			debug "added '.' at the end of [$prefix]"

                fi
		path=${hwtag%/*}
		utag=${path##*/}
		value=$(cat $path/ascii)
		setprop $prefix$utag $value
		notice "ro.hw.$utag='$value'"
	done
}

load_hw_config()
{
	local __result=$1
	local value
	notice "force loading UTAGs"
	echo 1 > $hw_mp/reload
	value=$(cat $hw_mp/reload)
	while [ "$value" == "$reload_in_progress" ]; do
		notice "waiting for loading to complete"
		sleep 1;
		value=$(cat $hw_mp/reload)
	done
	notice "loading completed"
	eval $__result=$value
}

load_utags_config()
{
	local __result=$1
	local value
	notice "force loading UTAGs config"
	echo 1 > $config_mp/reload
	value=$(cat $config_mp/reload)
	while [ "$value" == "$reload_in_progress" ]; do
		notice "waiting for utags loading to complete"
		sleep 1;
		value=$(cat $config_mp/reload)
	done
	notice "loading utags completed"
	eval $__result=$value
}

notice "checking integrity"
# check necessary components exist and just proceed with empty variant otherwise
#$(motobox expat --help 2>/dev/null)
#if [ "$?" == "255" ] || [ ! -f $vhw_file ]; then
#	notice "missing expat or xml"
#	append_hw_variant ""
#	return 0
#fi

#if [ ! -z "$populate_only" ]; then
#	for path in /data/local/tmp /pds/factory; do
#		[ -f $path/$hw_cfg_file ] && break
#	done
#	notice "populating HW config from '$path/$hw_cfg_file'"
#	populate_hw_partition $path/$hw_cfg_file hardware
#	return 0
#fi

#while [ ! -f $hw_mp/reload ]; do
#	notice "hw config not ready"
#	sleep 1;
#done

#readiness=$(cat $hw_mp/reload)
#[ "$readiness" == "$need_to_reload" ] && load_hw_config readiness

#if [ "$readiness" != "$reload_done" ]; then
#	notice "hw config loading failed"
#	append_hw_variant ""
#	return 0
#fi

#lenovo-sw jixj add for load config
while [ ! -f $config_mp/reload ]; do
	notice "hw config not ready"
	sleep 1;
done

readiness=$(cat $config_mp/reload)
[ "$readiness" == "$need_to_reload" ] && load_utags_config readiness

if [ "$readiness" != "$reload_done" ]; then
	notice "utags config loading failed"
	append_hw_variant ""
	return 0
fi

#xml_version=$(motobox expat -f $vhw_file validation constraints version 2>/dev/null)
#[ $? != "0" ] && notice "cannot determine XML version"
#xml_version=${xml_version#* }

#version_fs="unknown"
#[ -d $hw_mp/version ] && version_fs=$(cat $hw_mp/version/ascii)
#notice "procfs version '$version_fs'"

#if [ "$version_fs" != "$xml_version" ]; then
#	populate_hw_partition $vhw_file validation features
#	populate_hw_partition $vhw_file validation attributes
#	populate_hw_partition $vhw_file validation constraints
#	notice "hw config populated"
#fi

#search_hw_variant variant
#append_hw_variant $variant
#set_hw_properties

return 0
