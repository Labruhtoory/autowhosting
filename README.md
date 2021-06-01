# whost-nginx
 Automated process to set up wordpress website hosting.
 
 
                         Standalone Server Script & Prerquisites.....
 
 *Install git, and Run as Root (recommended)

$ git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x init_setup.sh add_site-dir.sh && clear && ./init_setup.sh && clear && ./add_site-dir.sh



                          Here are some notes to consider when running the scripts:

Quick note, say yes, or 'y', to fill out all services' prompts. It just makes the process easier :)
Before you begin, make sure that you keep track of your credentials that you setup, keep in mind, you will need to supply your own credentials and information for the following services:

MariaDB (MySQL):
   - A new password for setup

CertBot (SSL cert&key generator):
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


You will also need to edit certain files. To make this easier, you will be provided instructions when needed.
