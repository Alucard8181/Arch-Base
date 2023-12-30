#!/bin/bash

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd ..
rm -rf ./yay-bin

yay --noconfirm -S zram-generator

sudo touch /etc/systemd/zram-generator.conf
sudo bash -c 'echo "[zram0]" >> /etc/systemd/zram-generator.conf'
sudo bash -c 'echo "zram-size = ram / 2" >> /etc/systemd/zram-generator.conf'
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

yay --noconfirm -S timeshift
sudo mv snapshot.sh /usr/local/bin/

# echo 'alias tsc="snapshot.sh' >> ~/.bash.rc

rm 2-configuration.sh

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "kvm and preload install script can be found at ~/"
