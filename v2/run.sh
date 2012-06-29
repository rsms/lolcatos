#!/bin/bash

make

# Make a RAM disk of 1.44 MB as ExFAT
NUMSECTORS=2880
mydev=`hdid -nomount ram://$NUMSECTORS | awk '{print $1}'`
newfs_exfat -S 512 $mydev

# Copy the bootloader to the first sector
#dd if=boot.bin of=$mydev bs=2x80x18b
dd if=boot.bin of=$mydev bs=512 count=1

# Run Bochs
echo "Starting bochs, booting from $mydev..."
echo "If this works, you should see a welcoming message"
sudo bochs -qf bochsrc 'boot:a' 'floppya: 1_44='$mydev', status=inserted'

# Detach the RAM disk
hdiutil detach -force $mydev
