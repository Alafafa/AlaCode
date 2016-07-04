#-*- encoding: gb2312 -*-
import os,sys
import paramiko
import threading  

rightHostAddr = "Not Available"

def remote_exec(hostAddr, hostUser, hostPswd, execCmds):  
	#try:  
		ssh = paramiko.SSHClient()  
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
		ssh.connect(hostAddr, 22, hostUser, hostPswd, timeout=3)
		
		for m in execCmds:  
			stdin, stdout, stderr = ssh.exec_command(m)  
			out = stdout.readlines()  
			for o in out:  
				print o,  
		ssh.close()  
	#except :  
	#	print '%s\tError\n' % (hostAddr)
		
if __name__=='__main__':  
	hostAddr= "saber.alafafa.com"
	giveFlag = ""
	
	if len(sys.argv)>1 and sys.argv[1] != "none":
		hostAddr= sys.argv[1]
	if len(sys.argv)>2 and sys.argv[2] != "none":
		giveFlag= sys.argv[2]
	
	print "++++++++++++++++++++ %s ++++++++++++++++++++ " % (hostAddr)
	
	execCmds = [
			'sh ~/maintain/shs/give_sss.sh ' + giveFlag
	]	#执行命令列表  

	hostUser = "alass"  					#主机用户  
	hostPswd = os.getenv("alasPswd")		#主机密码  

	remote_exec(hostAddr, hostUser, hostPswd, execCmds)
	
	print "欢迎测试可靠又快速的AlaSS，另请注意:"
	print "    1)请勿使用本账号下载大于100M的软件;"
	print "    2)请勿使用本账号下载盗版软件、盗版视频;"
	print "    3)请勿使用本账号bt下载;"
	print "    4)请勿向第三人传播本账号;"
	print "    5)请尽快测试，本账号有效时间为2小时，过期密码自动失效;"
	print "    6)此测试帐号为套餐4对应账号，套餐3账号暂不提供测试，速度大概为这个账号的2/3."
	print ""
		
	print "++++++++++++++++++++ %s ++++++++++++++++++++ " % (hostAddr)