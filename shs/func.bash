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
	echo + ��ǰ���õ�OB_REL�У�
	echo +  1.[ͨ�ð汾]
	echo +  2.[���⻧�汾]
	echo +------------------------------------------------------------------------------+
	read -p ���������ѡ��\> envIdx
}