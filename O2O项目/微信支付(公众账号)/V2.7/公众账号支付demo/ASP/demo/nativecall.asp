<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayRequestHandler.asp"-->
<%
'=================================
'native商品信息回调接口
'=================================
'初始化
Set payHandler	= new PayRequestHandler
payHandler.init APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY

out_trade_no = getStrNow & getStrRandNumber(9999,1000)
'设置package订单参数
Set packageParams = Server.CreateObject("Scripting.Dictionary")
packageParams.Add	"bank_type",	"WX"	    		'支付类型
packageParams.Add	"body",			"商品名称"		    '商品描述
packageParams.Add	"fee_type",		"1"					'银行币种
packageParams.Add	"input_charset","GBK"			    '字符集
packageParams.Add	"notify_url",	NOTIFY_URL			'通知地址
packageParams.Add	"out_trade_no",	out_trade_no		'商户订单号
packageParams.Add	"partner",		PARTNER				'设置商户号
packageParams.Add	"total_fee",	"1"					'商品总金额,以分为单位
packageParams.Add	"spbill_create_ip",	Request.ServerVariables("REMOTE_ADDR")	'支付机器IP

'获取package包
package		= payHandler.genPackage(packageParams)

'设置支付参数
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