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

	echo "SS账号二维码生成地址(可以省去输入的烦恼)："
	echo
	echo "http://tool.oschina.net/action/qrcode/generate?output=image%2Fgif&error=L&type=0&margin=0&size=4&data=$paraEncode"
	echo
	echo "二维码使用方法①:右键点击SS电脑客户端系统栏图标，点服务器，扫描屏幕上的二维码"
	echo "二维码使用方法②:打开安卓手机SS客户端，点击\"shadowsocks\"，点击+号，扫描二维码"
fi

echo && echo