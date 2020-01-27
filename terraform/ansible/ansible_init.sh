#!/bin/bash
sleep 30
sudo apt-get update
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:ansible/ansible
sudo apt-get update
echo 'Installing Ansible'
sudo apt-get -y install ansible