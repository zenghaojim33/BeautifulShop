<%
'获取时间字符串, 格式YYYYMMDDhhmiss
Public Function getStrNow()
	strNow = Now()
	strNow = Year(strNow) & Right(("00" & Month(strNow)),2) & Right(("00" & Day(strNow)),2) & Right(("00" & Hour(strNow)),2) & Right(("00" &  Minute(strNow)),2) & Right(("00" & Second(strNow)),2)
	getStrNow = strNow
End Function

' 获取服务器日期，格式YYYYMMDD
Public Function getServerDate()
	getServerDate = Left(getStrNow,8)
End Function

'获取时间,格式hhmiss 如:192030
Public Function getTime()
	getTime = Right(getStrNow,6)
End Function

'获取随机数,返回 [min,max]范围的数
Function getRandNumber(max, min)
	Randomize 
	getRandNumber = CInt((max-min+1)*Rnd()+min) 
End Function

'获取随机数字的字符串,返回[min,max]范围的数字字符串
Function getStrRandNumber(max, min)
	randNumber = getRandNumber(max, min)
	getStrRandNumber = CStr(randNumber)
End Function

'发送请求返回数据
Function httpSend(url, method, data)
	Dim httpClient
	set httpClient = CreateObject("Msxml2.ServerXMLHTTP.3.0")
	'打开验证Url连接
	httpClient.Open method, url ,False
	'提交请求
	httpClient.Send data
	httpSend = httpClient.responseText
End Function
	
'写日志，方便测试（看网站需求，也可以改成存入数据库）
'sWord 要写入日志里的文本内容
Function log_result(sWord)
	If DEBUG_ = true Then
		set fs= createobject("scripting.filesystemobject")
		If LOGING_DIR <> "" Then 
			dir = LOGING_DIR
		Else
			dir = server.MapPath("/")
		End If
		set ts=fs.OpenTextFile(dir & "/" &getServerDate() & ".txt", 8, true)
		ts.writeline("time:"&getTime())
		ts.writeline(sWord)
		ts.close
		set ts=Nothing
		set fs=Nothing
	End If
End Function

'Xml 编码
Function XmlEncode(byVal sText)
	sText = Replace(sText, "&" , "&amp;") 
	sText = Replace(sText, "<" , "&lt;") 
	sText = Replace(sText, ">" , "&gt;") 
	sText = Replace(sText, "'" , "&apos;") 
	sText = Replace(sText, """", "&quot;") 
	XmlEncode = sText
End Function
'Xml 解码
Function XmlDecode(byVal sText)
	sText = Replace(sText, "&amp;", "&" )
	sText = Replace(sText, "&lt;", "<")
	sText = Replace(sText, "&gt;", ">")
	sText = Replace(sText, "&apos;", "'")
	sText = Replace(sText, "&quot;", """")
	XmlDecode = sText
End Function
'url编码，添加空格转成%20
Function URLencode(content)
	URLencode	= Replace(Server.URLencode(content), "+", "%20")
End Function
' jsencoding
Function jsEncode(str)
    Dim charmap(127), haystack()
    charmap(8)  = "\b"
    charmap(9)  = "\t"
    charmap(10) = "\n"
    charmap(12) = "\f"
    charmap(13) = "\r"
    charmap(34) = "\"""
    charmap(47) = "\/"
    charmap(92) = "\\"

    Dim strlen : strlen = Len(str) - 1
    ReDim haystack(strlen)

    Dim i, charcode
    For i = 0 To strlen
        haystack(i) = Mid(str, i + 1, 1)

        charcode = AscW(haystack(i)) And 65535
        If charcode < 127 Then
            If Not IsEmpty(charmap(charcode)) Then
                haystack(i) = charmap(charcode)
            ElseIf charcode < 32 Then
                haystack(i) = "\u" & Right("000" & Hex(charcode), 4)
            End If
        Else
            haystack(i) = "\u" & Right("000" & Hex(charcode), 4)
        End If
    Next

    jsEncode = Join(haystack, "")
End Function

Function getTimestamp()
	getTimestamp	= DateDiff("s", "01/01/1970 00:00:00", Now())
End Function

Function getNoncestr()
	getNoncestr	= ASP_MD5(Rnd())
End Function
' * google api 二维码生成【QRcode可以存储最多4296个字母数字类型的任意文本，具体可以查看二维码数据格式】
' * @param string $chl 二维码包含的信息，可以是数字、字符、二进制信息、汉字。不能混合数据类型，数据必须经过UTF-8 URL-encoded.如果需要传递的信息超过2K个字节请使用POST方式
' * @param int $widhtHeight 生成二维码的尺寸设置
' * @param string $EC_level 可选纠错级别，QR码支持四个等级纠错，用来恢复丢失的、读错的、模糊的、数据。
' *                         L-默认：可以识别已损失的7%的数据
' *                         M-可以识别已损失15%的数据
' *                         Q-可以识别已损失25%的数据
' *                         H-可以识别已损失30%的数据
' * @param int $margin 生成的二维码离图片边框的距离

Function QRfromGoogle(chl)
	widhtHeight = 500
	EC_level = "L"
	margin = 0

	chl = Server.URLencode(chl)

	QRfromGoogle = "http://chart.apis.google.com/chart?chs="& widhtHeight & "x" & widhtHeight & "&cht=qr&chld=" & EC_level &"|" & margin &"&chl="&chl
	
End Function

%>
<script language="JScript" runat="Server">
function JStoObject(json) {
    eval("var o=" + json);
   	return o;
}
</script>