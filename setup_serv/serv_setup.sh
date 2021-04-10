#!/bin/bash

#networking
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf

sudo apt install -fy python python3 python3-pip golang speedtest-cli htop nginx mariadb-server
sudo python3 -m pip install --upgrade pip
echo "making some slight adjustments to nginx"
systemctl enable nginx && systemctl restart nginx
sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
mv serv-confs-defaults/wpdef-serv.conf /etc/nginx/conf.d
clear


#dbs and wordpress setup
echo "setting up initial database drive, database support, and support for wordpress....."
mv wordpress.config /opt/
cd /var/www/
mkdir /mnt/usbdb1
echo "Migrating MySQL drive....."
echo "Please insert a drive with only one empty partition....."
echo "Have you plugged in a usb device? If not, now is the time to do it....."
echo "Press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done
lsblk | grep "disk\|part"
echo -n "What is the new partition name to mount?"
read answ
echo "mounting $answ"
mount /dev/$answ /mnt/usbdb1/
mkdir /mnt/usbdb1/sysbase
sudo chown mysql:mysql /mnt/usbdb1/sysbase
sudo rsync -avzh /var/lib/mysql/ /mnt/usbdb1/sysbase
echo "Mounted $answ to /mnt/usbdb1"
ln -s /mnt/usbdb1/sysbase /var/www/
echo "created sybolic link folder for database drive $answ "

cd /var/www/usbdb1/
echo "setting up initial mysql wordpress database"
sudo mysql_secure_installation
clear
echo "Now enter your MYSQL root passwd in the prompt below."
echo "Run the folowing commands in the mysql> prompt: "
echo "CREATE DATABASE wordpress;"
echo "CREATE USER newuserhere IDENTIFIED BY 'newpasswordhere';"
echo "GRANT ALL PRIVILEGES ON wordpress.* TO newuserhere;"
echo "FLUSH PRIVILEGES;"
echo "EXIT"
sudo mysql -u root -p
clear

echo "Setting up wordpress"
cd /var/www/
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
rm -rf latest.tar.gz
mv /opt/wordpress.config /var/www/wordpress/
cd /var/www/wordpress
sudo cp wp-config-sample.php wp-config.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/
echo "In a separate terminal, make the following changes to wp-config.php....."
echo "find the MYSQL Settings lines and enter 'wordpress' for DB_NAME, 'labruhtooryboi' for DB_USER, and 'toortoor' for DB_PASSWORD"
echo "now find the KEY lines, EX: define('AUTH_KEY', / define('SECURE_AUTH_KEY'  and enter the values of the previously genterated salts"
echo "if you have any questions, pleas look at: https://www.nginx.com/blog/installing-wordpress-with-nginx-unit/"
echo "When your done editing wp-config.php, STOP, WAIT, press c to continue the script."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
printf "Ok then, moving on....."
break
fi
done

sudo chown -R wpuser:www-data /var/www/wordpress
sudo find /var/www/wordpress -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/wordpress/wp-content
sudo chmod -R g+w /var/www/wordpress/wp-content/themes
sudo chmod -R g+w /var/www/wordpress/wp-content/plugins

cd /opt/
sudo apt install -fy php php7.2-cgi php7.0 mongodb
sudo apt remove -y apache2 apache2-utils
clear

echo "Installing nginx unit for wordpress....."
cd /opt/
# nginx unit source download, compilation, and install
sudo apt install -fy build-essential golang
curl -sL https://deb.nodesource.com/setup_12.x | bash -
sudo apt install -fy nodejs
npm install -g node-gyp
sudo apt install -fy openssl php-dev libphp-embed libperl-dev python-dev ruby-dev default-jdk libssl-dev libpcre2-dev
git clone https://github.com/nginx/unit.git
cd unit/
./configure --state=/var/lib/unit --log=/var/log/unit.log --control=unix:/run/control.unit.sock --prefix=/usr/local/ --openssl
./configure go && ./configure java && ./configure nodejs && ./configure perl && ./configure php && ./configure python && ./configure ruby
make && make install 

#ssl certbot
clear
echo "installing certbot....."
read -p "What domain name would you like to use for your website?> " $domain
sed -i "s/domain.dns/$domain/gi" /etc/nginx/conf.d/serv.conf
sudo apt-get install -fy software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -fy python-certbot-nginx

sudo certbot --nginx
sudo systemctl restart nginx

#basic vpn
echo "getting a vpn config file from"
sudo wget --no-check-certificate https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-US2.zip
unzip VPNBook.com-OpenVPN-US2.zip
sudo rm -rf VPNBook.com-OpenVPN-US2.zip vpnbook-us2-tcp80.ovpn vpnbook-us2-tcp443.ovpn vpnbook-us2-udp53.ovpn 

#dns leak test
echo "installing dns leak test"
git clone https://github.com/macvk/dnsleaktest.git
go build -o /usr/bin/dnsleaktest dnsleaktest/dnsleaktest.go
chmod 755 /usr/bin/dnsleaktest
rm -rf dnsleaktest/

#xtra golang packages 
go get github.com/gorilla/websocket
go get unit.nginx.org/go

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
echo "Check vpn creds at: https://www.vpnbook.com/freevpn"
echo "Check under: Free OpenVPN"
echo ""
echo ""
echo ""
echo ""
echo "For mor information visit: https://www.nginx.com/blog/installing-wordpress-with-nginx-unit/"

echo "Done!"
