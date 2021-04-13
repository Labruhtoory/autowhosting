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
read -p "What is the domain of your website?> " domain
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
