#!/bin/sh
ssCfgPath=~/shadowsocks
ssBinPath=/usr/bin/ssserver

check(){
	serverCounts=`ps aux | grep $1 | grep -v grep | wc -l`
	if [ $serverCounts -eq 0 ]; then
		echo "No"
		start $1
	else
		echo `echo $1 | sed 's/\.\w*$//'`" is okay"
	fi
}

start(){
	startConfigPath=$ssCfgPath/$1
	#LogFileName=`echo $1 | awk -F"[.]" '{system( " echo "$1)}'`
	logFileName=`echo $1 | sed s/.json//g`
	$ssBinPath -c $startConfigPath >> $ssCfgPath/logs/nohup_$logFileName.out &
}

get_fileName(){
	 echo $1 | sed  's/\.\w*$//'
}

export -f check

main(){
	ls $ssCfgPath | grep .json | awk '{system("check "$0)}'
}

main