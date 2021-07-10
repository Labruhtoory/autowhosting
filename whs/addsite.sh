#!/bin/bash
clear
###############################    Service & User init    ##############################
echo "What is the name of the site that you want to add?"
echo "*Replace spaces with _ "
read -p "Enter name here: " sitename
read -p "What is your mysql root passwd?: " mysqlpass
read -p "Would you like to use ssl? y/n> " sslans
##############################    Nginx config    ##############################
echo "Editing nginx config....."
if [ $sslans == "n" ];
then
  rm -rf /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
  cp template/http.conf /etc/nginx/conf.d/$sitename
  sed -i "s+root /var/www/html+root /var/www/$sitename+gi" /etc/nginx/conf.d/$sitename
  systemctl restart nginx
else
  (copy https templates)
  (setup certbot)
  chmod +x sslgen.sh
  ./sslgen.sh
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
