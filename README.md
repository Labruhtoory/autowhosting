# whost-nginx

 Automated process to set up wordpress website hosting, and for web hosting in a cluster.
 
 
 
 
 
 ## Web Hosting Server Setup Script & Prerequisites.....
 
 *Execute this one liner (Recommended as Root) to run the init script and add a WP site.*
                        
    sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/autowhosting.git && cd autowhosting/whs/ && chmod +x init_setup.sh add_site-dir.sh && ./init_setup.sh && ./add_site-dir.sh


### Requirements to consider when running setup scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition for an rpi)*
   - A new password for root user setup

**{SSL support coming soon} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


### What each setup script does

**init_setup:**
   - Optimizes a drive partition for DB management, this will take lots of stress off the system partition with all the DB queries being made.
   - Installs packages of nginx, mysql, nosql, and php.
   - Configures mysql and nosql to run on the selected drive partition.
   - Configures php and nginx for basic usage

**add_site_di:r**
   - Configures ngnix and mysql for a new wordpress website with the name of the answer to the prompt
   - Installs wordpress in the prompted /var/www/sitename directory, and configures wordpress to use the new database

**{SSL support coming soon} add_ssl:**
   - Creates a verified ssl certificate
   - Configures nginx to use the new ssl cert
