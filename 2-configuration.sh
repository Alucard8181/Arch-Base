#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# By Tuxacard (2023)
#
# ------------------------------------------------------
pause 2
clear
KEYBOARDLAYOUT="hu"
ZONEINFO="Europe/Budapest"
read -p "What will be the host name?" HOSTNAME1
HOSTNAME="$HOSTNAME1"
read -p "What will be the user name?" USERNAME1
USERNAME="$USERNAME1"

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$ZONEINFO /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Installing and setting up reflector..."
pacman --noconfirm -S reflector
reflector -c Hungary -p https -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i '/ParallelDownloads = 10/a\ILoveCandy' /etc/pacman.conf
sed -i 's/#\[multilib]/\[multilib]/g' /etc/pacman.conf
sed -i '/\[multilib]/a\Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf
# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------

pacman --noconfirm -S grub efibootmgr xdg-desktop-portal-wlr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez blueman bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call dnsmasq openbsd-netcat ipset ufw flatpak nss-mdns acpid os-prober ntfs-3g terminus-font ttf-jetbrains-mono-nerd htop mc haruna zip unzip neofetch duf pacman-contrib inxi yt-dlp micro tldr man-db xf86-video-amdgpu

# ------------------------------------------------------
# Packages List
# ------------------------------------------------------
# grub	                                     GNU GRand Unified Bootloader (2)
# efibootmgr                          Linux user-space application to modify the EFI Boot Manager
# xdg-desktop-portal-wlr    xdg-desktop-portal backend for wlroots
# networkmanager                Network connection manager and user applications
# network-manager-applet	Applet for managing network connections
# dialog					A tool to display dialog boxes from shell scripts
# wpa_supplicant			A utility providing key negotiation for WPA wireless networks
# mtools					A collection of utilities to access MS-DOS disks
# dosfstools				DOS filesystem utilities
# avahi						Service Discovery for Linux using mDNS/DNS-SD (compatible with Bonjour)
# xdg-user-dirs				Manage user directories like ~/Desktop and ~/Music
# xdg-utils					Command line tools that assist applications with a variety of desktop integration tasks
# gvfs						Virtual filesystem implementation for GIO
# gvfs-smb					Virtual filesystem implementation for GIO (SMB/CIFS backend; Windows client)
# nfs-utils					Support programs for Network File Systems
# inetutils					A collection of common network programs
# dnsutils	(bind)			A complete, highly portable implementation of the DNS protocol
# bluez						Daemons for the bluetooth protocol stack
# blueman					GTK+ Bluetooth Manager
# bluez-utils				Development and debugging utilities for the bluetooth protocol stack
# alsa-utils				Advanced Linux Sound Architecture - Utilities
# pipewire					Low-latency audio/video router and processor
# pipewire-alsa				Low-latency audio/video router and processor - ALSA configuration
# pipewire-pulse			Low-latency audio/video router and processor - PulseAudio replacement
# pipewire-jack				Low-latency audio/video router and processor - JACK replacement
# bash-completion			Programmable completion for the bash shell
# openssh					SSH protocol implementation for remote login, command execution and file transfer
# rsync						A fast and versatile file copying tool for remote and local files
# acpi 						Client for battery, power, and thermal readings
# acpi_call					A linux kernel module that enables calls to ACPI methods through /proc/acpi/call
# dnsmasq					Lightweight, easy to configure DNS forwarder and DHCP server
# openbsd-netcat			TCP/IP swiss army knife. OpenBSD variant.
# ipset						Administration tool for IP sets
# ufw						Uncomplicated and easy to use CLI tool for managing a netfilter firewall
# flatpak					Linux application sandboxing and distribution framework (formerly xdg-app)
# nss-mdns					glibc plugin providing host name resolution via mDNS				 
# acpid						A daemon for delivering ACPI power management events with netlink support
# os-prober					Utility to detect other OSes on a set of drives
# ntfs-3g					NTFS filesystem driver and utilities
# terminus-font				Monospace bitmap font (for X11 and console)
# htop						Interactive process viewer
# mc						A file manager that emulates Norton Commander
# haruna					Video player built with Qt/QML on top of libmpv
# zip						Compressor/archiver for creating and modifying zipfiles
# unzip						For extracting and viewing files in .zip archives
# neofetch					A CLI system information tool written in BASH that supports displaying images.
# neofetch                (On Acrh Linux based sysems, even the kernel refuses to operate without this package)
# duf						Disk Usage/Free Utility
# pacman-contrib			Contributed scripts and tools for pacman systems
# inxi						Full featured CLI system information tool 	2023-11-02 	
# yt-dlp					A youtube-dl fork with additional features and fixes
# micro					 	Modern and intuitive terminal-based text editor
# tldr						Command line client for tldr, a collection of simplified and community-driven man pages.
# zsh						A very advanced and programmable command interpreter (shell) for UNIX
# zsh-completions			Additional completion definitions for Zsh
# xf86-video-amdgpu			X.org amdgpu video driver
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
echo "Adding user $USERNAME"
useradd -m -G wheel $USERNAME
passwd $USERNAME

# ------------------------------------------------------
# Enable System Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
#systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable ufw
systemctl enable acpid

sudo ufw enable

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
#sed -i 's/BINARIES=()/BINARIES=(setfont)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 108):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Opening sudoers now." c
EDITOR=micro sudo -E visudo
usermod -aG wheel $USERNAME

cp /archinstall/* /home/$USERNAME

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "Afther reboot please find the following additional installation scripts in /archinstall directory. Start Last-steps.sh to finish the install"
