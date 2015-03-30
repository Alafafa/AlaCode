#!/bin/sh
ssFileName=glow++.json
ssCfgPath=/home/alass/shadowsocks
ssServerBinFile=/usr/bin/ssserver

reset_ssPswd() {
	ssPassWord=`date +%s | sha256sum | base64 | head -c 12; echo`
	sed -i 's/password.*$/password":"'$ssPassWord'",/' $ssCfgPath/$ssFileName
}

start_ssServer() {
	startCfgPath=$ssCfgPath/$1
	logFileName=`echo $1 | sed s/.json//g`
	$ssServerBinFile -c $ssCfgPath/$ssFileName > $ssCfgPath/logs/nohup_$logFileName.out &
}

stop_ssServer() {
	ssServerPid=`ps aux | grep $ssFileName | grep -v grep | awk '{print $2}'`
	
	if [ "$ssServerPid" = "" ]; then
		echo no ss found
	elif [ $ssServerPid -gt 0 ]; then
		kill -9 $ssServerPid ;
	fi
}

send_mail() {
	mailReceiver=$1
	if [ -z $1 ]; then
		echo please input mail receiver.
		exit
	fi
	
	mailContentFile=/tmp/chg_test_pswd_mail.txt
	
	echo "欢迎试用AlaSS测试账号，完整JSON配置信息："		>  $mailContentFile
	echo ""													>> $mailContentFile
	cat  $ssCfgPath/$ssFileName 							>> $mailContentFile
	echo ""													>> $mailContentFile
	echo "中英对照："										>> $mailContentFile
	echo "　　服务器 IP  <=> server"						>> $mailContentFile
	echo "　　服务器端口 <=> server_port"					>> $mailContentFile
	echo "　　密码       <=> password"						>> $mailContentFile
	echo "　　加密       <=> method"						>> $mailContentFile
	echo "　　代理端口   <=> local_port"					>> $mailContentFile
	echo ""													>> $mailContentFile
	echo "请尽快测试，测试账号密码在1小时后失效。"			>> $mailContentFile
	
	#cat $mailContentFile
	mail -s "AlaSS Test Accout Info" $mailReceiver < $mailContentFile
}

main() {
	reset_ssPswd;
	stop_ssServer
	start_ssServer;
	send_mail 'lijj@asiainfo.com';
	send_mail 'yelijuns@gmail.com';
}

main