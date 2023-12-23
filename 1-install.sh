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
echo "-----------------------------------------------------"
echo "Please take care the Disk(s) layout first !"
echo "-----------------------------------------------------"
echo ""
echo " !! Warning: Run this script at your own risk. !!"
echo ""
read -p "Find the 'Any key' and please press it'" c
# # Maybe it's required to install the current archlinux keyring
# if the installation of git fails. Uncomment if needed.
#pacman -Sy
#pacman -S archlinux-keyring
#pacman -Syy

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
#I case if you want to determine you time zone run:
#timedatectl list-timezones | grep Bud ( Or what ever city you in )
timedatectl set-timezone Europe/Budapest
reflector -c Hungary -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sed -i '/#Color/c\Color' /etc/pacman.conf
sed -i '/#ParallelDownloads = 5/c\ParallelDownloads = 10' /etc/pacman.conf
sed -i '/ParallelDownloads = 10/a\ILoveCandy' /etc/pacman.conf
echo "Do you want to have multilib repoistory enable?  ( For 32bit aplications )  (  y or n )  ( If yes i'am opening $EDITOR for you. )"
read PACMAN
if
        [[ $PACMAN == "y" || $PACMAN == "Y" ]]; then
        print "#[multilib]
                    #Include = /etc/pacman.d/mirrorlist
                    Just delete the # char
                    Find it around line 91 and 92"
        read -p "Press any key to edit" c
        $EDITOR /etc/pacman.conf
else
       echo "Moveing on....."
       sleep 1
fi
pacman -Syy

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
clear
lsblk
Echo "If you don't want to use some of the offered drives for any reason, just press enter and leave it blank'"
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
read -p "Enter the name of the HOME partition (eg. sda3): " sda3

# ------------------------------------------------------
# In case of ext4
# ------------------------------------------------------
# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------

echo "Do you want to format the drives?  (  y or n )"
read DRIVES
if
        [[ $DRIVES == "y" || $DRIVES == "Y" ]]; then
        mkfs.fat -F 32 /dev/$SDA1
        mkfs.ext4 -L Arch-Root /dev/$SDA2
        mkfs.ext4 -L Home /dev/$SDA3
else
       echo "Moveing on....."
       sleep 1
fi

#-------------------------------------------------------
# Mount points for ext4
# ------------------------------------------------------
mount -o defaults,noatime /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home}
mount -o defaults,noatime /dev/$sda3 /mnt/home
mount -o defaults,noatime /dev/$sda1 /mnt/boot/efi

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
#mount /dev/$sda2 /mnt
#btrfs su cr /mnt/@
#btrfs su cr /mnt/@cache
#btrfs su cr /mnt/@home
#btrfs su cr /mnt/@snapshots
#btrfs su cr /mnt/@log
#umount /mnt

#mount -o compress=zstd:1,noatime,subvol=@ /dev/$sda2 /mnt
#mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
#mount -o compress=zstd:3,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
#mount -o compress=zstd:3,noatime,subvol=@home /dev/$sda2 /mnt/home
#mount -o compress=zstd:3,noatime,subvol=@log /dev/$sda2 /mnt/var/log
#mount -o compress=zstd:3,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots

#mount /dev/$sda1 /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
lscpu | grep "Vendor"
echo "What type of CPU you have?  (  Please press " A/a " for AMD or  "I / i"  for INTEL)"
read CPU
if
        [[ $CPU == "a" || $FSTAB == "A" ]]; then
        pacstrap -K /mnt base base-devel git linux linux-headers linux-firmware micro openssh reflector rsync amd-ucode
else
        pacstrap -K /mnt base base-devel git linux linux-headers linux-firmware micro openssh reflector rsync intel-ucode
fi
EDITOR=micro
# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo "Just look what have you made me done......"
echo "Is This ok?  (  y or n )  ( If not i'am opening $EDITOR for you. )"
read FSTAB
if
        [[ $FSTAB == "y" || $FSTAB == "Y" ]]; then
        echo "Cool! :) "
        sleep 1
else
        $EDITOR /mnt/etc/fstab
fi
# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/
cp 5-timeshift.sh /mnt/archinstall/
cp 6-preload.sh /mnt/archinstall/
cp 7-kvm.sh /mnt/archinstall/
cp snapshot.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh
