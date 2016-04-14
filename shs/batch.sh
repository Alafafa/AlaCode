#
#       @Install shadowSock batch
#       @Author: yelijun
#       @Email: yelijuns@gmail.com
#       @Copy right lovelake
#        @Create time 2016-04-14
#

#!/bin/sh

menu()
{
cat <<EOF
#####################################################################
#                                                                   #
#    1. Generate SSH Keys (Optional)                                #
#    2. Install ShadowSocks                                         #
#    3. Base settings, Timezone, group user, etc.                   #
#    4. Optimate the system for SS                                  #
#    5. Install ServerSpeeder for optimate the speed (Optional)     #
#    6. Deploy Alass                                                #
#    7. Set the root Password (Optional)                            #
#    8. Set the alass Password (Optional)                           #
#    q. Quit                                                        #
#                                                                   #
#####################################################################
EOF
}

prefixUri=https://raw.githubusercontent.com/lijiajun/alafafa/master/shs/

getCurrentPath() {
    curPath=`pwd`
}


generateSSHKey() {
    curPath=`pwd`
    generateCFile="$curPath/generateSSH"
    echo $generateCFile
    if [ ! -e $generateCFile ]; then
        wget "${prefixUri}generateSSH" -O ${generateCFile}
        chmod +x $generateCFile
    fi
    
    # Run the generateSSH
    $generateCFile
    
    echo "############## SSH keys has been generated #################"
    echo ""
}

installSS() {
    yum -y install python-setuptools
    easy_install pip
    
    pip install shadowsocks
    ln -s /usr/bin/ssserver /usr/local/bin/ssserver
    
    echo "############## ShadowSocks has been installed #################"
    echo ""
}

setChinaTimezone() {
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

groupAlassAdd() {
    groupExist=`cat /etc/group | grep alass | grep -v grep | wc -l`
    # Different operator system by using the different method, Linux BSD,etc.
    # If the group alass does not exist
    if [ $groupExist -eq 0 ];
    then
        groupadd alass
    fi
}

userAlassAdd() {
    userExist=`cat /etc/passwd | grep alass | grep -v grep | wc -l`
    # Different operator system by using the different method, Linux BSD,etc.
    # If the user alass does not exist
    if [ $userExist -eq 0 ];
    then
        useradd -g alass alass
    fi
}

baseSettings() {
    setChinaTimezone
    groupAlassAdd
    userAlassAdd
    echo "############## Base settings has been set, (Timezone, user and Group) #################"
    echo ""
}

optimateForSS() {
    # For enter os 6.7
    # cat /etc/issue | grep release | awk '{print $3}'
echo '# max open files
fs.file-max = 51200
# max read buffer
net.core.rmem_max = 67108864
# max write buffer
net.core.wmem_max = 67108864
# default read buffer
net.core.rmem_default = 65536
# default write buffer
net.core.wmem_default = 65536
# max processor input queue
net.core.netdev_max_backlog = 4096
# max backlog
net.core.somaxconn = 4096

# resist SYN flood attacks
net.ipv4.tcp_syncookies = 1
# reuse timewait sockets when safe
net.ipv4.tcp_tw_reuse = 1
# turn off fast timewait sockets recycling
net.ipv4.tcp_tw_recycle = 0
# short FIN timeout
net.ipv4.tcp_fin_timeout = 30
# short keepalive time
net.ipv4.tcp_keepalive_time = 1200
# outbound port range
net.ipv4.ip_local_port_range = 10000 65000
# max SYN backlog
net.ipv4.tcp_max_syn_backlog = 4096
# max timewait sockets held by system simultaneously
net.ipv4.tcp_max_tw_buckets = 5000
# turn on TCP Fast Open on both client and server side
net.ipv4.tcp_fastopen = 3
# TCP receive buffer
net.ipv4.tcp_rmem = 4096 87380 67108864
# TCP write buffer
net.ipv4.tcp_wmem = 4096 65536 67108864
# turn on path MTU discovery
net.ipv4.tcp_mtu_probing = 1

# for high-latency network
net.ipv4.tcp_congestion_control = hybla

# for low-latency network, use cubic instead
# net.ipv4.tcp_congestion_control = cubic' > /etc/sysctl.conf

    sysctl -p
    
echo 'alass soft nproc 16384
alass hard nproc 16384
alass soft nofile 65536
alass hard nofile 65536
alass soft memlock 4000000
alass hard memlock 4000000' >> /etc/security/limits.conf

    echo "############## Optimate the server finished #################"
    echo ""
}

installServerSpeeder() {
    wget -N --no-check-certificate https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder-all.sh && bash serverspeeder-all.sh && chkconfig serverSpeeder on
    echo "############## Server Speeder has been installed #################"
    echo ""
}

deployAlass() {
    basePath=/home/alass/
    shPath=${basePath}maintain/shs/
    prefixUri=https://raw.githubusercontent.com/lijiajun/alafafa/master/shs/
    mkdir -p $shPath

    wget ${prefixUri}check_sss.sh -O ${shPath}check_sss.sh
    wget ${prefixUri}reset_test_sss.sh -O ${shPath}reset_test_sss.sh
    wget ${prefixUri}start_sss.sh -O ${shPath}start_sss.sh
	wget ${prefixUri}stop_sss.sh -O ${shPath}stop_sss.sh

	chown -R alass:alass ${basePath}maintain
	chmod +x ${shPath}*.sh

	echo "*/2     *       *       *       *       alass   /bin/sh ${shPath}/check_sss.sh
1       */2     *       *       *       alass   /bin/sh ${shPath}reset_test_sss.sh" >> /etc/crontab

	ssPath=${basePath}shadowsocks/
	mkdir -p ${ssPath}logs
    
    groupAlassAdd
    userAlassAdd
	chown -R alass:alass $ssPath

	touch /tmp/chg_test_pswd_mail.txt
	
	echo "############## Deploy Alass Finished #################"
    echo ""
}

run() {
    menu
    while true
    do
        read -p "Choose the step:" ch
        case $ch in
            1)
                generateSSHKey
                menu
            ;;
            2)
                installSS
                menu
            ;;
            3)
                baseSettings
                menu
            ;;
            4)
                optimateForSS
                menu
            ;;
            5)
                installServerSpeeder
                menu
            ;;
            6)
                deployAlass
                menu
            ;;
            7)
                passwd root
                menu
            ;;
            8)
                userExist=`cat /etc/passwd | grep alass | grep -v grep | wc -l`
                # If the user alass does not exist
                if [ $userExist -ge 1 ];
                then
                    passwd alass
                else
                    echo "Alass user does not exist!"
                fi
                menu
            ;;
            q)
                echo 'Exit the settings!'
                exit
            ;;
        esac
    done
}

# Run the batch
run