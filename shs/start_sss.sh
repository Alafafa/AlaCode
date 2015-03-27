#/usr/bin/sh
cd ~/shadowsocks
ls *.json|cut -d. -f1|awk  '{print "nohup /usr/local/bin/ssserver -c " $1".json > logs/nohup_" $1 ".out 2>&1> /dev/null &"}'|sh
cd -