#!/bin/bash

sudo apt update && sudo DEBIAN_PRIORITY=low apt install -fy postfix


sudo postconf -e 'home_mailbox= Maildir/'

sudo postconf -e 'virtual_alias_maps= hash:/etc/postfix/virtual'

sudo nano /etc/postfix/virtual

#'''
#contact@example.com sammy
#admin@example.com sammy
#'''

sudo postmap /etc/postfix/virtual

sudo systemctl restart postfix

sudo ufw allow Postfix

echo 'export MAIL=~/Maildir' | sudo tee -a /etc/bash.bashrc | sudo tee -a /etc/profile.d/mail.sh

source /etc/profile.d/mail.sh

sudo apt install -fy s-nail

sudo nano /etc/s-nail.rc

#'''
#set emptystart
#set folder=Maildir
#set record=+sent
#'''

