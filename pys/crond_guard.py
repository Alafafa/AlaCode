#-*- encoding: gbk -*-
import os,sys
import paramiko

rightHostAddr = "Not Available"

def exec_command(hostAddr, hostUser, hostPswd):  
	try:  
		ssh = paramiko.SSHClient()  
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
		ssh.connect(hostAddr, 22, hostUser, hostPswd, timeout=30)
		
		print "login %s@%s ...... {{{"  % (hostUser, hostAddr)
		
		stdin, stdout, stderr = ssh.exec_command("ps -ef|grep crond|grep -v grep|wc -l")  
		#stdin.write("Y")   #简单交互，输入 ‘Y’   
		outLines = stdout.readlines()
		
		crondAlive = True
		#屏幕输出  
		if len(outLines) == 1:
			if outLines[0].strip() == "1":
				print "crond is alive"
				crondAlive = True
			else:
				print "crond is dead"
				crondAlive = False
		else:
			print "the output is not valid:%d" % (len(outLines))
			
		if crondAlive == False:
			stdin, stdout, stderr = ssh.exec_command("service crond start")
			outLines = stdout.readlines()
			
			for outLine in outLines:
				print outLine,
		
		ssh.close()  
		
		print "}}}"
	except :  
		print '%s is not available.' % (hostAddr)
		
if __name__=='__main__':  
	hostAddr= "saber.alafafa.com"
	
	#hostIpSeg= "10.10.15"
	hostUser = "root"  					#主机用户  
	hostPswd = os.getenv("rootPswd")	#主机密码  
	
	exec_command(hostAddr, hostUser, hostPswd)