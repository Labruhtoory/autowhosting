#!/bin/bash
#init
clear
echo "Take this time to review your system's state....."
echo "EX: Is it a fresh install? Are all services in acceptable default, 'factory' settings?"
echo "Press 'Ctrl + c' twice to cancel if needed, or 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done
##############################  Initial comments  ##############################
clear
echo "*Quick note, say yes to and fill out all services' prompts. It just makes the process easier :)"
echo ""
echo "Before you begin, make sure that you keep track of your credentials that you setup....."
echo "Keep in mind, you will need to supply your own credentials and information for the following services:"
echo ""
echo "MariaDB (MySQL):"
echo "  > Your system/server root account password for creating and configuring the root database account"
echo "  > A username to create a new user for accessing the new wordpress database"
echo "  > A password for this new user"
echo ""
echo ""
echo "CertBot (SSL cert&key generator):"
echo "  > A valid email address in case verification is needed"
echo "  > A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com"
echo ""
echo ""
echo ""
echo ""
echo "You will also need to edit certain files. To make this easier, you will be provided instructions when needed."
echo ""
echo ""
echo "Press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done
clear
##############################   Networking   ##############################
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
##############################   Init Installs    ##############################
echo "Installing packages....."
sudo apt update && sudo apt install -fy speedtest-cli htop nginx software-properties-common python-certbot-nginx mariadb-server mongodb-server build-essential python python3 python3-pip golang openssl
sudo python3 -m pip install --upgrade pip
sudo apt remove -fy apache2 apache2-utils apache2-data
curl -sL https://deb.nodesource.com/setup_12.x | bash -
sudo apt install -fy nodejs
npm install -g node-gyp
go get github.com/gorilla/websocket
clear
##############################    DB DataDrive Setup ##############################
echo "Setting up initial database drive....."
echo "Please insert a drive with the desired (EMPTY) partition to use....."
lsblk | grep "disk\|part"
echo "Have you plugged in a device? If not, now is the time to do it....."
echo "Press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done
clear
lsblk | grep "disk\|part"
read -p "What is the new partition to mount? (EX: sda1, sda2, sdb1 etc.....): " answ
mkfs.ext4 /dev/$answ
echo "mounting $answ"
sudo mkdir /dbs
sudo mount /dev/$answ /dbs
echo "/dev/$answ        /dbs        ext4    defaults      0      0" >> /etc/fstab
echo "Ok, /dev/$answ with ext4 filsystem is prepped for mounting on boot"
clear
##############################    MariaDB (MySQL) for Wordpress Install & Data Migration   ##############################
echo "Migrating MariaDB data to mounted disk....."
sudo systemctl stop mariadb
sudo rsync -rltDvz /var/lib/mysql /dbs
sudo chown -R mysql:mysql /dbs/mysql 
mv /var/lib/mysql /var/lib/mysql.bak
sudo grep -R --color datadir /etc/mysql/*
cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bak
sed -i "s+/var/lib/mysql+/dbs/mysql+gi" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo grep -R --color datadir /etc/mysql/*
sudo systemctl start mariadb
clear
echo "Make sure you know your root user passwd, if you dont, then run 'sudo passwd root' in a separate terminal"
sudo mysql_secure_installation
ln -s /dbs/mysql /var/www/
echo "created sybolic link folder for database drive $answ in /var/www"
echo "Mounted $answ to /dbs and migrated MariaDB data"
clear
##############################    MongoDB (NoSQL) Install & Data Migration   ##############################
echo "Migrating Mongodb data to mounted disk....."
sudo systemctl stop mongodb
sudo rsync -rltDvz /var/lib/mongodb /dbs
sudo chown mongodb:mongodb -R /dbs/mongodb/
mv /var/lib/mongodb /var/lib/mongodb.bak
cat /etc/mongodb.conf | grep --color dbpath
cp /etc/mongodb.conf /etc/mongodb.conf.bak
sed -i "s+/var/lib/mongodb+/dbs/mongodb+gi" /etc/mongodb.conf
cat /etc/mongodb.conf | grep --color dbpath
sudo systemctl start mongodb
ln -s /dbs/mysql /var/www/
clear
##############################    SSL Cert and Key Gen    ##############################
#ssl certbot
echo "Installing CertBot....."
read -p "What domain name would you like to use for your website?> " domain
sed -i "s+server_name _;+server_name $domain;+gi" /etc/nginx/conf.d/default.conf
mv setup_serv/template/www.conf /etc/php/7.3/fpm/pool.d/
systemctl restart nginx
systemctl restart php7.3-fpm
clear
echo "In a separate terminal, run the following....."
echo ""
echo "sudo certbot --nginx"
echo ""
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
###############################    Service & User init    ##############################
echo "Installing more packages....."
apt install libphp-embed libperl-dev python-dev ruby-dev default-jdk libssl-dev libpcre2-dev phppgadmin unzip zip php7.3 libphp7.3-embed php7.3-bcmath php7.3-bz2 php7.3-cli php7.3-common php7.3-curl php7.3-dba php7.3-dev php7.3-enchant php7.3-fpm php7.3-gd php7.3-gmp php7.3-imap php7.3-imagick php7.3-interbase php7.3-intl php7.3-json php7.3-ldap php7.3-mbstring php7.3-mysql php7.3-odbc php7.3-opcache php7.3-pgsql php7.3-phpdbg php7.3-pspell php7.3-readline php7.3-recode php7.3-snmp php7.3-soap php7.3-sybase php7.3-tidy php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-zip
sudo systemctl start nginx php7.3-fpm monit && sudo systemctl enable mysql nginx php7.3-fpm monit
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
echo "Seting up new user for website management....."
adduser -m wordy
mkdir -p /home/wordy/logs
chown wordy:www-data /home/wordy/logs/
rm /etc/nginx/sites-enabled/default
rm /etc/php/7.3/fpm/pool.d/www.conf
sudo -u wordy touch /home/wordy/logs/phpfpm_error.log
clear
echo "Setting up mysql....."
echo "Make a new or duplicate root passwd and answer Y to the following prompts....."
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
##############################    Xtra Free Vpn and Dnsleaktest(Optional)    ##############################
cd /opt/
echo "Getting a free vpn config file from vpnbook.com/freevpm....."
sudo wget --no-check-certificate https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-US2.zip
unzip VPNBook.com-OpenVPN-US2.zip
sudo rm -rf VPNBook.com-OpenVPN-US2.zip vpnbook-us2-tcp80.ovpn vpnbook-us2-tcp443.ovpn vpnbook-us2-udp53.ovpn 
clear
echo "installing a dns leak test, run by commad 'dnsleaktest'"
git clone https://github.com/macvk/dnsleaktest.git
go build -o /usr/bin/dnsleaktest dnsleaktest/dnsleaktest.go
chmod 755 /usr/bin/dnsleaktest
rm -rf dnsleaktest/
clear
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
