# whost-nginx

 Automated process to set up wordpress website hosting on nginx, and for web hosting in an nginx cluster.
 
 
 
 
 
 ## Web Hosting Server Setup & Prerequisites
 
 *Execute this one liner (Recommended as Root) to run the init script and add a WP site.*
                        
    sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/autowhosting.git && cd autowhosting/whs/ && chmod +x init_setup.sh add_site-dir.sh && ./init_setup.sh && ./add_site-dir.sh


### Requirements to consider when running web hosting scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition, and can be any filesystem type)*
   - A new password for root user setup

**{SSL support coming soon} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


## Load Balancing Server Setup & Prerequisites

 *Execute this one liner (Recommended as Root) to run the setup script*
 
    sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/autowhosting.git && cd autowhosting/lbs/ && chmod +x setup.sh firewall/fire.sh vpn/pivpn.sh && ./setup.sh


### Requirements to consider when running web hosting scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**Backend Servers**
   - The number of servers that you will use, and the ip address for each server.
