#!/bin/bash

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install python-certbot-nginx

sudo certbot --nginx
sudo systemctl restart nginx

echo " don't forget to add a cron job 'sudo certbot renew'"
