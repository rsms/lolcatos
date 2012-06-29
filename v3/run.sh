#!/bin/bash
set -e

make

# Make a RAM disk of 1.44 MB
NUMSECTORS=2880
mydev=`hdid -nomount ram://$NUMSECTORS | awk '{print $1}'`

function cleanup() {
  # Detach the RAM disk
  hdiutil detach -force $mydev
}
trap cleanup EXIT INT TERM

# Create FAT12 boot sector
#newfs_msdos -F 12 -S 512 $mydev

# Copy the bootloader to the first sector
#dd if=boot.bin of=$mydev bs=2x80x18b
dd if=boot.bin of=$mydev bs=512 count=1

# Mount, copy boot2 and unmount
mkdir -p mnt
mount_msdos $mydev mnt
cp meow.bin mnt/MEOWLOL.CAT
umount -f mnt

# Run Bochs
echo "Starting bochs, booting from $mydev..."
sudo bochs -qf bochsrc 'boot:a' 'floppya: 1_44='$mydev', status=inserted'

trap - EXIT INT TERM
cleanup
exit 0
