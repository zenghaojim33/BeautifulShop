<!--#include file="./PayRequestHandler.asp"-->
<%
'
'΢��֧��������ǩ��֧������Ӧ����
'============================================================================
'api˵����
'getKey()/setKey(),��ȡ/������Կ
'getParameter()/setParameter(),��ȡ/���ò���ֵ
'getAllParameters(),��ȡ���в���
'isValidSign(),�Ƿ���ȷ��ǩ��,true:�� false:��
'isWXsign(),�Ƿ���ȷ��ǩ��,true:�� false:��
'getDebugInfo(),��ȡdebug��Ϣ
'============================================================================
'
Class PayResponseHandler

	'�̻���Կ��app��Կ
	Private key,appkey

	'Ӧ��Ĳ���
	Private parameters
	'debug��Ϣ
	Private xmlMap
	'debug��Ϣ
	Private debugInfo
	
	'��ʼ���캯��
	Private Sub class_initialize()
		key = ""
		Set parameters = Server.CreateObject("Scripting.Dictionary")	'���ü���
		debugInfo = ""
		parameters.RemoveAll
	End Sub
	'��ȡҳ���ύ��get��post����
	Public Function Init
		'��ȡ�������Ĳ���
		Dim k, v
		'��ȡҳ��GET����
		For Each k In Request.QueryString
			v = Request.QueryString(k)
			setParameter k,v
		Next
		'��ȡҳ��POST����
		For Each k In Request.Form
			v = Request(k)
			setParameter k,v
		Next
		'����post������xml����
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
	'��ȡ��Կ
	Public Function getKey()
		getKey	= key
	End Function
	
	'������Կ
	Public Function setKey(key_, appkey_)
		key		= key_
		appkey	= appkey_
	End Function
	
	'��ȡ����ֵ
	Public Function getParameter(parameter)
		getParameter = parameters.Item(parameter)
	End Function
	
	'���ò���ֵ
	Public Sub setParameter(parameter, parameterValue)
		If parameters.Exists(parameter) = True Then
			parameters.Remove(parameter)
		End If
		parameters.Add parameter, parameterValue	
	End Sub
	'��ղ���ֵ
	Public Sub clearParameter()
		parameters.RemoveAll
	End Sub
	
	'��ȡ��������Ĳ���,����Scripting.Dictionary
	Public Function getAllParameters()
		getAllParameters = parameters
	End Function

	'�Ƿ�Ƹ�ͨǩ��
	'true:�� false:��
	Public Function isValidSign()
		Dim keys,k,v,i,j,md5str,sign
		keys	= parameters.Keys()
		'����ĸ˳������
		for i=0 to UBound(keys)-1
			for j=i+1 to UBound(keys)
				if StrComp(keys(i), keys(j)) > 0 then 
					tmp=keys(i)
					keys(i)=keys(j)
					keys(j)=tmp
				end if
			next
		next
		'���ǩ���ַ���
		For Each k in keys
			v = parameters(k)
			if v <> "" and k <> "sign" and k <> "key" then
				md5str	= md5str & k & "=" & v & "&"
			end if
		Next
		'���key�ֶ�
		md5str			= md5str & "key=" & key
		sign			= UCase(ASP_MD5(md5str))
		'����debuginfo
		debugInfo		= debugInfo & "Md5str:" & md5str & " => md5 sign:" & sign & ";sendSign="& getParameter("sign") &chr(10)
		
		isValidSign = (sign = getParameter("sign"))
	End Function
	'�ж�΢��ǩ��
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
			'����ĸ˳������
			for i=0 to UBound(keys)-1
				for j=i+1 to UBound(keys)
					if StrComp(keys(i), keys(j)) > 0 then 
						tmp=keys(i)
						keys(i)=keys(j)
						keys(j)=tmp
					end if
				next
			next
			'���ǩ���ַ���
			For Each k In keys
				If signStr = "" Then
					signStr	= k & "=" & signParams(k)
				Else
					signStr = signStr & "&" & k & "=" & signParams(k)
				End If
			Next
			'����ǩ��
			sign	= SHA1(signStr)
			appsign = xmlMap("AppSignature")
			'����debuginfo
			debugInfo		= debugInfo & "SHA1:" & signStr & " => appsign:" & sign &  ";wxSHA1Sign:" & appsign & chr(10)
			isWXsign = (sign = appsign)
		Else
			isWXsign = False
		End If
	End Function
	'��ȡdebug��Ϣ
	Function getDebugInfo()
		getDebugInfo = debugInfo
	End Function
End Class
%>