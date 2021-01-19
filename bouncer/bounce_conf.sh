#!/bin/bash


                              ### base
#echo "" >> /etc/iptables.test.rules

                              
                              ### init stuff

#reset(delete) rules
iptables -F
echo "#rules" >  /etc/iptables.test.rules

#allow packets from LAN
echo "iptables -A INPUT -s x.x.x.x/xx -j ACCEPT" >> /etc/iptables.test.rules

#allow all internet traffic
echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/iptables.test.rules

#allow all outbound traffic
echo "iptables -A OUTPUT -j ACCEPT" >> /etc/iptables.test.rules

#allow HTTP and HTTPS from anywhere
echo "iptables -A INPUT -p tcp --dport 80 -j ACCEPT" >> /etc/iptables.test.rules
echo "iptables -A INPUT -p tcp --dport 443 -j ACCEPT" >> /etc/iptables.test.rules

#allow ssh 
echo "iptables -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT" >> /etc/iptables.test.rules




                              ### Firewall init

#block an ip
echo "iptables -A INPUT -s x.x.x.x -j DROP" >> /etc/iptables.test.rules

#Add a new rule to allow the rest of the internet traffic (All the rules to drop traffic must be created before this rule)
echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/iptables.test.rules

#ipv4 forwarding
sudo sysctl -w net.ipv4.ip_foraward = 1


#Prerouting
sudo iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 80 -m state --state NEW -m statistic --mode nth --every 2 --packet 0 -j DNAT --to-destination 192.168.2.2:80
sudo iptables -t nat -A PREROUTING -p tcp -i eth1 --dport 80 -m state --state NEW -m statistic --mode nth --every 2 --packet 1 -j DNAT --to-destination 192.168.2.3:80



#save-config
sudo iptables-save

echo "" >> /etc/iptables.test.rules
