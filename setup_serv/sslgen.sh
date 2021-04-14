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
read -p "What is the domain of your new website?> " domain
sed -i "s+server_name _;+server_name $domain;+gi" /etc/nginx/sites-available/default.conf

clear
echo "In a separate terminal, run the following....."
echo ""
echo "sudo certbot --nginx -d $domain"
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
