#!/bin/bash
###############################    Service & User init    ##############################
echo "What is the name of the site that you want to add?"
echo "*Replace spaces with _ "
read -p "Enter name here: " sitename
read -p "What is your mysql root passwd?: " mysqlpass
read -p "Would you like to use ssl? y/n> " ans
if [ $ans == "n" ];
then
  (copy http templates)
else
  (copy https templates)
  (setup certbot)
  chmod +x sslgen.sh
  ./sslgen.sh
  


##############################    Wordpress Site Init Install, Setup, and Config    ##############################
echo "Editing Templates....."
cp template/new_site.conf /etc/nginx/sites-available/$sitename
sed -i "s+root /var/www/html+root /var/www/$sitename+gi" /etc/nginx/sites-available/$sitename
rm /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/$sitename /etc/nginx/sites-enabled/$sitename
clear
echo "Setting up new website database....."
mysql -u root -p$mysqlpass -e "CREATE DATABASE $sitename;"
clear
echo "Getting wordpress....."
cd /tmp
mkdir /var/www/$sitename
wget https://wordpress.org/latest.tar.gz
tar zxvf /home/wordy/new_site/latest.tar.gz
rm latest.tar.gz
mv wordpress /var/www/$sitename
cd /var/www/
mv $sitename/wp-config-sample.php $sitename/wp-config.php
chown -R www-data:www-data /var/www/$sitename
systemctl restart php7.3-fpm
systemctl restart nginx
clear
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
