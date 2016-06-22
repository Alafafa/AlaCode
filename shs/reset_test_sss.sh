#!/bin/sh
ssFileName=NULL
ssCfgPath=/home/alass/shadowsocks
ssSrvBinFile=/usr/local/bin/ssserver
ssPrefixCfgFileName=`hostname | cut -d . -f 1`

pick_ssFile() {
	currHour=`date +%H`
	fileFlag=`expr $currHour / 2 % 2`
	
	if [ "$fileFlag" = "0" ]; then
		ssFileName=$ssPrefixCfgFileName+0.json
	else
		ssFileName=$ssPrefixCfgFileName+1.json
	fi
}

reset_ssPswd() {
	ssPassWord=`date +%s | sha256sum | base64 | head -c 12; echo`
	sed -i 's/password.*$/password":"'$ssPassWord'",/' $ssCfgPath/$ssFileName
}

set_ssServer() {
	sed -i 's/server".*$/server":"'$HOSTNAME'",/' $ssCfgPath/$ssFileName
}

start_ssServer() {
	logFileName=`echo $ssFileName | sed s/.json//g`
	cd $ssCfgPath
	nohup $ssSrvBinFile -c $ssFileName > logs/nohup_$logFileName.out 2>&1 < /dev/null &
	cd -
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
	# mailReceiver=$1
	# if [ -z $1 ]; then
		# echo please input mail receiver.
		# exit
	# fi
		
	mailContentFile=/tmp/chg_test_pswd_mail.txt
	
	echo "欢迎试用AlaSS测试账号，完整JSON配置信息："										>  $mailContentFile
	echo ""																					>> $mailContentFile
	cat  $ssCfgPath/$ssFileName 															>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "请尽快测试，测试账号密码在2小时后失效。"											>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "中英对照："																		>> $mailContentFile
	echo "　　服务器 IP  <=> server"														>> $mailContentFile
	echo "　　服务器端口 <=> server_port"													>> $mailContentFile
	echo "　　密码       <=> password"														>> $mailContentFile
	echo "　　加密       <=> method"														>> $mailContentFile
	echo "　　代理端口   <=> local_port"													>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "配置方法可参考ShadowSocks(简称SS)客户端教程: http://www.alafafa.com/?p=89"		>> $mailContentFile
	echo "如需下载SS的Win客户端，请用抠抠加我们的官方群:387477811，在共享文件中下载"		>> $mailContentFile
	echo "测试满意之后，请通过淘宝购买: http://item.taobao.com/item.htm?id=42743439161"		>> $mailContentFile
	
	#mail -s "AlaSS Test Account Info" 'lijj@asiainfo.com' 'lijiajun@gmail.com' 'yelijuns@gmail.com' < $mailContentFile
	cat $mailContentFile|mail -s "AlaSS Test Account Info" 'lijj@asiainfo.com' 'yelijuns@gmail.com'
}

main() {
	pick_ssFile;
	reset_ssPswd;
	set_ssServer;
	stop_ssServer;
	start_ssServer;
	#send_mail;
}

main
