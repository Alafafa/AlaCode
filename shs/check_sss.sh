#!/bin/sh
ssCfgPath=/home/alass/shadowsocks
ssSrvBinFile=/usr/local/bin/ssserver

check_ssServer() { 
	ssFileName=$1
	serverCounts=`ps aux | grep $ssFileName | grep -v grep | wc -l`
	if [ $serverCounts -eq 0 ]; then
		echo `echo $ssFileName | sed 's/\.\w*$//'`" is not found, starting..."
		start_ssServer $ssFileName
	fi
}

start_ssServer() {
	ssFileName=$1
	logFileName=`echo $ssFileName | sed s/.json//g`
	cd $ssCfgPath
	nohup $ssSrvBinFile -c $ssFileName > logs/nohup_$logFileName.out 2>&1 < /dev/null &
	cd - > /dev/null
}
export ssCfgPath
export ssSrvBinFile
export -f check_ssServer
export -f start_ssServer

main(){
	ls $ssCfgPath | grep $1".json" | awk  '{print "check_ssServer " $1}'|sh
}

main $1