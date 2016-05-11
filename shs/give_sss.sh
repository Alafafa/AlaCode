#!/bin/sh
echo 
hostAbbr=`hostname | cut -d . -f 1`
latestJson=`ls -l ~/shadowsocks|grep $hostAbbr+|sort -r -k 8|head -n 1|awk '{print $9}'`
cat ~/shadowsocks/$latestJson
echo && echo