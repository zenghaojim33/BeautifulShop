<%
'��ȡʱ���ַ���, ��ʽYYYYMMDDhhmiss
Public Function getStrNow()
	strNow = Now()
	strNow = Year(strNow) & Right(("00" & Month(strNow)),2) & Right(("00" & Day(strNow)),2) & Right(("00" & Hour(strNow)),2) & Right(("00" &  Minute(strNow)),2) & Right(("00" & Second(strNow)),2)
	getStrNow = strNow
End Function

' ��ȡ���������ڣ���ʽYYYYMMDD
Public Function getServerDate()
	getServerDate = Left(getStrNow,8)
End Function

'��ȡʱ��,��ʽhhmiss ��:192030
Public Function getTime()
	getTime = Right(getStrNow,6)
End Function

'��ȡ�����,���� [min,max]��Χ����
Function getRandNumber(max, min)
	Randomize 
	getRandNumber = CInt((max-min+1)*Rnd()+min) 
End Function

'��ȡ������ֵ��ַ���,����[min,max]��Χ�������ַ���
Function getStrRandNumber(max, min)
	randNumber = getRandNumber(max, min)
	getStrRandNumber = CStr(randNumber)
End Function

'�������󷵻�����
Function httpSend(url, method, data)
	Dim httpClient
	set httpClient = CreateObject("Msxml2.ServerXMLHTTP.3.0")
	'����֤Url����
	httpClient.Open method, url ,False
	'�ύ����
	httpClient.Send data
	httpSend = httpClient.responseText
End Function
	
'д��־��������ԣ�����վ����Ҳ���Ըĳɴ������ݿ⣩
'sWord Ҫд����־����ı�����
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

'Xml ����
Function XmlEncode(byVal sText)
	sText = Replace(sText, "&" , "&amp;") 
	sText = Replace(sText, "<" , "&lt;") 
	sText = Replace(sText, ">" , "&gt;") 
	sText = Replace(sText, "'" , "&apos;") 
	sText = Replace(sText, """", "&quot;") 
	XmlEncode = sText
End Function
'Xml ����
Function XmlDecode(byVal sText)
	sText = Replace(sText, "&amp;", "&" )
	sText = Replace(sText, "&lt;", "<")
	sText = Replace(sText, "&gt;", ">")
	sText = Replace(sText, "&apos;", "'")
	sText = Replace(sText, "&quot;", """")
	XmlDecode = sText
End Function
'url���룬��ӿո�ת��%20
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
' * google api ��ά�����ɡ�QRcode���Դ洢���4296����ĸ�������͵������ı���������Բ鿴��ά�����ݸ�ʽ��
' * @param string $chl ��ά���������Ϣ�����������֡��ַ�����������Ϣ�����֡����ܻ���������ͣ����ݱ��뾭��UTF-8 URL-encoded.�����Ҫ���ݵ���Ϣ����2K���ֽ���ʹ��POST��ʽ
' * @param int $widhtHeight ���ɶ�ά��ĳߴ�����
' * @param string $EC_level ��ѡ������QR��֧���ĸ��ȼ����������ָ���ʧ�ġ�����ġ�ģ���ġ����ݡ�
' *                         L-Ĭ�ϣ�����ʶ������ʧ��7%������
' *                         M-����ʶ������ʧ15%������
' *                         Q-����ʶ������ʧ25%������
' *                         H-����ʶ������ʧ30%������
' * @param int $margin ���ɵĶ�ά����ͼƬ�߿�ľ���

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