#!/bin/bash
# __   __ _ __   __
# \ \ / // \\ \ / /
#  \ V // _ \\ V / 
#   | |/ ___ \| |  
#   |_/_/   \_\_|  
#                 
# By Tuxacard (2023)
# ------------------------------------------------------
# Install Script for Yay ( Pre-compiled. )
# ------------------------------------------------------
# Name: yay Install Script
# DESC: All required steps to install yay
# WARNING: Run this script at your own risk.

clear
echo "__   __ _ __   __"
echo "\ \ / // \\ \ / /"
echo " \ V // _ \\ V / "
echo "  | |/ ___ \| |  "
echo "  |_/_/   \_\_|  "
echo "                 "
echo ""

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf ./yay-bin
echo "DONE!"
