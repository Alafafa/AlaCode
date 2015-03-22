#!/bin/sh
SSConfigPath=~/shadowsocks
SSBinPath=/usr/bin/ssserver

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
        StartConfigPath=$SSConfigPath/$1
        #LogFileName=`echo $1 | awk -F"[.]" '{system( " echo "$1)}'`
        LogFileName=`echo $1 | sed s/.json//g`
        $SSBinPath -c $StartConfigPath >> $SSConfigPath/logs/nohup_$LogFileName.out &
}

getFileName(){
         echo $1 | sed  's/\.\w*$//'
}

export -f check
main(){
        ls $SSConfigPath | grep .json | awk '{system("check "$0)}'
}
main

