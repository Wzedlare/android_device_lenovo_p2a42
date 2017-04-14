#!/system/bin/sh
# set -x  # Uncomment to debug this script
# function: dump the last sleep info of tcxo, vreg, tlmm, clock and alarm for PM debug
#   author: yangjq
#  history: 2012-12-5, yangjq, initial version

# PMLOGFILE=$1
SMD_LOGFILE=$1 #yexh1 add 
PMLOGFILE=$2

if [ -z "$PMLOGFILE" ] ; then
  PMLOGFILE="/data/local/log/pmlog"
  SMD_LOGFILE="/data/local/log/smd_log"
fi

echo "" >> $PMLOGFILE
date  >> $PMLOGFILE

# Add oneshot run commands below
if [ "$PMLOG_ONESHOT" != "true" ]; then
  export PMLOG_ONESHOT="true"
  export PMLOG_COUNT=0

 # if [ -f $PMLOGFILE ]; then
 #   chmod 644 $PMLOGFILE
 # fi

  echo "RUN ONESHOT COMMANDS HERE!!!" >> $PMLOGFILE
# Log mpm pending irqs
# echo "3" > /sys/module/mpm_of/parameters/debug_mask
# Log gic and gpio resume irq
  echo "1" > /sys/module/msm_show_resume_irq/parameters/debug_mask
# Record sleeplog only if dmesglog is being recorded
  echo "255" > /sys/module/user_sysfs_private/parameters/debug_mask
# Log wakeup spmi interrupts(MPM 62, GIC 222)
# echo "func pmic_arb_periph_irq +p" > /sys/kernel/debug/dynamic_debug/control
# echo "func periph_interrupt +p" > /sys/kernel/debug/dynamic_debug/control
# echo "file qpnp-adc-tm.c +p" > /sys/kernel/debug/dynamic_debug/control
# echo "file qpnp-charger.c +p" > /sys/kernel/debug/dynamic_debug/control
# Log suspend stage
  echo "func enter_state +p" > /sys/kernel/debug/dynamic_debug/control
# Log devices' suspend and resume details
# echo "func pm_dev_dbg +p" > /sys/kernel/debug/dynamic_debug/control

# echo 4 > /sys/module/wakelock/parameters/debug_mask
# echo 1 > /sys/module/lpm_levels/parameters/debug_mask
  echo 0x16 > /sys/module/smd/parameters/debug_mask
# echo 64 > /sys/private/tlmm_num
fi
# Add oneshot run commands above

# echo $PMLOG_COUNT >> $PMLOGFILE
if [ $PMLOG_COUNT -lt 30 ]; then
# echo $PMLOG_COUNT >> $PMLOGFILE
  PMLOG_COUNT=$(($PMLOG_COUNT+1))

  if [ $PMLOG_COUNT == 5 ]; then
    echo "RUN DELAYED ONESHOT COMMANDS HERE!!!" >> $PMLOGFILE
    echo 1 > /sys/kernel/debug/clk/debug_suspend
#    echo 0 > /sys/class/power_supply/battery/charging_enabled
  fi
fi

# Add commands after each wakeup below
pm_wakeup=`cat /sys/private/pm_wakeup`
if [ "$pm_wakeup" == "true" ]; then
  echo "" >> $SMD_LOGFILE
  date  >> $SMD_LOGFILE
  # cat /sys/kernel/debug/ipc_logging/smd/log >> $SMD_LOGFILE
  cat /sys/kernel/debug/rpm_stats >> $SMD_LOGFILE
fi
# Add commands after each wakeup above

echo "current_now, brightness, gpuclk..." >> $PMLOGFILE
cat /sys/class/power_supply/battery/current_now >> $PMLOGFILE
cat /sys/class/leds/lcd-backlight/brightness >> $PMLOGFILE
cat /sys/class/kgsl/kgsl-3d0/gpuclk >> $PMLOGFILE
# cat /sys/private/tlmm >> $PMLOGFILE
# cat /d/clk/venus0_vcodec0_clk/measure >> $PMLOGFILE
# cat /sys/class/power_supply/battery/status >> $PMLOGFILE
# cat /sys/class/power_supply/battery/capacity >> $PMLOGFILE
# cat /sys/class/power_supply/battery/voltage_now >> $PMLOGFILE
# dumpsys power >> $PMLOGFILE
cat /sys/private/pm_status >> $PMLOGFILE
# cat /sys/private/tlmm_before_sleep >> $PMLOGFILE
# cat /sys/private/vreg_before_sleep >> $PMLOGFILE

