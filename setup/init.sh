#!/bin/bash

echo 'moving to /opt'
#init
cd /opt

echo 'keep in mind the default answer is yes...'
read -p 'If u were to create a new website, what would u name it for file storage EX: mysite' site
read -p 'New website? y/n' nsite
read -p 'Need to add Repo? y/n> ' repo
read -p 'Install tools? y/n>' tools
read -p 'Create services & template? y/n>' serv

if [ $repo == "n"]
then
    echo "skipping repo..."
else
    echo 'adding apt repo'
    #repo
    apt-key adv --keyserver pool.sks-keyservers.net --recv-keys ED444FF07D8D0BF6
    echo '# Kali linux repositories | Added by Katoolin' >> /etc/apt/sources.list
    echo 'deb http://http.kali.org/kali kali-rolling main contrib non-free' >> /etc/apt/sources.list
    sudo apt update
fi

if [ $tools == "n"]
then
    echo "skipping tools..."
else
    #networking
    echo "nameserver 1.1.1.1" > /etc/resolv.conf
    echo "nameserver 1.0.0.1" >> /etc/resolv.conf

    sudo apt install -fy python python3 python3-pip golang speedtest-cli nikto dmitry dnstracer dirb dirbuster gobuster exiftool binwalk radare2 gdb openvpn tor proxychains nginx
    #programming language support
    sudo python3 -m pip install --upgrade pip

    #dirsearch
    git clone https://github.com/maurosoria/dirsearch.git

    #photon
    git clone https://github.com/s0md3v/Photon.git
fi

if [ $serv == "n"]
then
    echo "skipping services & template"
else  
    
    #basic vpn
    sudo wget --no-check-certificate https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-US2.zip
    unzip VPNBook.com-OpenVPN-US2.zip
    sudo rm -rf VPNBook.com-OpenVPN-US2.zip vpnbook-us2-tcp80.ovpn vpnbook-us2-tcp443.ovpn vpnbook-us2-udp53.ovpn 
    
    
    #tmeplate
    touch /opt/mkservice.txt
    echo "[Unit]
    Descriptoin= Your description here...
    [Service]\nExecStart=/path/to/script.script
    [Install]\WantedBy=multi-user.target
    #Don't forget to run 'systemctl daemon-reload', or just reboot" > /opt/mkservice.txt
fi

if [ $nsite == "n"]
then 
    echo "not adding a new site..."
else
    #nginx
    systemctl enable nginx
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
    touch /etc/nginx/snippets/self-signed.conf
    echo"ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;" >> /etc/nginx/snippets/self-signed.conf 
    echo"ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" >> /etc/nginx/snippets/self-signed.conf 
    cp /opt/Web_Host_Standalone_Server/setup/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    rm -rf /etc/sites-available/* /etc/nginx/sites-enabled/*
    
    touch /etc/nginx/sites-available/$site
    mkdir /var/www/$site/html
    sed 's/websitename/;s/$site /opt/Web_Host_Standalone_Server/setup/ssl_server_template
    cp /opt/Web_Host_Standalone_Server/setup/ssl_server_template /etc/nginx/sites-available/$site
    ln -s /etc/nginx/sites-available/$site /etc/nginx/sites-enabled/
    sudo systemctl restart nginx

clear
sudo ufw app list
systemctl status nginx

echo "Done!"
