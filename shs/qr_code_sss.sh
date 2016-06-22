#!/bin/sh
echo 

jsonFile=$1

ssMethod=`~/maintain/bin/jq  -r '.method' $jsonFile`
ssPswd=`~/maintain/bin/jq  -r '.password' $jsonFile`
ssHost=`~/maintain/bin/jq  -r '.server'   $jsonFile`
ssPort=`~/maintain/bin/jq  -r '.server_port' $jsonFile`
infoBase64=`echo "$ssMethod:$ssPswd@$ssHost:$ssPort"|base64`
paraEncode=`echo -ne "ss://$infoBase64" | hexdump -v -e '/1 "%02x"' | sed 's/\(..\)/%\1/g'`
echo "http://tool.oschina.net/action/qrcode/generate?output=image%2Fgif&error=L&type=0&margin=0&size=4&1466584587150&data=$paraEncode"

echo && echo