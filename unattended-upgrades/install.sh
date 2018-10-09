#!/bin/bash

echo ""
echo "********************     Configuring unattended-upgrades     ********************"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Configuring apt repositories..."
if [ ! -f /etc/apt/sources.list.original ]; then
	sudo cp -n /etc/apt/sources.list /etc/apt/sources.list.original
	sudo chmod 400 /etc/apt/sources.list.original
fi
sudo cp ${DIR}/sources.list /etc/apt/sources.list
sudo chown root:root /etc/apt/sources.list
sudo apt update

echo "Configuring unattended-upgrades..."
sudo apt install unattended-upgrades -y
if [ ! -f /etc/apt/apt.conf.d/50unattended-upgrades.original ]; then
	sudo cp -n /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades.original
	sudo chmod 400 /etc/apt/apt.conf.d/50unattended-upgrades.original
fi
sudo cp ${DIR}/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
sudo chown root:root /etc/apt/apt.conf.d/50unattended-upgrades

echo "Configuring mailx..."
sudo apt install msmtp msmtp-mta bsd-mailx -y
sudo cp ${DIR}/.msmtprc /root/.msmtprc
sudo chown root:root /root/.msmtprc
sudo chmod 600 /root/.msmtprc
echo "Gmail username is required. What username should I use?"
read username
echo "Gmail password is required. What password should I use?"
read password
sudo sed -i "s/GMAIL_USERNAME/${username}/" /root/.msmtprc
sudo sed -i "s/GMAIL_PASSWORD/${password}/" /root/.msmtprc

echo "SUCCESS: Unattended upgrades complete!"

