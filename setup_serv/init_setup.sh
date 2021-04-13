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
echo "[+] 1/14"
sudo apt update &> /dev/null && sudo apt install -fy speedtest-cli htop &> /dev/null
echo "[+] 2/14"
apt install -fy nginx software-properties-common python-certbot-nginx mariadb-server mongodb-server &> /dev/null
echo "[+] 3/14"
apt install -fy build-essential python python3 python3-pip golang openssl libphp-embed libperl-dev python-dev ruby-dev default-jdk libssl-dev libpcre2-dev &> /dev/null
echo "[+] 4/14"
apt install -fy phppgadmin unzip zip php7.3 libphp7.3-embed php7.3-bcmath php7.3-bz2 php7.3-cli php7.3-common php7.3-curl php7.3-dba php7.3-dev &> /dev/null
echo "[+] 5/14"
apt install -fy php7.3-enchant php7.3-fpm php7.3-gd php7.3-gmp php7.3-imap php7.3-imagick php7.3-interbase php7.3-intl php7.3-json php7.3-ldap php7.3-mbstring &> /dev/null
echo "[+] 6/14"
apt install -fy php7.3-mysql php7.3-odbc php7.3-opcache php7.3-pgsql php7.3-phpdbg php7.3-pspell php7.3-readline php7.3-recode php7.3-snmp php7.3-soap &> /dev/null
echo "[+] 7/14"
apt install -fy php7.3-sybase php7.3-tidy php7.3-xml php7.3-xmlrpc php7.3-xsl php7.3-zip &> /dev/null
echo "[+] 8/14"
sudo python3 -m pip install --upgrade pip &> /dev/null
echo "[+] 9/14"
sudo apt remove -fy apache2 apache2-utils apache2-data &> /dev/null
echo "[+] 10/14"
curl -sL https://deb.nodesource.com/setup_12.x | bash - &> /dev/null
echo "[+] 11/14"
sudo apt install -fy nodejs &> /dev/null
echo "[+] 12/14"
npm install -g node-gyp &> /dev/null
echo "[+] 13/14"
go get github.com/gorilla/websocket &> /dev/null
echo "[+] 14/14"
sudo systemctl start mysql nginx php7.3-fpm monit
sudo systemctl enable mysql nginx php7.3-fpm monit
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
echo "Migrating MariaDB (MySQL) data to mounted disk....."
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
##############################    MongoDB (NoSQL) Install & Data Migration   ##############################
echo "Migrating Mongodb (NoSQL) data to mounted disk....."
sudo systemctl stop mongodb
sudo rsync -rltDvz /var/lib/mongodb /dbs
sudo chown mongodb:mongodb -R /dbs/mongodb/
mv /var/lib/mongodb /var/lib/mongodb.bak
cat /etc/mongodb.conf | grep --color dbpath
cp /etc/mongodb.conf /etc/mongodb.conf.bak
sed -i "s+/var/lib/mongodb+/dbs/mongodb+gi" /etc/mongodb.conf
cat /etc/mongodb.conf | grep --color dbpath
sudo systemctl start mongodb
clear
##########
echo "Would you like to setup a new site?" 
echo "Press 'Ctrl + c' twice to cancel, or press c to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
echo ""
printf "Ok then, moving on....."
break
fi
done
##############################    New User For Web Management   ##############################
echo "Seting up new user for website management....."
echo "In a seperate terminal, run the following 'adduser wordy'"
echo "All information is optional except for a passwd, remeber it....."
mkdir -p /home/wordy/logs
chmod +x new_site.sh
./new_site.sh
