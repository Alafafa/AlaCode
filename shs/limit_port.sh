#/usr/bin/sh
iptables -t filter -A OUTPUT -d 127.0.0.1 -j ACCEPT
#iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 20    -j ACCEPT
#iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 21    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 22    -j ACCEPT
#and other mail ports
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 25    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 80    -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 443   -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --sport 1080  -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp --dport 8080  -j ACCEPT
iptables -t filter -m owner --uid-owner alass -A OUTPUT -p tcp -j REJECT --reject-with tcp-reset

#��������
iptables -A OUTPUT -o lo -j ACCEPT 
iptables -A INPUT  -i lo -j ACCEPT

#DNS
iptables -A OUTPUT -p udp -sport 53 -j ACCEPT 
iptables -A INPUT  -p udp -dport 53 -j ACCEPT

#��ҳ-SQL
iptables -A OUTPUT -p tcp -m multiport �Cdport 80,443,3306 -j ACCEPT 
iptables -A INPUT  -p tcp -m multiport �Csport 80,443,3306 -j ACCEPT

#������
iptables -A OUTPUT -p tcp -sport 50000:60000 -m connlimit �Cconnlimit-above 20 -j REJECT �Creject-with tcp-reset 
iptables -A INPUT  -p tcp -dport 50000:60000 -m connlimit �Cconnlimit-above 20 -j REJECT �Creject-with tcp-reset

#����
iptables -A OUTPUT -p icmp -j ACCEPT 
iptables -A INPUT  -p icmp -j ACCEPT

#��ֹ
iptables -P OUTPUT DROP 
iptables -P INPUT DROP 
iptables -P FORWARD DROP

#iptables -A OUTPUT -p tcp -m multiport �Cdport 21,22,23 -j REJECT �Creject-with tcp-reset 
#iptables -A OUTPUT -p udp -m multiport �Cdport 21,22,23 -j DROP

#��������˿�
# iptables -A OUTPUT -p tcp -m multiport �Cdport 24,25,50,57,105,106,109,110,143,158,209,218,220,465,587 -j REJECT �Creject-with tcp-reset 
# iptables -A OUTPUT -p tcp -m multiport �Cdport 993,995,1109,24554,60177,60179 -j REJECT �Creject-with tcp-reset 
# iptables -A OUTPUT -p udp -m multiport �Cdport 24,25,50,57,105,106,109,110,143,158,209,218,220,465,587 -j DROP 
# iptables -A OUTPUT -p udp -m multiport �Cdport 993,995,1109,24554,60177,60179 -j DROP