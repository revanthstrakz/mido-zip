# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=raphielscape @ telegram lol
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
} # end properties 

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
mount /vendor;
mount -o remount,rw /vendor;
chmod -R 755 $ramdisk

## AnyKernel install
dump_boot;

# begin ramdisk changes

# add raphielscape initialization script
insert_line init.rc "import /init.spectrum.rc" after "import /init.trace.rc" "import /init.spectrum.rc";
insert_line init.rc "import /init.raphiel.rc" after "import /init.spectrum.rc" "import /init.raphiel.rc";
cp -rpf $patch/thermal-engine.conf /vendor/etc/thermal-engine.conf

#remove conflicting scheduler tuningscape
remove_line init.rc "    # scheduler tunables"
remove_line init.rc "    # Disable auto-scaling of scheduler tunables with hotplug. The tunables"
remove_line init.rc "    # will vary across devices in unpredictable ways if allowed to scale with"
remove_line init.rc "    # cpu cores."
remove_line init.rc "    write /proc/sys/kernel/sched_tunable_scaling 0"
remove_line init.rc "    write /proc/sys/kernel/sched_latency_ns 10000000"
remove_line init.rc "    write /proc/sys/kernel/sched_wakeup_granularity_ns 2000000"
remove_line init.rc "    write /proc/sys/kernel/sched_child_runs_first 0"

remove_line init.rc "    write /proc/sys/kernel/sched_rt_runtime_us 950000"
remove_line init.rc "    write /proc/sys/kernel/sched_rt_period_us 1000000"

remove_line init.rc "    # Tweak background writeout"
remove_line init.rc "    write /proc/sys/vm/dirty_expire_centisecs 200"
remove_line init.rc "    write /proc/sys/vm/dirty_background_ratio  5"

$bin/sepolicy-inject -s init -t rootfs -c file -p execute_no_trans -P sepolicy

# end ramdisk changes

write_boot;

## end install

