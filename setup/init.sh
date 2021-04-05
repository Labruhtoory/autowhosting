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
    echo "" > /etc/apt/sources.list
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

    sudo apt install -fy python python3 python3-pip golang nikto dmitry dnstracer dirb dirbuster gobuster exiftool binwalk radare2 gdb openvpn tor proxychains nginx
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
    #tmeplate
    touch /opt/mkservice.txt
    echo "[Unit]\nDescriptoin= Your description here...\n\n[Service]\nExecStart=/path/to/script.script\n\n[Install]\WantedBy=multi-user.target\n\n#Don't forget to run 'systemctl daemon-reload', or just reboot" > /opt/mkservice.txt
    