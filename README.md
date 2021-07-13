# AutoWHosting

 Automated process to set up wordpress website hosting on nginx, and for web hosting in an nginx cluster.
 
 I am using a 4 node cluster, and thus have, and are developing, the following nodes with their respective functions:
 
 1 - Load Balancer - This node is for handling requests, as well as providing access to the cluster's network.
 2 - Website Hosting - This node is for the majority of content that user's scroll through.
 3 - App Hosting - This node is for the majority of content that user's will access with cli/api tools.
 4 - Archiving - This node is for managing the majority of larger files, database prpogation, and backups.
 
 
 ## Load Balancing Server Setup & Prerequisites

 *Execute this one liner (Recommended as Root) to run the setup script*
 
    in progress

### Requirements to consider when running load balancing scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**Backend Servers**
   - If you are using a cluster, you will need to provide the number, and IP address of each node.


 
 ## Web Hosting Server Setup & Prerequisites
 
 *Execute this one liner (Recommended as Root) to run the init script*
                        
    in progress

 *Execute this one liner (Recommended as Root) add a wp site to host*
    
    in progress
   
### Requirements to consider when running web hosting scripts

**Promts:**
   - Read all prompts and when ready, press c, or answer y

**Database Migration**
   - A new password for root user setup; will be prompted during setup
   - A dedicated drive partition for databases to be stored and propagated on

**{SSL support in progress} CertBot (SSL cert&key generator):**
   - A valid email address in case verification is needed
   - A resitered domain name for configuring Nginx DNS handling EX: myawesomesite.com
