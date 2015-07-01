<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayResponseHandler.asp"-->
<%
'=================================
'维权接口
'=================================
'创建支付应答对象
Dim resHandler
Set resHandler = new PayResponseHandler
resHandler.Init
'初始化页面提交过来的参数
resHandler.setKey "", APP_KEY

log_result("feeback:"&chr(10)&resHandler.getDebugInfo&chr(10))
'判断签名
If resHandler.isWXsign() = True Then
	'回复服务器处理成功
	Response.Write("ok")
Else'SHA1签名失败
	Response.Write("fail")
	log_result("debugInfo:" & resHandler.getDebugInfo & chr(10))
End If
%>