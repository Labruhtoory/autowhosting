# whost-nginx

 Automated process to set up wordpress website hosting.
 
 
## Standalone Server Script & Prerquisites.....
 
 *Run as Root (recommended)*
 *This one liner will run the init script and adds a WP site.*
                        
    git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x init_setup.sh add_site-dir.sh && ./init_setup.sh && ./add_site-dir.sh

## Notes to consider when running the scripts**

**Promts:**
   - Read all prompts, when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition for an rpi)*
   - Need a new password for setup

**{SSL support coming soon} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com
