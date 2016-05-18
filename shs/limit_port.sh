#/usr/bin/sh
iptables -t filter -A OUTPUT -d 127.0.0.1 -j ACCEPT
#for ftp
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 20    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 21    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 115   -j ACCEPT
#for ssh
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 22    -j ACCEPT
#for mail
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 25    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 465   -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 993   -j ACCEPT
#for web
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 80    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 443   -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --sport 1080  -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 8080  -j ACCEPT
#reject others
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp -j REJECT --reject-with tcp-reset

#loopback interface
iptables -A OUTPUT -o lo -j ACCEPT 
iptables -A INPUT  -i lo -j ACCEPT

#DNS
iptables -A OUTPUT -p udp -sport 53 -j ACCEPT 
iptables -A INPUT  -p udp -dport 53 -j ACCEPT

#web & sql
#iptables -A OUTPUT -p tcp -m multiport 每dport 80,443,3306 -j ACCEPT 
#iptables -A INPUT  -p tcp -m multiport 每sport 80,443,3306 -j ACCEPT

#tcp connect limit
iptables -A OUTPUT -p tcp -sport 50000:60000 -m connlimit 每connlimit-above 20 -j REJECT 每reject-with tcp-reset 
iptables -A INPUT  -p tcp -dport 50000:60000 -m connlimit 每connlimit-above 20 -j REJECT 每reject-with tcp-reset

#others
iptables -A OUTPUT -p icmp -j ACCEPT 
iptables -A INPUT  -p icmp -j ACCEPT

#forbidden
iptables -P OUTPUT DROP 
iptables -P INPUT DROP 
iptables -P FORWARD DROP

#iptables -A OUTPUT -p tcp -m multiport 每dport 21,22,23 -j REJECT 每reject-with tcp-reset 
#iptables -A OUTPUT -p udp -m multiport 每dport 21,22,23 -j DROP
