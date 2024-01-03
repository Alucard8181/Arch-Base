#!/bin/bash

loadkeys hu
setfont ter-v18n
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo ""
echo "By Tuxacard (2023)"
echo ""
echo "Inspired by Stephan Raabe-s work"
echo ""
echo "-----------------------------------------------------"
echo "Please take care the Disk(s) layout first !"
echo "-----------------------------------------------------"
echo ""
read -p " !! Warning: Run this script at your own risk. !! ( fdisk or cfdisk ) Press any key" C
echo ""
sleep 4
pacman -Sy
pacman -S archlinux-keyring
pacman -Syy

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
#I case if you want to determine you time zone run:
#timedatectl list-timezones | grep Bud ( Or what ever city you in )
timedatectl set-timezone Europe/Budapest
reflector -c Hungary -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/ParallelDownloads = 10/a\ILoveCandy' /etc/pacman.conf
sed -i 's/#\[multilib]/\[multilib]/g' /etc/pacman.conf
sed -i '/\[multilib]/a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
pacman -Syy
# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
clear
lsblk
echo "-------------------------------------------------------"
echo "If you don't want to use some of the offered drives for any reason, just press enter and leave it blank"
read -p "Enter the name of the  EFI partition (eg. sda1): " SDA1
read -p "Enter the name of the ROOT partition (eg. sda2): " SDA2
read -p "Enter the name of the HOME partition (eg. sda3): " SDA3

# ------------------------------------------------------
# In case of ext4
# ------------------------------------------------------
# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
echo "-------------------------------------------------------"
read -p "Do you want to format the drives? (y/n)" DRIVES
if
        [[ $DRIVES == "y" || $DRIVES == "Y" ]]; then
        mkfs.fat -F 32 /dev/$SDA1
        mkfs.ext4 -L Arch-Root /dev/$SDA2
        mkfs.ext4 -L Home /dev/$SDA3
else
       echo "Moving on....."
       sleep 1
fi

#-------------------------------------------------------
# Mount points for ext4
# ------------------------------------------------------
mount -o defaults,noatime /dev/$SDA2 /mnt
mkdir -p /mnt/{boot/efi,home}
mount -o defaults,noatime /dev/$SDA3 /mnt/home
mount -o defaults,noatime /dev/$SDA1 /mnt/boot/efi

# ------------------------------------------------------
# In case of BTRFS
# ------------------------------------------------------

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
#mkfs.fat -F 32 /dev/$SDA1
#mkfs.btrfs -f /dev/$SDA2
#mkfs.btrfs -f /dev/$SDA3
# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
#mount /dev/$SDA2 /mnt
#btrfs su cr /mnt/@
#btrfs su cr /mnt/@cache
#btrfs su cr /mnt/@home
#btrfs su cr /mnt/@snapshots
#btrfs su cr /mnt/@log
#umount /mnt

#mount -o compress=zstd:3,noatime,subvol=@ /dev/$SDA2 /mnt
#mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
#mount -o compress=zstd:3,noatime,subvol=@cache /dev/$SDA2 /mnt/var/cache
#mount -o compress=zstd:3,noatime,subvol=@home /dev/$SDA2 /mnt/home
#mount -o compress=zstd:3,noatime,subvol=@log /dev/$SDA2 /mnt/var/log
#mount -o compress=zstd:3,noatime,subvol=@snapshots /dev/$SDA2 /mnt/.snapshots

#mount /dev/$SDA1 /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$SDA3 /mnt/vm

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
clear
lscpu | grep "Vendor"
read -p "What type of CPU you have? (Please press "a/A" for AMD or "i/I" for INTEL)" CPU
if
        [[ $CPU == "a" || $CPU == "A" ]]; then
        pacstrap -K /mnt base base-devel git linux linux-headers linux-firmware micro openssh reflector rsync amd-ucode
else
   if
        [[ $CPU == "i" || $CPU == "I" ]]; then
        pacstrap -K /mnt base base-devel git linux linux-headers linux-firmware micro openssh reflector rsync intel-ucode
else
   		echo "This was not "i" or "a" input. Exiting...."
   		exit
   fi
fi
# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
clear
echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo "Just look what have you made me done......"
read -p "Is This ok? (If not i'am opening the editor for you.) (y/n)" FSTAB
if
        [[ $FSTAB == "y" || $FSTAB == "Y" ]]; then
		echo ""
        echo "Moving on....."
        sleep 1
else
	if
		[[ $FSTAB == "n" || $FSTAB == "N" ]]; then
		pacman --noconfirm -S micro
        micro /mnt/etc/fstab
else
		echo "This was not "y" or "n" input. Exiting...."
		exit	
	fi
        
fi
# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp Last-steps.sh /mnt/archinstall/
cp preload.sh /mnt/archinstall/
cp kvm.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh
