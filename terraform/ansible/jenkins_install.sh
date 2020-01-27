#!/bin/bash
set -exu

sudo apt-get update -y
sudo apt-get install -y default-jre

#### from here you need to modify it for centos ####

echo "* Import GPG key"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo add-apt-repository "deb https://pkg.jenkins.io/debian-stable binary/"
sudo apt-get update
sudo apt-get -y install jenkins
sudo apt-get -y install jq

echo "Tool for handling xml files"
sudo apt-get install xmlstarlet

echo "* Start Jenkins without asking to install plugins"
export JAVA_OPTS=-Djenkins.install.runSetupWizard=false

sudo service jenkins start

sudo wget http://localhost:8080/jnlpJars/jenkins-cli.jar -O /var/lib/jenkins/jenkins-cli.jar
ADMIN_PASSW=$(sudo bash -c "cat /var/lib/jenkins/secrets/initialAdminPassword")

