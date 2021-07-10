#!/bin/bash
##############################    SSL Cert and Key Gen    ##############################
echo "Would you like to setup SSL?"
echo "Press 'Ctrl +c' to cancel, or 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done
#ssl certbot
echo "Installing CertBot....."
sudo apt install -fy python-certbot-nginx ufw &> /dev/null
sudo ufw allow 'Nginx Full'
read -p "What is the domain of your new website?> " domain
sed -i "s+server_name _;+server_name $domain;+gi" /etc/nginx/sites-available/default.conf

clear
echo "In a separate terminal, run the following....."
echo ""
echo "sudo certbot --nginx -d $domain -d www.$domain.com"
echo ""
echo "Once done, copy down the cert (fullchain.pem) location, and the key (privkey.pem) location....."
echo "press c to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
echo ""
printf "Ok then, moving on....."
break
fi
done
clear
echo "Don't forget to make sure there is a cron job for renewing ssl certs"
echo "check by running 'crontab -e'"
echo "If you do not see the line below this one, make sure to copy:"
echo "0 0   1 * * sudo certbot renew"
echo ""
echo ""
echo "Dont forget to create services for server apps!"
echo ""
echo ""
echo ""
echo ""
echo "Check credentials for the vpn at: https://www.vpnbook.com/freevpn"
echo "Check under: Free OpenVPN"
echo "Run the vpn with 'sudo openvpn vpnconfigfilehere' ....."
echo ""
echo ""
echo ""
echo "Done!"
##############################    Closing Comments   ##############################
echo "Don't forget to check to see if there is a cron job for 'sudo certbot renew'"
echo "Check by running 'crontab -e'"
echo ""
echo "If there is not a cron job, run the above command and type the following on a new line: "
echo "0 0   1 * * sudo certbot renew"
echo ""
echo "After that, make sure to save the edit....."
echo ""
echo ""
echo "Dont forget to create services for any server apps that you want to run!"
echo ""
echo ""
echo "Done!"
