#!/bin/bash


                              ### init networking


#ifconfig eth0 0.0.0.0
#ifconfig wlan0 0.0.0.0

echo "interface eth0" >> /etc/dhcpcd.conf
echo "static ip_address=x.x.x.x" >> /etc/dhcpcd.conf
echo "static routers=x.x.x.x" >> /etc/dhcpcd.conf
echo "static domain_name_servers=1.1.1.1 1.0.0.1" >> /etc/dhcpcd.conf




                              ### turn off swap
#dphys-swapfile swapoff &&
#dphys-swapfile uninstall &&
#update-rc.d -f dphys-swapfile remove                            




                              ### dependencies for tasks
apt update
apt install nano nginx php-fpm 



                              ### startup
                              
sudo /etc/init.d/nginx start
