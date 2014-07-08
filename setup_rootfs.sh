#!/bin/bash
set -e
export CONF=$PWD
export ROOTFS=$PWD/../rootfs
export KERNEL=$PWD/../linux-sunxi
export BOARDS=$PWD/../sunxi-boards
export TOOLS=$PWD/../sunxi-tools

cd $ROOTFS
echo "Setup root password"
chroot . passwd

echo "Setup host"
echo "Cubieboard" > ./etc/hostname

echo "Setup kernel modules"
cp $KERNEL/arch/arm/boot/uImage ./boot
make -C $KERNEL INSTALL_MOD_PATH=. ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install
echo TO:2345:respawn:/sbin/getty -L ttyS0 115200 vt100 >> etc/inittab

echo "Setup software sources"
echo deb http://http.debian.net/debian/ wheezy main contrib non-free > etc/apt/sources.list
echo deb http://security.debian.org/ wheezy/updates main contrib non-free >> etc/apt/sources.list

chroot . apt-get -y update
chroot . apt-get -y upgrade

echo "Install other tools"
chroot . apt-get -y install openssh-server
chroot . apt-get -y install locales
echo "en.US.UTF-8 UTF-8" > etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> etc/locale.gen
chroot . locale-gen
#chroot . apt-get install wireless-tools wpasupplicant fireware-ralink

echo "Install uEnv"
cp $CONF/uEnv.txt ./boot/

echo "Generate script.bin"
cp $BOARDS/sys_config/a20/cubieboard2.fex boot/script.fex
$TOOLS/fex2bin boot/script.fex boot/script.bin

echo "Build fstab"
cp $CONF/fstab etc/

echo "setup network"
cp $CONF/interfaces etc/network/interfaces
