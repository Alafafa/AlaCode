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
	print "    6)�˲����ʺ�Ϊ�ײ�4��Ӧ�˺ţ��ײ�3�˺��ݲ��ṩ���ԣ��ٶȴ��Ϊ����˺ŵ�2/3."
	print ""
		
	print "++++++++++++++++++++ %s ++++++++++++++++++++ " % (hostAddr)