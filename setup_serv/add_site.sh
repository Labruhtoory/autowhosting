#!/bin/bash
###############################    Service & User init    ##############################
read -p "Would you like to use ssl? y/n> " ans
if [ $ans == "n" ];
then
  (copy http templates)
else
  (copy https templates)
  
  
  
  
mv setup_serv/template/www.conf /etc/php/7.3/fpm/pool.d/
systemctl restart nginx
systemctl restart php7.3-fpm
sudo systemctl enable mysql nginx php7.3-fpm monit
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
mkdir -p /usr/share/nginx/cache/fcgi
nginx -t
systemctl restart nginx
mkdir /run/php-fpm
mv /etc/php/7.3/fpm/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf.bak
rm /etc/php/7.3/fpm/pool.d/www.conf
mv /etc/php/7.3/fpm/php.ini /etc/php/7.3/fpm/php.ini.bak
systemctl restart php7.3-fpm
clear
##############################    Wordpress Site Init Install, Setup, and Config    ##############################
echo "Copying Templates....."
mv setup_serv/template/new_site.conf /etc/nginx/conf.d/
sed -i "s/domain/$domain/gi" /etc/nginx/conf.d/new_site.conf
mv setup_serv/template/nginx.conf /etc/nginx/
mv setup_serv/template/php-fpm.conf /etc/php/7.3/fpm/
mv setup_serv/template/php.ini /etc/php/7.3/fpm/
mv setup_serv/template/poolserv.conf /etc/php/7.3/fpm/pool.d/
chown wordy:www-data /home/wordy/logs/
rm /etc/nginx/sites-enabled/default
rm /etc/php/7.3/fpm/pool.d/www.conf
sudo -u wordy touch /home/wordy/logs/phpfpm_error.log
clear
echo "Setting up mysql....."
echo "Make sure you know your root user passwd, if you dont, then run 'sudo passwd root' in a separate terminal"
echo "Answer Y to the following prompts....."
mysql_secure_installation
systemctl restart mysql
clear
echo "Setting up new website database....."
echo "login with your mysql passwd that is either your root account passwd, or the one you just set up....."
echo "after that, copy and execute the following queries....."
echo "CREATE DATABASE sitename;"
echo "CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'newpasswd';"
echo "GRANT ALL PRIVILEGES ON sitename.* TO newuser@localhost;"
echo "FLUSH PRIVILEGES;"
echo "EXIT"
mysql -u root -p
clear
echo "Getting wordpress....."
mkdir /home/wordy/new_site
wget https://wordpress.org/latest.tar.gz -O /home/wordy/new_site/latest.tar.gz
tar zxf /home/wordy/new_site/latest.tar.gz
rm latest.tar.gz
mv wordpress new_site
mv new_site/wp-config-sample.php new_site/wp-config.php
chown -R wordy:www-data /home/wordy/
cd /home/wordy
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;
systemctl restart php7.3-fpm
systemctl restart nginx
##############################    Closing Comments   ##############################
echo " don't forget to add a cron job 'sudo certbot renew'"
echo "crontab -e"
echo "0 0   1 * * sudo certbot renew"
echo ""
echo ""
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
echo "For more information on how to setup wordpress on nginx, visit: https://www.nginx.com/blog/installing-wordpress-with-nginx-unit/"
echo ""
echo ""
echo ""
echo ""
echo "Done!"
