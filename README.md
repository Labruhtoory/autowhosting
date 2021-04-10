# whost-nginx
 Automated process to set up wordpress website hosting.
 
 
                                                  Standalone Server Script & Prerquisites.....
 
 *Run as Root (recommended)
 
 copy and run either of these commands:
 
 
(this one allows time to contemplate if your server is fresh and or cleaned up enough to put lots of stuff on it sot the installation wont
cause major errors and potentially nuke your server and attached drives)
 
 $ cd /opt/ && sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x serv_setup.sh && clear && echo "Ok, Now run './serv_setup.sh' to start the process :)"






(full send) *Recommended just run as root so there are no privilege conflicts

$ cd /opt/ && sudo apt update && sudo apt install -fy git htop && git clone https://github.com/Labruhtoory/whost-nginx.git && cd whost-nginx/setup_serv/ && chmod +x serv_setup.sh && ./serv_setup.sh
