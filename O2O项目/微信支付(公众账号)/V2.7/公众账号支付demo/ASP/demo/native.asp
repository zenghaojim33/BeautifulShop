<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayRequestHandler.asp"-->
<%
'============================
'����ԭ��֧��url
'weixin://wxpay/bizpayurl?sign=XXXXX&appid=XXXXXX&productid=XXXXXX&timestamp=XXXXXX&noncestr=XXXXXX
'=============================
productid		= "1234567890"
Set payHandler	= new PayRequestHandler
payHandler.init APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY

Set outParams = Server.CreateObject("Scripting.Dictionary")
outParams.Add	"appid",		APP_ID
outParams.Add	"noncestr",		getNoncestr
outParams.Add	"timestamp",	getTimestamp
outParams.Add	"productid",	productid
Dim sign
sign	= payHandler.createSHA1Sign(outParams)
outParams.Add	"sign",			sign
Dim parm
parm = "weixin://wxpay/bizpayurl?" & payHandler.MaptoString(outParams)
%>
<center><a href="<%=parm%>">���֧��(΢�������)</a><br>ɨ��֧��</br><img src="<%=QRfromGoogle(parm)%>" alt="QR code"/></center>
