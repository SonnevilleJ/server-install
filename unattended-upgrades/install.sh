#!/bin/bash

sudo apt update
sudo apt install unattended-upgrades

echo "Configuring unattended-upgrades..."

echo "Gmail password is required. What password should I use?"
read password
sudo cp .mailrc /root/.mailrc
sudo sed -e "s/SECRET/${password}/" /root/.mailrc
sudo chown root:root /root/.mailrc
sudo chmod 400 /root/.mailrc

sudo cp 50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
sudo chown root:root /etc/apt/apt.conf.d/50unattended-upgrades

echo "SUCCESS: Unattended upgrades complete!"

