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
	
	if len(sys.argv)>1:
		hostAddr= sys.argv[1]
	
	print "++++++++++++++++++++ %s ++++++++++++++++++++ " % (hostAddr)
	
	execCmds = [
			'sh ~/maintain/shs/give_sss.sh'
	]	#ִ�������б�  

	hostUser = "alass"  					#�����û�  
	hostPswd = os.getenv("alasPswd")		#��������  

	remote_exec(hostAddr, hostUser, hostPswd, execCmds)
	
	print "��ӭ���Կɿ��ֿ��ٵ�AlaSS������ע��:"
	print "    1)����ʹ�ñ��˺����ش���100M�����;"
	print "    2)����ʹ�ñ��˺����ص��������������Ƶ;"
	print "    3)����ʹ�ñ��˺�bt����;"
	print "    4)����������˴������˺�;"
	print "    5)�뾡����ԣ����˺���Чʱ��Ϊ2Сʱ�����������Զ�ʧЧ;"
	print ""
		
	print "++++++++++++++++++++ %s ++++++++++++++++++++ " % (hostAddr)