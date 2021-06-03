# whost-nginx

 Automated process to set up wordpress website hosting on nginx, and for web hosting in an nginx cluster.
 
 
 
 
 
 ## Web Hosting Server Setup Script & Prerequisites
 
 *Execute this one liner (Recommended as Root) to run the init script and add a WP site.*
                        
    sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/autowhosting.git && cd autowhosting/whs/ && chmod +x init_setup.sh add_site-dir.sh && ./init_setup.sh && ./add_site-dir.sh


### Requirements to consider when running web hosting scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition for an rpi)*
   - A new password for root user setup

**{SSL support coming soon} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


 ## Forward-Facing Server Setup Script & Prerequisites
 ### in progress....
