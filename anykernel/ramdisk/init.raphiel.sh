#!/system/bin/sh
# Copyright (C) 2018 Revanth Strakz (revanthstrakz)
# SPDX-License-Identifier: GPL-3.0-or-later

# Additional works afterboot for the sake of ramdisk changes to occur

function write() {
    echo -n $2 > $1
}

function copy() {
    cat $1 > $2
}

function get-set-forall() {
    for f in $1 ; do
        cat $f
        write $f $2
    done
}

{

# devfreq tuning
# Qualcomm is using obscure directory for devfreq, so follow up
restorecon -R /sys/class/devfreq/*qcom,cpubw*
get-set-forall /sys/class/devfreq/*qcom,cpubw*/governor bw_hwmon
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/sample_ms 4
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/io_percent 34
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/hist_memory 20
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/hyst_length 10
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/low_power_ceil_mbps 0
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/low_power_io_percent 34
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/low_power_delay 20
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/guard_band_mbps 0
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/up_scale 250
get-set-forall /sys/class/devfreq/*qcom,cpubw*/bw_hwmon/idle_mbps 1600
get-set-forall /sys/class/devfreq/*qcom,mincpubw*/governor cpufreq

# ZRAM
write /sys/block/zram0/reset 1
write /sys/block/zram0/disksize 1073741824

}&
