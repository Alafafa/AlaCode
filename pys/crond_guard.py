#-*- encoding: gbk -*-
import os,sys
import time
import string
import paramiko

from datetime import date
from datetime import datetime
from alafafa.util.Toolkit import Toolkit

def exec_command(hostAddr, hostUser, hostPswd):
	nowTime = datetime.now()
	todayDate = date.today()
	print "login %s@%s ...... {{{ %4d-%2d-%2d %2d:%2d:%2d" % (hostUser, hostAddr, todayDate.year, todayDate.month, todayDate.day, nowTime.hour, nowTime.minute, nowTime.second)
	
	try:  
		ssh = paramiko.SSHClient()  
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())  
		ssh.connect(hostAddr, 22, hostUser, hostPswd, timeout=30)
		
		nowTime = datetime.now()
		
		stdin, stdout, stderr = ssh.exec_command("ps -ef|grep crond|grep -v grep|wc -l")  
		#stdin.write("Y")   #简单交互，输入 ‘Y’  
		 
		outLines = stdout.readlines()
		
		crondAlive = True
		#屏幕输出  
		if len(outLines) == 1:
			if outLines[0].strip() == "1":
				print "\tcrond is alive"
				crondAlive = True
			else:
				print "\tcrond is dead"
				crondAlive = False
		else:
			print "t\the output is not valid:%d" % (len(outLines))
			
		if crondAlive == False:
			stdin, stdout, stderr = ssh.exec_command("service crond start")
			outLines = stdout.readlines()
			
			for outLine in outLines:
				print outLine,
		
		ssh.close()  
	except :  
		print '\t%s is not available.' % (hostAddr)

	nowTime = datetime.now()
	todayDate = date.today()
	print "}}} %4d-%2d-%2d %2d:%2d:%2d" % (todayDate.year, todayDate.month, todayDate.day, nowTime.hour, nowTime.minute, nowTime.second)
		
if __name__=='__main__':
	oldStdOut = None  
	newStdOut = None 
	
	userHome = os.getenv("HOME")
	try:  
		newStdOut = open(userHome + "/maintain/log/crond_guard.log","w+")  
		oldStdOut = sys.stdout  
		sys.stdout = newStdOut  
			
		hostUser = "root"
		hostAddr= "glow.alafafa.com"
		hostPswd = os.getenv("rootPswd")
		sleepMin = 0		#sleep x minutes, if 0 then break
		
		if len(sys.argv)>1:
			hostAddr = sys.argv[1]
		if len(sys.argv)>2:
			hostPswd = sys.argv[2]
		if len(sys.argv)>3:
			sleepMin = string.atoi(sys.argv[3])
		
		if hostPswd =="console":
			print "please_input_password: ",
			hostPswd = sys.stdin.readline().rstrip()
		elif hostPswd[0:8] == "ALAFAFA-":
			encryptPswd=hostPswd[8:]
			hostPswd = Toolkit.decrypt(32, encryptPswd)
			
		while True:
			exec_command(hostAddr, hostUser, hostPswd)
			if sleepMin >0:
				print "sleeping %d minutes......" % (sleepMin)
				newStdOut.flush()
				time.sleep(sleepMin*60)
			else:
				break
	finally:  
		if newStdOut:  
			newStdOut.close()  
		if oldStdOut:  
			sys.stdout = oldStdOut