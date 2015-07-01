<!--#include file="./PayRequestHandler.asp"-->
<%
'
'微信支付服务器签名支付请求应答类
'============================================================================
'api说明：
'getKey()/setKey(),获取/设置密钥
'getParameter()/setParameter(),获取/设置参数值
'getAllParameters(),获取所有参数
'isValidSign(),是否正确的签名,true:是 false:否
'isWXsign(),是否正确的签名,true:是 false:否
'getDebugInfo(),获取debug信息
'============================================================================
'
Class PayResponseHandler

	'商户密钥，app密钥
	Private key,appkey

	'应答的参数
	Private parameters
	'debug信息
	Private xmlMap
	'debug信息
	Private debugInfo
	
	'初始构造函数
	Private Sub class_initialize()
		key = ""
		Set parameters = Server.CreateObject("Scripting.Dictionary")	'设置集合
		debugInfo = ""
		parameters.RemoveAll
	End Sub
	'获取页面提交的get和post参数
	Public Function Init
		'获取传过来的参数
		Dim k, v
		'获取页面GET参数
		For Each k In Request.QueryString
			v = Request.QueryString(k)
			setParameter k,v
		Next
		'获取页面POST参数
		For Each k In Request.Form
			v = Request(k)
			setParameter k,v
		Next
		'接受post过来的xml数据
		Set xmlMap = Server.CreateObject("Scripting.Dictionary")
		Dim varCount,varReq,xmldom
		varCount = Request.TotalBytes
		varReq = Request.BinaryRead(varCount)
		Dim content
		If varCount > 0 And Request.ServerVariables("REQUEST_METHOD") = "POST" Then
			Set xmlDoc = Server.CreateObject("MSXML2.DOMDocument")
			xmlDoc.load varReq

			Set obj =  xmlDoc.selectSingleNode("xml")
			For Each node in obj.childnodes
				xmlMap.Add node.nodename, node.text
				content = content & node.nodename &"=" &node.text & chr(10)
			Next
		End If
		debugInfo		= debugInfo & "postData:" & content
	End Function
	'获取密钥
	Public Function getKey()
		getKey	= key
	End Function
	
	'设置密钥
	Public Function setKey(key_, appkey_)
		key		= key_
		appkey	= appkey_
	End Function
	
	'获取参数值
	Public Function getParameter(parameter)
		getParameter = parameters.Item(parameter)
	End Function
	
	'设置参数值
	Public Sub setParameter(parameter, parameterValue)
		If parameters.Exists(parameter) = True Then
			parameters.Remove(parameter)
		End If
		parameters.Add parameter, parameterValue	
	End Sub
	'清空参数值
	Public Sub clearParameter()
		parameters.RemoveAll
	End Sub
	
	'获取所有请求的参数,返回Scripting.Dictionary
	Public Function getAllParameters()
		getAllParameters = parameters
	End Function

	'是否财付通签名
	'true:是 false:否
	Public Function isValidSign()
		Dim keys,k,v,i,j,md5str,sign
		keys	= parameters.Keys()
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
			v = parameters(k)
			if v <> "" and k <> "sign" and k <> "key" then
				md5str	= md5str & k & "=" & v & "&"
			end if
		Next
		'添加key字段
		md5str			= md5str & "key=" & key
		sign			= UCase(ASP_MD5(md5str))
		'设置debuginfo
		debugInfo		= debugInfo & "Md5str:" & md5str & " => md5 sign:" & sign & ";sendSign="& getParameter("sign") &chr(10)
		
		isValidSign = (sign = getParameter("sign"))
	End Function
	'判断微信签名
	Function isWXsign()
		dim signStr, sign, keys, i, j, tmp, k
		Dim signParams
		If xmlMap.Count > 0 Then
			Set signParams = Server.CreateObject("Scripting.Dictionary")
			signParams.Add	"appkey", appkey
			keys	= xmlMap.Keys()
			For Each k In keys
				v = xmlMap(k)
				if k <> "SignMethod" and k <> "AppSignature" then
					signParams.Add		Lcase(k) , v
				end if
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
			sign	= SHA1(signStr)
			appsign = xmlMap("AppSignature")
			'设置debuginfo
			debugInfo		= debugInfo & "SHA1:" & signStr & " => appsign:" & sign &  ";wxSHA1Sign:" & appsign & chr(10)
			isWXsign = (sign = appsign)
		Else
			isWXsign = False
		End If
	End Function
	'获取debug信息
	Function getDebugInfo()
		getDebugInfo = debugInfo
	End Function
End Class
%>