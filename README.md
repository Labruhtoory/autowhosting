# whost-nginx

 Automated process to set up wordpress website hosting.
 
 
 
 
## Standalone Server Script & Prerquisites.....
 
 *Execute this one liner (Recommended as Root) to run the init script and add a WP site.*
                        
    git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x init_setup.sh add_site-dir.sh && ./init_setup.sh && ./add_site-dir.sh




## Requirements to consider when running scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition for an rpi)*
   - A new password for root user setup

**{SSL support coming soon} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com
