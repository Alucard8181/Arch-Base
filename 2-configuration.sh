#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# By Tuxacard (2023)
# Forfked from Stephan Raabe-s work
# ------------------------------------------------------
pause 2
clear
KEYBOARDLAYOUT="hu"
ZONEINFO="Europe/Budapest"
HOSTNAME="Arch-Linux"
USERNAME="alucard"

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$ZONEINFO /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Start reflector..."
pacman --noconfirm -S reflector
reflector -c Hungary -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S grub efibootmgr xdg-desktop-portal-wlr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers linux-zen linux-zen-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez blueman bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call dnsmasq openbsd-netcat ipset ufw flatpak nss-mdns acpid os-prober ntfs-3g terminus-font htop mc zip unzip neofetch duf pacman-contrib inxi sddm yt-dlp micro zsh zsh-completions xf86-video-amdgpu

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Set Keyboard
# ------------------------------------------------------
echo "FONT=ter-v18n" >> /etc/vconsole.conf
echo "KEYMAP=$KEYBOARDLAYOUT" >> /etc/vconsole.conf

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "$HOSTNAME" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts
clear

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
#echo "Set root password"
#passwd root

# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $USERNAME"
useradd -m -G wheel $USERNAME
passwd $USERNAME

# ------------------------------------------------------
# Enable System Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable ufw
systemctl enable acpid
systemctl enable sddm

# ------------------------------------------------------
# Enable System Timers
# ------------------------------------------------------
systemctl enable reflector.timer
systemctl enable fstrim.timer

# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------
# Add btrfs and setfont to mkinitcpio
# ------------------------------------------------------
# Before: BINARIES=()
# After:  BINARIES=(setfont)
sed -i 's/BINARIES=()/BINARIES=(setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 108):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=micro sudo -E visudo
usermod -aG wheel $USERNAME

# ------------------------------------------------------
# Copy installation scripts to home directory 
# ------------------------------------------------------
#cp /archinstall/3-yay.sh /home/$username
#cp /archinstall/4-zram.sh /home/$username
#cp /archinstall/5-timeshift.sh /home/$username
#cp /archinstall/6-preload.sh /home/$username
#cp /archinstall/snapshot.sh /home/$username

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "Please find the following additional installation scripts in your home directory:"
echo "- yay AUR helper: 3-yay.sh"
echo "- zram swap: 4-zram.sh"
echo "- timeshift snapshot tool: 5-timeshift.sh"
echo "- preload application cache: 6-preload.sh"
echo "- KVM Install script: 7-kvm.sh"
echo "Please exit & shutdown (shutdown -h now), remove the installation media and start again."
echo "Important: Activate WIFI after restart with nmtui."
