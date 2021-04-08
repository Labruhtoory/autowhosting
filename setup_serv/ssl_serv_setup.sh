#!/bin/bash

echo 'moving to /opt'
#init
cd /opt 

#networking
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf

sudo apt install -fy python python3 python3-pip golang speedtest-cli htop nginx 
sudo python3 -m pip install --upgrade pip

#basic vpn
sudo wget --no-check-certificate https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-US2.zip
unzip VPNBook.com-OpenVPN-US2.zip
sudo rm -rf VPNBook.com-OpenVPN-US2.zip vpnbook-us2-tcp80.ovpn vpnbook-us2-tcp443.ovpn vpnbook-us2-udp53.ovpn 

#certbot
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx

sudo certbot --nginx
sudo systemctl restart nginx

echo " don't forget to add a cron job 'sudo certbot renew'"
echo "crontab -e"
echo "0 0   1 * * sudo certbot renew"
echo ""
echo ""
echo ""
echo ""
echo "Also dont forget to make services for server apps!"
echo "see service template"
echo "Done!"
