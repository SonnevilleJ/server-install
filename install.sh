#!/bin/bash

sudo apt update
sudo apt dist-upgrade -y
sudo apt autoremove -y

./git/install.sh
./unattended-upgrades/install.sh

