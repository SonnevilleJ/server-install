#!/bin/bash

sudo apt update
sudo apt dist-upgrade
sudo apt autoremove

./git/install.sh
./unattended-upgrades/install.sh

