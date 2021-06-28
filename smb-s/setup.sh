#!/bin/bash

##############################    DB DataDrive Setup   ##############################
read -p "Enter a new password for MariaDB: " newpass
clear
echo "Setting up dedicated database drive partition....."
echo "Please insert a drive with the desired (EMPTY) partition to use....."
lsblk | grep "disk\|part"
echo "Have you plugged in a device? If not, now is the time to do it....."
echo "Press 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
	echo ""
printf "Ok then, moving on....."
break
fi
done
clear
lsblk | grep "disk\|part"
echo ""
read -p "What is the new partition to mount? (EX: sda1, sda2, sdb1 etc.....): " answ
mkfs.ext4 /dev/$answ
echo "mounting $answ"
sudo mkdir /dbs
sudo mount /dev/$answ /dbs
echo "/dev/$answ        /dbs        ext4    defaults      0      0" >> /etc/fstab
echo "Ok, /dev/$answ has been prepped with an ext4 filsystem for mounting on boot"
clear
##############################   Init Installs    ##############################
echo "Getting things up to date..."
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sudo apt update &> /dev/null
echo "Installing packages....."
echo "[1/3]"
sudo apt update &> /dev/null && sudo apt upgrade -y &> /dev/null
echo "[2/3]"
sudo apt install -fy nginx mariadb-server mariadb-client mongodb-server php7.3 php7.3-fpm php7.3-mysql ufw &> /dev/null
echo "[3/3]"
sudo apt-get install -fy samba samba-common-bin &> /dev/null
sudo systemctl start mysql nginx php7.3-fpm
sudo systemctl enable mysql nginx php7.3-fpm
clear
##############################    MariaDB (MySQL) Install & Data Migration   ##############################
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
echo "Setting up MariaDB management..."
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$newpass';"
mysql -u root -p$newpass -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost';"
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
##############################    SMB Share Setup    ##############################
sudo mkdir -m 1777 /dbs/share
cp smb.conf /etc/samba/smb.conf
sed -i "s+dirpath+/dev/$answ+gi" /etc/samba/smb.conf
#sudo smbpasswd -a pi


#[sharename]
#Comment = Open Network Share
#Path = dirpath
#Browseable = yes
#Writeable = Yes
#only guest = no
#create mask = 0777
#directory mask = 0777
#Public = yes
#Guest ok = yes