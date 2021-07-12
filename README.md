# AutoWHosting

 Automated process to set up wordpress website hosting on nginx, and for web hosting in an nginx cluster.
 
 
 
 
 
 ## Web Hosting Server Setup & Prerequisites
 
 *Execute this one liner (Recommended as Root) to run the init script and add a WP site.*
                        
    in progress

### Requirements to consider when running web hosting scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**MariaDB (MySQL):**
   - A dedicated drive partition for databases *(For example an empty usb drive with one partition, and can be any filesystem type)*
   - A new password for root user setup

**{SSL support in progress} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com


## Load Balancing Server Setup & Prerequisites

 *Execute this one liner (Recommended as Root) to run the setup script*
 
    in progress


### Requirements to consider when running load balancing scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**Backend Servers**
   - The number of servers that you will use if using a cluster, and the ip address for each server.
