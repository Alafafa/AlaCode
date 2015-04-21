'''
Created on 2014-4-22

@author: Sindo
'''
# coding=utf-8

import os, sys
import string

from email import encoders
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import COMMASPACE,formatdate
from email.mime.multipart import MIMEMultipart

class Toolkit(object):
	@staticmethod
	def printSecSepor():
		print ""
		print "========================================================================"
		print "========================================================================"
		print "========================================================================"
		print ""
	
	@staticmethod
	def saveFileContent(fileName, fileData):
		fileObj = open(fileName, "wb") 
		
		fileObj.write(fileData)
		fileObj.close()
	
	@staticmethod
	def getFileContent(fileName):
		fileObj = open(fileName, "rt") 
		
		fileContent = ""
		strLine = fileObj.readline()
		
		while strLine:
			fileContent = fileContent + strLine
			strLine = fileObj.readline()
		
		return fileContent
	
	@staticmethod
	def sendMail(cfgDict, mailFrom, mailToList, subject, content, fileList=[]): 
		assert type(cfgDict) == dict 
		assert type(mailToList) == list 
		assert type(fileList) == list 
		
		mimeMsg = MIMEMultipart() 
		mimeMsg['From'] = mailFrom 
		mimeMsg['Subject'] = subject 
		mimeMsg['To'] = COMMASPACE.join(mailToList)     #COMMASPACE==', ' 
		mimeMsg['Date'] = formatdate(localtime=True) 
		mimeMsg.attach(MIMEText(content, "html", "UTF-8")) 
		
		for fileName in fileList: 
			part = MIMEBase('application', 'octet-stream') #'octet-stream': binary data 
			part.set_payload(open(file, 'rb'.read())) 
			encoders.encode_base64(part) 
			part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(fileName)) 
			mimeMsg.attach(part) 
		
		import smtplib 
		smtp = smtplib.SMTP(cfgDict['host']) 
		smtp.login(cfgDict['user'], cfgDict['pswd']) 
		smtp.sendmail(mailFrom, mailToList, mimeMsg.as_string()) 
		smtp.close()
		
		return True
	
	@staticmethod
	def encrypt(key, s):
		b = bytearray(str(s).encode("gbk"))
		n = len(b) # 求出 b 的字节数
		c = bytearray(n*2)
		j = 0
		for i in range(0, n):
			b1 = b[i]
			b2 = b1 ^ key # b1 = b2^ key
			c1 = b2 % 16
			c2 = b2 // 16 # b2 = c2*16 + c1
			c1 = c1 + 65
			c2 = c2 + 65 # c1,c2都是0~15之间的数,加上65就变成了A-P 的字符的编码
			c[j] = c1
			c[j+1] = c2
			j = j+2
		return c.decode("gbk")
	
	@staticmethod
	def decrypt(key, s):
		c = bytearray(str(s).encode("gbk"))
		n = len(c) # 计算 b 的字节数
		if n % 2 != 0 :
			return ""
		n = n // 2
		b = bytearray(n)
		j = 0
		for i in range(0, n):
			c1 = c[j]
			c2 = c[j+1]
			j = j+2
			c1 = c1 - 65
			c2 = c2 - 65
			b2 = c2*16 + c1
			b1 = b2^ key
			b[i]= b1
		try:
			return b.decode("gbk")
		except:
			return "failed"

def test_encrypt(strKey, strSrc):
	strDst = Toolkit.encrypt(strKey, strSrc)
	print "%s->%s" % (strSrc, strDst)
	
	return True

def test_decrypt(strKey, strSrc):
	strDst = Toolkit.decrypt(strKey, strSrc)
	print "%s->%s" % (strSrc, strDst)
	
	return True
			
if __name__ == '__main__':
	print "Toolkit_process_begin......" 
	
	resVal = False
	method = ""
	
	while True:
		if len(sys.argv)==0:
			print "arg not valid"
			break
		if len(sys.argv)>1:
			method = sys.argv[1]
			
		if method=="encrypt":
			strKey= string.atoi(sys.argv[2])
			strSrc= sys.argv[3]
			resVal = test_encrypt(strKey, strSrc)
		elif method=="decrypt":
			strKey= string.atoi(sys.argv[2])
			strSrc= sys.argv[3]
			resVal = test_decrypt(strKey, strSrc)
		else:
			userName = 'lijj'
			userPswd = os.getenv("aintPswd")
		
		break
		
	if resVal: print "congratulations_your_work_is_successful" 
	else:      print ":( unfortunately_your_work_is_failed ):"
	