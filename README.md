# whost-nginx
 Automated process to set up wordpress website hosting.
 
 
                         Standalone Server Script & Prerquisites.....
 
 *Run as Root (recommended)
 
 copy and run either of these commands:
 


(this one allows time to contemplate if your server is fresh and or cleaned up enough to put lots of stuff on it sot the installation wont
cause major errors and potentially nuke your server and attached drives)
 
$ cd /opt/ && sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x serv_setup.sh && clear && echo "Ok, Now run './serv_setup.sh' to start the process :)"


(full send) *Recommended just run as root so there are no privilege conflicts


$ cd /opt/ && sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x init_setup.sh && ./init_setup.sh


                          Here are some notes to consider when running the scripts:

Quick note, say yes to and fill out all services' prompts. It just makes the process easier :)
Before you begin, make sure that you keep track of your credentials that you setup, keep in mind, you will need to supply your own credentials and information for the following services:

MariaDB (MySQL):
   - Your system/server root account password for creating and configuring the root database account
   - A username to create a new user for accessing the new wordpress database
   - A password for this new user

CertBot (SSL cert&key generator):
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


You will also need to edit certain files. To make this easier, you will be provided instructions when needed.
