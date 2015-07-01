<%
'==============
'参数配置页面
'==============
 const DEBUG_		= true	'调试信息输出开关，注意：调试信息中带有密钥等信息,配置自己的商户信息后请关闭调试
 const PARTNER		= "" 	'财付通商户号
 const PARTNER_KEY	= ""	'财付通密钥
 const APP_ID		= ""	'appid
 const APP_SECRET	= ""	'appsecret
 const APP_KEY		= ""	'paysignkey 128位字符串(非appkey)
 const NOTIFY_URL	= "http://*/notify_url.asp"  '支付完成后的回调处理页面,*替换成notify_url.asp所在路径
 const LOGING_DIR	= ""  '日志保存路径
%>