<!--#include file="../util/md5.asp"-->
<!--#include file="../util/JSON_2.0.4.asp"-->
<!--#include file="../util/tenpay_util.asp"-->
<%
'
'΢��֧��������ǩ��֧������������
'============================================================================
'api˵����
'init(app_id, app_secret, partner_key, app_key);
'��ʼ��������Ĭ�ϸ�һЩ������ֵ����cmdno,date�ȡ�
'setKey(key_)'�����̻���Կ
'getLasterrCode(),��ȡ�������
'GetToken();��ȡToken
'getTokenReal();Token���ں�ʵʱ��ȡToken
'createMd5Sign(signParams);�ֵ�����Md5ǩ��
'genPackage(packageParams);��ȡpackage��
'createSHA1Sign(signParams);����ǩ��SHA1
'sendPrepay(packageParams);�ύԤ֧��
'sendQuery(packageParams);���Ͳ�ѯNotifyid��֪ͨ�����в�ѯʹ��
'getDebugInfo(),��ȡdebug��Ϣ
'============================================================================
'
Class PayRequestHandler
	'Token��ȡ���ص�ַ
	Private tokenUrl
	'Ԥ֧������url��ַ
	Private gateUrl
	'��ѯ֧��֪ͨ����URL
	Private notifyUrl
	'�̻�����
	Private appid, partnerkey, appsecret, appkey
	'Token
	Private Token
	'debug��Ϣ
	Private debugInfo
	'last error code 
	Private last_errcode
	'��ʼ���캯��
	Private Sub class_initialize()
		last_errcode = 0
		notifyUrl	= "https://gw.tenpay.com/gateway/simpleverifynotifyid.xml"	'��֤notify֧����������
	End Sub
	
	'��ʼ������
	Public Function init(app_id, app_secret, partner_key, app_key)
		debugInfo	= ""
		last_errcode= 0
		appid		= app_id
		partnerkey	= partner_key
		appsecret	= app_secret
		appkey		= app_key
	End Function
	'�����̻���Կ
	Public Function setKey(key_)
		partnerkey = key_
	End Function
	'����΢����Կ
	Public Function setAppKey(key_)
		appkey = key_
	End Function	
	'��ȡ�������
	Public Function getLasterrCode()
		getLasterrCode = last_errcode
	End Function
	
	'����packageǩ��
	Public Function createMd5Sign(signParams)
		Dim keys,k,v,i,j,md5str,sign
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
		For Each k in keys
			v = signParams(k)
			if v <> "" and k <> "sign" and k <> "key" then
				md5str	= md5str & k & "=" & v & "&"
			end if
		Next
		'���key�ֶ�
		md5str			= md5str & "key=" & partnerkey
		sign			= UCase(ASP_MD5(md5str))
		createMd5Sign	= sign
		'����debuginfo
		debugInfo		= debugInfo & "Md5str:" & md5str & " => md5 sign:" & sign & chr(10)
	End Function
	
	'��ȡpackage��������ǩ����
	Public Function genPackage(packageParams)
		Dim reqPars,k,sign
		'����ǩ��
		sign	= createMd5Sign(packageParams)
		'���package��
		For Each k In packageParams
			reqPars = reqPars & k & "=" & URLencode(packageParams(k)) & "&"
		Next
		genPackage = reqPars & "sign=" & sign
	End Function
	'Mapת����url�ַ���
	Public Function MaptoString(map)
		Dim reqPars,k
		'���
		For Each k In map
			If reqPars = "" Then
				reqPars = reqPars & k & "=" & URLencode(map(k))
			Else
				reqPars = reqPars  & "&" & k & "=" & URLencode(map(k))
			End If
		Next
		MaptoString = reqPars
	End Function
	'����ǩ��SHA1
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
		sign = SHA1(signStr)
		'����debuginfo
		debugInfo		= debugInfo & "SHA1:" & signStr & " => appsign:" & sign & chr(10)
		createSHA1Sign	= sign
	End Function

	'���XML
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
	
	'��ȡdebug��Ϣ
	Public Function getDebugInfo()
		getDebugInfo	= debugInfo
		debugInfo		= ""
	End Function
End Class

%>