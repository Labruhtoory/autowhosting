#!/bin/bash

echo 'moving to /opt'
#init
cd /opt

echo 'keep in mind the default answer is yes...'
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
    echo "[Unit]" > /opt/mkservice.txt
    echo"Descriptoin=Your description here..." >> /opt/mkservice.txt
    echo"[Service]" >> /opt/mkservice.txt
    echo"ExecStart=/path/to/script.script" >> /opt/mkservice.txt
    echo"[Install]" >> /opt/mkservice.txt
    echo"WantedBy=multi-user.target" >> /opt/mkservice.txt
    #Don't forget to run 'systemctl daemon-reload', or just reboot" > /opt/mkservice.txt
fi

clear

echo "Done!"
