function getEnvVer {
	#[[ -n $(jobs) ]] && echo -e "\e[7m"
	echo $ENV_VER
}

function chenv {
	export ENV_NOT_ECHO=1
	chrel
	unset ENV_NOT_ECHO
	#echo 
	#chver
}

function kill_sshd {
	ps aux|grep sshd|grep -v sbin|grep -v grep|awk '{print $2}' | xargs kill -9
}

function chver {
	echo +------------------------------------------------------------------------------+
	echo + 当前可用的OB_REL有：
	echo +  1.[通用版本]
	echo +  2.[多租户版本]
	echo +------------------------------------------------------------------------------+
	read -p 请输入你的选择\> envIdx
}