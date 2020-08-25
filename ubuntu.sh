#--------------------------------------------
#
# Script for configure Ubuntu
#
#-------------------------------------------
#
# Made by Artem Listopad
#
# just another comment line
#-------------------------------------------


#!/bin/bash


USERCOMP_NAME="comp065"
#USERCOMP_PASSWORD="12345678"
SADM_PASSWORD="87654321"
NICKNAME="testmachine"


# set hostname
hostnamectl set-hostname $USERCOMP_NAME

# set journald mode to persistent
sudo sed -i 's/#Storage=auto/Storage=persistent/' /etc/systemd/journald.conf

# set hibernation at power button and lid switch
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=hibernate/' /etc/systemd/logind.conf
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=hibernate/' /etc/systemd/logind.conf

# create sadm user and add him to sudo group
sudo useradd -p $(openssl passwd -1 $SADM_PASSWORD) sadm
sudo usermod -aG sudo sadm

# install and configure salt
sudo apt -y install salt-minion
sudo sed -i 's/#master: salt/master: sm.fwtg.pp.ua/' /etc/salt/minion
sudo sed -i "s/#id:/id: $USERCOMP_NAME/" /etc/salt/minion
sudo touch /etc/salt/nickname
sudo chmod o+w /etc/salt/nickname
echo $NICKNAME > /etc/salt/nickname

# install software
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo apt install -y teamviewer_amd64.deb

sudo snap install slack --classic
sudo apt install -y openvpn
sudo apt install -y network-manager-openvpn-gnome
sudo apt install -y apt-transport-https
sudo apt install -y ca-certificates
sudo apt install -y curl
sudo apt install -y gnupg-agent
sudo apt install -y software-properties-common
sudo apt install -y lm-sensors


# install and configure telegraf
sudo dpkg -i telegraf_1.14.3-1_amd64.deb
sudo cp telegraf.service /lib/systemd/system/
sudo cp telegraf.conf /etc/telegraf/
sudo cp utmi.sh /etc/telegraf/
sudo cp utct.sh /etc/telegraf/

# set timezone
sudo timedatectl set-timezone Europe/Kiev
