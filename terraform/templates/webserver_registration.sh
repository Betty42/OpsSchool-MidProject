#!/usr/bin/env bash

sudo -i

# Install apache webserver
apt-get update
apt --assume-yes install apache2
systemctl start apache2.service

tee /etc/consul.d/webserver.json > /dev/null <<EOF
{
  "service":
  {"name": "webserver",
   "tags": ["apache"],
   "port": 80,
   "check": {
     "name": "port 80 tcp check",
     "TCP": "localhost:80",
     "interval": "20s"
    }
  }
}
EOF

consul reload
