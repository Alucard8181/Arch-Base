#!/bin/bash
#https://github.com/Alucard8181/Arch-Base
loadkeys hu
setfont ter-v18n
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "By Tuxacard (2023)"
echo "Forked from Stephan Raabe-s work"
echo ""
echo "-----------------------------------------------------"
echo "Take care the partitions first !"
echo "-----------------------------------------------------"
echo ""
echo "Warning: Run this script at your own risk."

# # Maybe it's required to install the current archlinux keyring
# if the installation of git fails. Uncomment if needed.
#pacman -S archlinux-keyring
#pacman -Syy

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
#timedatectl list-timezones | grep Bud
timedatectl set-timezone Europe/Budapest
reflector -c Hungary -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Sy

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
clear
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
read -p "Enter the name of the HOME partition (eg. sda3): " sda3
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3


# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
#mkfs.fat -F 32 /dev/$sda1
#mkfs.ext4 -L Arch-root /dev/$sda2
#mkfs.ext4 -L home /dev/$sda3
#mkfs.btrfs -f /dev/$sda2
#mkfs.btrfs -f /dev/$sda3

---------------------------------------------------------

mount /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home}
mount -t ext4 -o defaults,noatime /dev/$sda3 /mnt/home
mount /dev/$sda1 /mnt/boot/efi
#mount -o compress=zstd:3,ssd,noatime,subvol=@ /dev/$sda2 /mnt
#mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log}}
#mount -o compress=zstd:3,ssd,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
#mount -o compress=zstd:3,ssd,noatime,subvol=@home /dev/$sda2 /mnt/home
#mount -o compress=zstd:3,ssd,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
#mount -o compress=zstd:3,ssd,noatime,subvol=@log /dev/$sda2 /mnt/var/log
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm
---------------------------------------------------------


# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel git linux linux-firmware linux-zen linux-zen-headers micro openssh reflector rsync amd-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
echo 'tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0' >> /mnt/etc/fstab
cat /mnt/etc/fstab
read -p "I hope this is right......" c

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
#arch-chroot /mnt ./archinstall/2-configuration.sh
arch-chroot /mnt
./archinstall/2-configuration.sh
