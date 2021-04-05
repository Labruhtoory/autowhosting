#!/bin/bash

echo 'moving to /opt'
#init
cd /opt

echo 'keep in mind the default answer is yes...'
read -p 'Need to add Repo? y/n> ' repo
read -p 'Install tools? y/n>' tools
read -p 'Create services & template? y/n>' serv
#ssl
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
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
    #nginx
    systemctl enable nginx
    touch /etc/nginx/snippets/self-signed.conf
    echo"ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;" >> /etc/nginx/snippets/self-signed.conf 
    echo"ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" >> /etc/nginx/snippets/self-signed.conf 
    touch /etc/nginx/snippets/ssl-params.conf
    echo "ssl_protocols TLSv1.2;" > /etc/nginx/snippets/ssl-params.conf
    echo "ssl_prefer_server_ciphers on;" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_dhparam /etc/ssl/certs/dhparam.pem;" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_session_timeout  10m;" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_session_cache shared:SSL:10m;" >> /etc/nginx/snippets/ssl-params.conf
    echo "ssl_session_tickets off; # Requires nginx >= 1.5.9" >> /etc/nginx/snippets/ssl-params.conf
    echo "# ssl_stapling on; # Requires nginx >= 1.3.7" >> /etc/nginx/snippets/ssl-params.conf
    echo "# ssl_stapling_verify on; # Requires nginx => 1.3.7" >> /etc/nginx/snippets/ssl-params.conf
    echo "resolver 8.8.8.8 8.8.4.4 valid=300s;" >> /etc/nginx/snippets/ssl-params.conf
    echo "resolver_timeout 5s;" >> /etc/nginx/snippets/ssl-params.conf
    echo "add_header X-Frame-Options DENY;" >> /etc/nginx/snippets/ssl-params.conf
    echo "add_header X-Content-Type-Options nosniff;" >> /etc/nginx/snippets/ssl-params.conf
    echo "add_header X-XSS-Protection "1; mode=block";" >> /etc/nginx/snippets/ssl-params.conf
  
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

echo "Done!"
