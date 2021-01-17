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


                              ### install dependencies for tasks
                              
apt install iptables-persistent
touch /etc/iptables.test.rules


                              ### set up filesys
                              
#make rules file, and load rules on reboot

touch /etc/network/if-pre-up.d/iptables
iptables-restore < /etc/iptables.test.rules
echo "#!/bin/sh" > /etc/network/if-pre-up.d/iptables
echo "/sbin/iptables-restore < /etc/iptables.up.rules" >> /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables
