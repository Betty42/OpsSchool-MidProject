#!/usr/bin/env bash

sudo -i

# Install apache webserver
apt-get update
apt --assume-yes install apache2
systemctl start apache2.service

# Install Jenkins
sudo apt-get update -y
sudo apt-get install -y default-jre

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

tee /etc/consul.d/jenkins.json > /dev/null <<EOF
{
  "service":
  {"name": "jenkins",
   "tags": ["jenkins-ci"],
   "port": 8080,
   "checks": {
     "name": "jenkins 8080 port check",
     "http": "http://localhost:8080",
     "interval": "20s"
    }
  }
}
EOF

consul reload
