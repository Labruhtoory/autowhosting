#!/bin/bash
mkdir -p /etc/ssl/private
chmod 0750 /etc/ssl/private

openssl req -newkey rsa:2048 -nodes -keyout /etc/ssl/private/serv.key -x509 -days 1825 -out /etc/ssl/certs/serv.crt -subj "/C=XX/ST=XX/L=XX/O=XX/OU=XX/CN=XX/emailAddress=X@X.lan"


chmod 0400 /etc/ssl/certs/serv.crt
chmod 0400 /etc/ssl/private/serv.key

touch /etc/nginx/conf.d/serv.conf 
touch /etc/nginx/conf.d/serv-ssl.conf

cp /opt/Web_Host_Standalone_Server/setup/confs/serv.conf /etc/nginx/conf.d/serv.conf
cp /opt/Web_Host_Standalone_Server/setup/confs/ssl-serv.conf /etc/nginx/conf.d/ssl-serv.conf

echo "see /etc/nginx/conf.d for editing configuration files"
