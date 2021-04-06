#!/bin/bash
mkdir -p /etc/ssl/private
chmod 0750 /etc/ssl/private

openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/serv.key -x509 -days 1825 -out /etc/ssl/certs/serv.crt -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX/emailAdress=X@X.lan"


chmod 0400 /etc/ssl/certs/serv.crt
chmod 0400 /etc/ssl/private/serv.key

touch /etc/nginx/conf.d/serv.conf 
touch /etc/nginx/conf.d/serv-ssl.conf

echo "see confs for creating config files"
