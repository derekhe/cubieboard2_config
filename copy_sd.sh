cd ../rootfs
mount /dev/sdb2 /mnt
mkdir /mnt/boot
mount /dev/sdb1 /mnt/boot
tar --exclude=qemu-arm-static -cf - . | tar -C /mnt -xvf - 
sync && umount /mnt/boot && umount /mnt
