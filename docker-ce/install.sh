#!/bin/bash

echo "Uninstalling current Docker (if found)"
sudo apt remove docker docker-engine docker.io

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adding Docker key for apt"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt install -y docker-ce

echo "Docker installed successfully!"

