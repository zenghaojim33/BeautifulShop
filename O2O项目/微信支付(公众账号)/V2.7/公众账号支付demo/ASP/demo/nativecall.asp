<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayRequestHandler.asp"-->
<%
'=================================
'native��Ʒ��Ϣ�ص��ӿ�
'=================================
'��ʼ��
Set payHandler	= new PayRequestHandler
payHandler.init APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY

out_trade_no = getStrNow & getStrRandNumber(9999,1000)
'����package��������
Set packageParams = Server.CreateObject("Scripting.Dictionary")
packageParams.Add	"bank_type",	"WX"	    		'֧������
packageParams.Add	"body",			"��Ʒ����"		    '��Ʒ����
packageParams.Add	"fee_type",		"1"					'���б���
packageParams.Add	"input_charset","GBK"			    '�ַ���
packageParams.Add	"notify_url",	NOTIFY_URL			'֪ͨ��ַ
packageParams.Add	"out_trade_no",	out_trade_no		'�̻�������
packageParams.Add	"partner",		PARTNER				'�����̻���
packageParams.Add	"total_fee",	"1"					'��Ʒ�ܽ��,�Է�Ϊ��λ
packageParams.Add	"spbill_create_ip",	Request.ServerVariables("REMOTE_ADDR")	'֧������IP

'��ȡpackage��
package		= payHandler.genPackage(packageParams)

'����֧������
Set outParams = Server.CreateObject("Scripting.Dictionary")
outParams.Add	"AppId",		APP_ID
outParams.Add	"NonceStr",		getNoncestr
outParams.Add	"Package",		package
outParams.Add	"TimeStamp",	getTimestamp
outParams.Add	"RetCode",		0
outParams.Add	"RetErrMsg",	"OK"
Dim sign
sign			= payHandler.createSHA1Sign(outParams)
outParams.Add	"app_signature",sign
outParams.Add	"sign_method",	"SHA1"

Response.ContentType="text/xml"
Response.clear
Response.write payHandler.parseXML(outParams)
%>