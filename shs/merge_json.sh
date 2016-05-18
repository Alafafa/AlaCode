#!/bin/sh  

operDateTime=`date '+%m%d_%H%M'`
objPrefix=++++++++
objFileName=++++++++.json
bakFileName=++++++++_$operDateTime.json

#mv ~/shadowsocks/$objFileName  ~/shadowsocks/logs/$bakFileName

jsonList=`ls ~/shadowsocks|grep ".json"|grep -v "$objFileName"`

echo "{" > 														~/shadowsocks/$objFileName
echo \ \ \ \ \"server\":\"0.0.0.0\", >> 						~/shadowsocks/$objFileName
echo \ \ \ \ \"port_password\": { >>							~/shadowsocks/$objFileName

for jsonFile in $jsonList; do (
	echo processing ~/shadowsocks/$jsonFile;
	userPort=`cat ~/shadowsocks/$jsonFile |~/maintain/bin/jq '.server_port'`
	userPswd=`cat ~/shadowsocks/$jsonFile |~/maintain/bin/jq '.password'`
	echo \ \ \ \ \ \ \ \ \"$userPort\": $userPswd, >>		~/shadowsocks/$objFileName
) done

echo \ \ \ \ \ \ \ \ \ \"3389\":\ \"sss_alafafa_com\" >>		~/shadowsocks/$objFileName

echo \ \ \ \ }, >>												~/shadowsocks/$objFileName
echo \ \ \ \ \"method\": \"aes-256-cfb\", >>					~/shadowsocks/$objFileName
echo \ \ \ \ \"timeout\": 600 >>								~/shadowsocks/$objFileName
echo } >> 														~/shadowsocks/$objFileName

ssServerPid=`ps aux | grep "$objFileName" | grep -v grep | awk '{print $2}'`
echo ssServerPid: $ssServerPid
if [ -n "$ssServerPid" ]
then
	echo kill -SIGHUP $ssServerPid
	/bin/kill -SIGHUP $ssServerPid
else
	if [ -f "~/shadowsocks/logs/nohup_$objPrefix.out" ]
	then
		echo mv ~/shadowsocks/logs/nohup_$objPrefix.out ~/shadowsocks/logs/nohup_$objPrefix_$operDateTime.out
		mv ~/shadowsocks/logs/nohup_$objPrefix.out ~/shadowsocks/logs/nohup_$objPrefix_$operDateTime.out
	fi
	echo  ~/maintain/bin/sssgo -c ~/shadowsocks/$objFileName
	nohup ~/maintain/bin/sssgo -c ~/shadowsocks/$objFileName > ~/shadowsocks/logs/nohup_$objPrefix.out &
fi
