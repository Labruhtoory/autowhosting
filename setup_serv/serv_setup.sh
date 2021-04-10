#!/bin/bash
#initial comments
echo "*Quick note, say yes to and fill out all services' prompts. Just makes the process easier :)"
echo ""
echo "Before you begin, make sure that you keep track of your credentials that you setup....."
echo "Keep in mind, you will need to supply your own credentials and information for the following services....."
echo ""
echo "MariaDB (MySQL):"
echo "  > Your system/server root account password for creating and configuring the root database account"
echo "  > A username to create a new user for accessing the new wordpress database"
echo "  > A password for this new user"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
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
##############################   Init Installs, and Copying Templates for Configs    ##############################
sudo apt install -fy python python3 python3-pip golang speedtest-cli htop nginx mariadb-server
sudo python3 -m pip install --upgrade pip
clear
echo "making some slight adjustments to nginx"
systemctl enable nginx && systemctl restart nginx
sudo rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
mv serv-confs-defaults/wpdef-serv.conf /etc/nginx/conf.d
go get github.com/gorilla/websocket
mv wordpress.config /opt/
cd /var/www/
clear
##############################    DB DataDrive Setup ##############################
echo "Setting up initial database drive....."
echo "Please insert a drive with only one partition....."
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
##############################    MariaDB (MySQL) for Wordpress Install, Setup, Data Migration, and Config   ##############################
echo "Migrating MariaDB data to mounted disk....."
sudo systemctl stop mariadb
sudo rsync -rltDvz /var/lib/mysql /dbs
sudo chown -R mysql:mysql /dbs/
sudo grep -R --color datadir /etc/mysql/*
cp /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.bak
sed -i "s+/var/lib/mysql+/dbs/mysql+gi" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl start mariadb
clear
echo "Make sure you know your root user passwd, if you dont, then run 'sudo passwd root' in a separate terminal"
sudo mysql_secure_installation
ln -s /dbs/ /var/www/
echo "created sybolic link folder for database drive $answ in /var/www"
echo "Mounted $answ to /dbs and migrated MariaDB data"
clear
echo "setting up initial mysql wordpress database"
echo "Enter your system root account passwd in the prompt below."
echo "After that, run the folowing quieries in the mysql> prompt.....and leave quotes and ticks in commands!"
echo "CREATE DATABASE wordpress;"
echo "CREATE USER newuserhere IDENTIFIED BY 'newpasswordhere';"
echo "GRANT ALL PRIVILEGES ON wordpress.* TO newuserhere;"
echo "FLUSH PRIVILEGES;"
echo "EXIT"
sudo mysql -u root -p
clear
##############################    MongoDB (NoSQL) for Wordpress Install, Setup, Data Migration, and Config   ##############################

##############################    Wordpress Site Init Install, Setup, and Config    ##############################
echo "Setting up wordpress"
cd /var/www/
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz
rm -rf latest.tar.gz
mv /opt/wordpress.config /var/www/wordpress/
cd /var/www/wordpress
sudo cp wp-config-sample.php wp-config.php
clear
echo "Editing wordpress mysql config...."









sed -i "s/database_name_here/wordpress/gi" /var/www/wordpress/wp-config.php
read -p "What is your new MariaDB (MySQL) username?" unanmer
sed -i "s/username_here/$unamer/gi" /var/www/wordpress/wp-config.php
read -p "What is your new MariaDB (MySQL) password?" passwder
sed -i "s/password_here/$passwder/gi" /var/www/wordpress/wp-config.php
clear
echo "In a separate terminal, make the following changes to /var/www/wordpress/wp-config.php ....."
echo ""
echo ""
echo "Find the KEY lines, EX: define('AUTH_KEY', / define('SECURE_AUTH_KEY'  and enter the values of the genterated salts below"
echo "copy what is between the single quotes below into its respective place in /var/www/wordpress/wp-config.php"
echo "(make sure to put it betweensingle quotes)"
echo ""
echo ""
echo ""
echo ""
curl -s https://api.wordpress.org/secret-key/1.1/salt/
echo ""
echo ""
echo ""
echo ""
echo "When your done editing wp-config.php, STOP, WAIT, press c to continue the script."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
echo ""
printf "Ok then, moving on....."
break
fi
done
sudo chown -R wpuser:www-data /var/www/wordpress
sudo find /var/www/wordpress -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/wordpress/wp-content
sudo chmod -R g+w /var/www/wordpress/wp-content/themes
sudo chmod -R g+w /var/www/wordpress/wp-content/plugins
##############################    NGINX Unit Source, Config, Build, and Install     ##############################
cd /opt/
sudo apt install -fy php php7.2-cgi php7.0 mongodb
sudo apt remove -y apache2 apache2-utils
clear

                                           
                                           
                                           
                                           ###   need to figure out installing nginx unit

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
clear
##############################    SSL Cert and Key Gen    ##############################
#ssl certbot
echo "Installing CertBot....."
echo ""
read -p "What domain name would you like to use for your website?> " $domain

                                        ###   this left a blank space

sed -i "s/domain.dns/$domain/gi" /etc/nginx/conf.d/wpdef-serv.conf


                                        ### install certbot in the beginning of the script
                                        ### and, edit nginx .conf template bc certbot threw an error
                            ### Error while running nginx -c /etc/nginx/nginx.conf -t.
                            ### nginx: [emerg] open() "/etc/letsencrypt/options-ssl-nginx.conf" failed (2: No such file or directory) in /etc/nginx/conf.d/wpdef-serv.conf:25
                            ### nginx: configuration file /etc/nginx/nginx.conf test failed
                            ###
                            
                            
sudo apt-get install -fy software-properties-common
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install -fy python-certbot-nginx
sudo apt remove -fy apache2-data
mv /var/wwww/html/index.nginx-debian.html /var/www/html/index.html
mv /var/www/html/index.html /var/www/index.html
rm -rf /var/www/html/
sudo systemctl restart nginx
clear
##############################    Xtra Free Vpn (Optional)    ##############################
echo "Getting a free vpn config file from vpnbook.com/freevpm....."
sudo wget --no-check-certificate https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-US2.zip
unzip VPNBook.com-OpenVPN-US2.zip
sudo rm -rf VPNBook.com-OpenVPN-US2.zip vpnbook-us2-tcp80.ovpn vpnbook-us2-tcp443.ovpn vpnbook-us2-udp53.ovpn 
clear
#dns leak test
echo "installing a dns leak test, run by commad 'dnsleaktest'"
git clone https://github.com/macvk/dnsleaktest.git
go build -o /usr/bin/dnsleaktest dnsleaktest/dnsleaktest.go
chmod 755 /usr/bin/dnsleaktest
rm -rf dnsleaktest/
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
