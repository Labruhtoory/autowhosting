#!/bin/bash

##############################    Init Installs   ##############################
apt update && apt install -fy nginx ufw


##############################    VPN Server Setup   ##############################
echo "Setting up vpn server"
chmod +x vpn/pivpn.sh && ./vpn/pivpn.sh
