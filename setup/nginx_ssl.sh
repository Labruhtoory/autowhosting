#!/bin/bash
#run on boot
systemctl enable nginx

#generate cert
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

#generate  Diffie-hellman group for server
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

#snippet for ssl-key and cert
touch /etc/nginx/snippets/self-signed.conf
echo"ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;" >> /etc/nginx/snippets/self-signed.conf 
echo"ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" >> /etc/nginx/snippets/self-signed.conf 

#ssl parameters (Strong Cert)
cp /opt/Web_Host_Standalone_Server/setup/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

#clear out defaults
rm -rf /etc/sites-available/* /etc/nginx/sites-enabled/* /var/www/html/*
    
#make new server config
touch /etc/nginx/sites-available/tut
mkdir /var/www/tut/html
cp /opt/Web_Host_Standalone_Server/setup/ssl_server_template /etc/nginx/sites-available/tut

#symbolic link
ln -s /etc/nginx/sites-available/tut /etc/nginx/sites-enabled/

#firewall rules
sudo ufw delete allow 'Nginx HTTP'
sudo ufw allow 'Nginx Full'

sudo systemctl restart nginx
