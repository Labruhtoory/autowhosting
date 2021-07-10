#!/bin/bash

clear
echo "Take this time to review your system's state....."
echo "EX: Is it a fresh install? Are all services in acceptable default, 'factory' settings?"
echo "Press 'Ctrl + c' twice to cancel if needed, or 'c' to continue....."
while : ; do
read -n 1 k <&1
if [[ $k = c ]] ; then
	echo ""
printf "Ok then, moving on....."
break
fi
done
clear
##############################    Collect Info   ##############################
read -p "How many backend servers will this server route traffic to?: " numserv
i=0
arrServ=()
while [ $i -ne $numserv ]
do
        i=$(($i+1))
        read -p "server$i ip: " servip
        arrServ+=($servip)
done
##############################    Install Packages   ##############################
echo "Getting things up to date..."
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sudo apt update &> /dev/null
sudo apt install -fy nginx ufw &> /dev/null
sudo systemctl start nginx
sudo systemctl enable nginx
clear
##############################    Firewall Setup   ##############################
echo "Setting up the firewall..."
chmod +x firewall/fire.sh && ./firewall/fire.sh
clear
echo "Done!!!"
##############################    Nginx Setup   ##############################
echo "Setting up nginx..."
rm -rf /etc/nginx/sites-enabled/default
cp nginx/lbs.conf /etc/nginx/sites-enabled/lbs.conf

# add this line for the amount of servers
#server backend max_fails=3 fail_timeout=5s;

#replace every 'backend' with server ip

for $servip in "${arrServ[@]}"
do
    #sed '/Add backend servers here/a \server backend max_fails=3 fail_timeout=5s;' /etc/nginx/sites-enabled/lbs.conf > /etc/nginx/sites-enabled/lbs.conf
    sed -i '13i\   server backend max_fails=3 fail_timeout=5s;' /etc/nginx/sites-enabled/lbs.conf
    sed -i "s/backend/$servip/g" /etc/nginx/sites-enabled/lbs.conf
done

clear
##############################    VPN Server Setup   ##############################
echo "Run the following command to setup a vpn with this server:"
echo "curl -L https://install.pivpn.io | bash"
echo "Done with setup!"
