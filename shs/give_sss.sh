#!/bin/sh
echo 
ls -l $HOME/shadowsocks|grep flit+|sort -r -k 8|head -n 1|awk '{print $9}'|xargs cat 
echo && echo