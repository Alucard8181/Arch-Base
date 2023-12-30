#!/bin/bash

sudo chown $USER:$USER Last-steps.sh kvm.sh preload.sh

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
echo "alias tsc='snapshot.sh'" >> ~/.bashrc

rm -f 2-configuration.sh
rm Last-steps.sh

echo "kvm and preload install script can be found at ~/"
echo "type source .bashrc if you want to use ts now.."
