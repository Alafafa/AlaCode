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
	
	echo "��ӭ����AlaSS�����˺ţ�����JSON������Ϣ��"										>  $mailContentFile
	echo ""																					>> $mailContentFile
	cat  $ssCfgPath/$ssFileName 															>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "�뾡����ԣ������˺�������1Сʱ��ʧЧ��"											>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "��Ӣ���գ�"																		>> $mailContentFile
	echo "���������� IP  <=> server"														>> $mailContentFile
	echo "�����������˿� <=> server_port"													>> $mailContentFile
	echo "��������       <=> password"														>> $mailContentFile
	echo "��������       <=> method"														>> $mailContentFile
	echo "��������˿�   <=> local_port"													>> $mailContentFile
	echo ""																					>> $mailContentFile
	echo "���÷����ɲο�ShadowSocks�ͻ���ʹ�ý̳�: http://www.alafafa.com/?p=89"			>> $mailContentFile
	echo "��������ShadowSocks��Windows�ͻ��ˣ�������Ⱥ:387477811����Ⱥ�����ļ�����"		>> $mailContentFile
	echo "��������֮����ͨ���Ա�����: http://item.taobao.com/item.htm?id=42743439161"		>> $mailContentFile
	
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