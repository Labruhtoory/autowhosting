#!/bin/bash
clear
###############################    Service & User init    ##############################
read -p "What is the name of you site?: " sitename
read -p "What is the full domain of you site?: " domain
read -p "What is your mysql root passwd?: " mysqlpass
read -p "Would you like to use ssl? y/n> " sslans
##############################    Nginx config    ##############################
echo "Editing nginx config....."
if [ $sslans == "y" ];
then
  rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
  cp template/https.conf /etc/nginx/sites-enabled/$domain
  echo "Installing CertBot....."
  sudo apt install -fy python-certbot-nginx
  clear
  echo "In a separate terminal, run the following....."
  echo ""
  echo "sudo certbot --nginx"
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
  systemctl restart nginx
else
  rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
  cp template/http.conf /etc/nginx/sites-enabled/$domain
  sed -i "s+/var/www+/var/www/$sitename+gi" /etc/nginx/sites-enabled/$domain
  systemctl restart nginx
fi
##############################    MariaDB config    ##############################
echo "Setting up new website database....."
mysql -u root -p$mysqlpass -e "CREATE DATABASE $sitename;"
##############################    Wordpress Site Init Install, Setup, and Config    ##############################
echo "Setting up wordpress....."
cd /var/www
echo "Downloading zip..."
wget https://wordpress.org/latest.tar.gz &> /dev/null
echo "Extracting zip..."
tar zxvf latest.tar.gz &> /dev/null
echo "Configuring zip..."
rm -rf latest.tar.gz
mv wordpress $sitename
mv $sitename/wp-config-sample.php $sitename/wp-config.php
sed -i "s/database_name_here/$sitename/gi" $sitename/wp-config.php
sed -i "s/username_here/root/gi" $sitename/wp-config.php
sed -i "s/password_here/$mysqlpass/gi" $sitename/wp-config.php
chown -R www-data:www-data $sitename
systemctl restart php7.3-fpm
systemctl restart nginx
clear
echo "Wordpress installed and configured for port 80"
echo "Important info for MariaDB:"
echo "New DB name: $sitename"
echo "DB user: root"
echo "DB pass: $mysqlpass"
echo ""
echo "Done with setup!"
echo "To add ssl, run the addssl script."
