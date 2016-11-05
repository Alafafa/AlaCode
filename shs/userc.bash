PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h#$(getEnvVer) \[\e[33m\]\w\[\e[0m\]\n\$ '

export TZ='Asia/Shanghai'

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
export LIBPATH="$LIBPATH"
export SHLIB_PATH="$LIBPATH"
export LD_LIBRARY_PATH="$LIBPATH"

ulimit -c unlimited

if [[ ${USER} == '' ]]; then
	export USER='Sindo'
fi

if [[ ${ENV_VER} == '' ]]; then
	banner "I am "$USER

	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	echo !!!!!!!!!!!!!!!!!!!!!!! Warmly welcome to use Alafafa console !!!!!!!!!!!!!!!!!!
	echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
fi
