#!/bin/sh
echo 
scriptPath=`pwd` 
hostAbbr=`hostname | cut -d . -f 1`
latestJson=~/shadowsocks/`ls -l ~/shadowsocks|grep $hostAbbr+|sort -r -k 8|head -n 1|awk '{print $9}'`
cat $latestJson

if [ "$1" = "qr_code" ]; then
	ssMethod=`~/maintain/bin/jq  -r '.method' $latestJson`
	ssPswd=`~/maintain/bin/jq  -r '.password' $latestJson`
	ssHost=`~/maintain/bin/jq  -r '.server'   $latestJson`
	ssPort=`~/maintain/bin/jq  -r '.server_port' $latestJson`
	infoBase64=`echo "$ssMethod:$ssPswd@$ssHost:$ssPort"|base64`
	paraEncode=`echo -ne "ss://$infoBase64" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'`

	echo && echo

	echo "SS�˺Ŷ�ά�����ɵ�ַ(����ʡȥ����ķ���)��"
	echo
	echo "http://tool.oschina.net/action/qrcode/generate?output=image%2Fgif&error=L&type=0&margin=0&size=4&data=$paraEncode"
	echo
	echo "��ά��ʹ�÷�����:�Ҽ����SS���Կͻ���ϵͳ��ͼ�꣬���������ɨ����Ļ�ϵĶ�ά��"
	echo "��ά��ʹ�÷�����:�򿪰�׿�ֻ�SS�ͻ��ˣ����\"shadowsocks\"�����+�ţ�ɨ���ά��"
fi

echo && echo