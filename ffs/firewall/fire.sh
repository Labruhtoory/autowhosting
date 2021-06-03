#!/bin/bash
clear
echo "Resetting UFW..."
sudo ufw reset

# server maintenence

clone
echo "Allowing Server Maintenence..."
sudo ufw allow ssh

# make ports available to be used for server apps

clone
echo "Making 10 ports avalible for misc server apps..."
sudo ufw allow 8000:8010/tcp
sudo ufw allow 8000:8010/udp

# manage web requests

clone
echo "Allowing standard http+..."
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on eth0 to any port 443
sudo ufw allow in on eth0 to any port 8080

sudo ufw allow out on eth0 to any port 80
sudo ufw allow out on eth0 to any port 443
sudo ufw allow out on eth0 to any port 8080

# full send

clone
echo "Starting Firewall..."
sudo ufw enable
echo "Done!!!"