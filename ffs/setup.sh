#!/bin/bash

clear
echo "Take this time to review your system's state....."
echo "EX: Is it a fresh install? Are all services in acceptable default, 'factory' settings?"
echo "Press 'Ctrl + c' twice to cancel if needed, or 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
	echo ""
printf "Ok then, moving on....."
break
fi
done
clear
##############################    Install Packages   ##############################
echo "Getting things up to date..."
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sudo apt update &> /dev/null
sudo apt install -fy nginx ufw &> /dev/null
sudo systemctl start nginx
sudo systemctl enable nginx
clear
##############################    Firewall Setup   ##############################
echo "Setting up the firewall"
chmod +x firewall/fire.sh && ./firewall/fire.sh
clear
echo "Done!!!"
##############################    VPN Server Setup   ##############################
echo "Setting up vpn server"
chmod +x vpn/pivpn.sh && ./vpn/pivpn.sh
clear
##############################    Nginx Setup   ##############################
echo "Setting up nginx"
chmod +x nginx/ng.sh && ./nginx/ng.sh
clear