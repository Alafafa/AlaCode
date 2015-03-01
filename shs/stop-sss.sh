#/usr/bin/sh
cd ~sindo/shadowsocks
ls *.json|cut -d. -f1|cut -d/ -f5|awk  '{print "ps -ef|grep ssserver|grep -v grep|grep "$1".json"}'|sh|awk '{print $2}'|xargs kill
cd -