<!--#include file="../util/md5.asp"-->
<!--#include file="../util/JSON_2.0.4.asp"-->
<!--#include file="../util/tenpay_util.asp"-->
<%
'
'微信支付服务器签名支付请求请求类
'============================================================================
'api说明：
'init(app_id, app_secret, partner_key, app_key);
'初始化函数，默认给一些参数赋值，如cmdno,date等。
'setKey(key_)'设置商户密钥
'getLasterrCode(),获取最后错误号
'GetToken();获取Token
'getTokenReal();Token过期后实时获取Token
'createMd5Sign(signParams);字典生成Md5签名
'genPackage(packageParams);获取package包
'createSHA1Sign(signParams);创建签名SHA1
'sendPrepay(packageParams);提交预支付
'sendQuery(packageParams);发送查询Notifyid，通知返回中查询使用
'getDebugInfo(),获取debug信息
'============================================================================
'
Class PayRequestHandler
	'Token获取网关地址
	Private tokenUrl
	'预支付网关url地址
	Private gateUrl
	'查询支付通知网关URL
	Private notifyUrl
	'商户参数
	Private appid, partnerkey, appsecret, appkey
	'Token
	Private Token
	'debug信息
	Private debugInfo
	'last error code 
	Private last_errcode
	'初始构造函数
	Private Sub class_initialize()
		last_errcode = 0
		notifyUrl	= "https://gw.tenpay.com/gateway/simpleverifynotifyid.xml"	'验证notify支付订单网关
	End Sub
	
	'初始化函数
	Public Function init(app_id, app_secret, partner_key, app_key)
		debugInfo	= ""
		last_errcode= 0
		appid		= app_id
		partnerkey	= partner_key
		appsecret	= app_secret
		appkey		= app_key
	End Function
	'设置商户密钥
	Public Function setKey(key_)
		partnerkey = key_
	End Function
	'设置微信密钥
	Public Function setAppKey(key_)
		appkey = key_
	End Function	
	'获取最后错误号
	Public Function getLasterrCode()
		getLasterrCode = last_errcode
	End Function
	
	'创建package签名
	Public Function createMd5Sign(signParams)
		Dim keys,k,v,i,j,md5str,sign
		keys	= signParams.Keys()
		'按字母顺序排序
		for i=0 to UBound(keys)-1
			for j=i+1 to UBound(keys)
				if StrComp(keys(i), keys(j)) > 0 then 
					tmp=keys(i)
					keys(i)=keys(j)
					keys(j)=tmp
				end if
			next
		next
		'组合签名字符串
		For Each k in keys
			v = signParams(k)
			if v <> "" and k <> "sign" and k <> "key" then
				md5str	= md5str & k & "=" & v & "&"
			end if
		Next
		'添加key字段
		md5str			= md5str & "key=" & partnerkey
		sign			= UCase(ASP_MD5(md5str))
		createMd5Sign	= sign
		'设置debuginfo
		debugInfo		= debugInfo & "Md5str:" & md5str & " => md5 sign:" & sign & chr(10)
	End Function
	
	'获取package带参数的签名包
	Public Function genPackage(packageParams)
		Dim reqPars,k,sign
		'生成签名
		sign	= createMd5Sign(packageParams)
		'组合package包
		For Each k In packageParams
			reqPars = reqPars & k & "=" & URLencode(packageParams(k)) & "&"
		Next
		genPackage = reqPars & "sign=" & sign
	End Function
	'Map转换成url字符串
	Public Function MaptoString(map)
		Dim reqPars,k
		'组合
		For Each k In map
			If reqPars = "" Then
				reqPars = reqPars & k & "=" & URLencode(map(k))
			Else
				reqPars = reqPars  & "&" & k & "=" & URLencode(map(k))
			End If
		Next
		MaptoString = reqPars
	End Function
	'创建签名SHA1
	Public Function createSHA1Sign(params)
		dim signStr, sign, keys, i, j, tmp, k
		Dim signParams
		Set signParams = Server.CreateObject("Scripting.Dictionary")
		signParams.Add	"appkey", appkey
		keys	= params.Keys()
		For Each k In keys
			signParams.Add		k, params(k)
		Next
		keys	= signParams.Keys()
		'按字母顺序排序
		for i=0 to UBound(keys)-1
			for j=i+1 to UBound(keys)
				if StrComp(keys(i), keys(j)) > 0 then 
					tmp=keys(i)
					keys(i)=keys(j)
					keys(j)=tmp
				end if
			next
		next
		'组合签名字符串
		For Each k In keys
			If signStr = "" Then
				signStr	= k & "=" & signParams(k)
			Else
				signStr = signStr & "&" & k & "=" & signParams(k)
			End If
		Next
		'生成签名
		sign = SHA1(signStr)
		'设置debuginfo
		debugInfo		= debugInfo & "SHA1:" & signStr & " => appsign:" & sign & chr(10)
		createSHA1Sign	= sign
	End Function

	'输出XML
	Public Function parseXML(params)
		dim xmlContent
		xmlContent = "<xml>"
		keys	= params.Keys()
		For Each k In keys
			 If isnumeric(params(k)) Then
        	 	xmlContent	= xmlContent & "<" & k &">" & params(k) & "</" & k &">"
        	 Else
        	 	xmlContent	= xmlContent & "<" & k &"><![CDATA[" & params(k) & "]]></" & k &">"
        	 End If
		Next
        xmlContent	= xmlContent & "</xml>"
        parseXML	= xmlContent
	End Function
	
	'获取debug信息
	Public Function getDebugInfo()
		getDebugInfo	= debugInfo
		debugInfo		= ""
	End Function
End Class

%>