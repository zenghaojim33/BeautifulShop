<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayResponseHandler.asp"-->
<%
'=================================
'άȨ�ӿ�
'=================================
'����֧��Ӧ�����
Dim resHandler
Set resHandler = new PayResponseHandler
resHandler.Init
'��ʼ��ҳ���ύ�����Ĳ���
resHandler.setKey "", APP_KEY

log_result("feeback:"&chr(10)&resHandler.getDebugInfo&chr(10))
'�ж�ǩ��
If resHandler.isWXsign() = True Then
	'�ظ�����������ɹ�
	Response.Write("ok")
Else'SHA1ǩ��ʧ��
	Response.Write("fail")
	log_result("debugInfo:" & resHandler.getDebugInfo & chr(10))
End If
%>