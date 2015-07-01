<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="../config.asp"-->
<!--#include file="../classes/PayRequestHandler.asp"-->
<%
'=================================
'jsapi�ӿ�
'=================================
'��ʼ��
Set payHandler	= new PayRequestHandler
payHandler.init APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY

out_trade_no = getStrNow & getStrRandNumber(9999,1000)
'����package��������
Set packageParams = Server.CreateObject("Scripting.Dictionary")
packageParams.Add	"bank_type",	"WX"	    		'֧������
packageParams.Add	"body",			"��Ʒ����"		    '��Ʒ����
packageParams.Add	"fee_type",		"1"					'���б���
packageParams.Add	"input_charset","GBK"			    '�ַ���
packageParams.Add	"notify_url",	NOTIFY_URL			'֪ͨ��ַ
packageParams.Add	"out_trade_no",	out_trade_no		'�̻�������
packageParams.Add	"partner",		PARTNER				'�����̻���
packageParams.Add	"total_fee",	"1"					'��Ʒ�ܽ��,�Է�Ϊ��λ
packageParams.Add	"spbill_create_ip",	Request.ServerVariables("REMOTE_ADDR")	'֧������IP

'��ȡpackage��
package		= payHandler.genPackage(packageParams)
'����֧������
Set outParams = Server.CreateObject("Scripting.Dictionary")
outParams.Add	"appId",		APP_ID
outParams.Add	"nonceStr",		getNoncestr
outParams.Add	"package",		package
outParams.Add	"timeStamp",	getTimestamp
Dim sign
sign			= payHandler.createSHA1Sign(outParams)
outParams.Add	"paySign",		sign
outParams.Add	"signType",		"SHA1"
set json = jsObject()

For Each k In outParams
	json(k) = outParams(k)
Next
payStr	= toJson(json)
%>
<html>
<script language="javascript">
function callpay()
{
	WeixinJSBridge.invoke('getBrandWCPayRequest',<%=payStr%>,function(res){
	WeixinJSBridge.log(res.err_msg);
	alert(res.err_code+res.err_desc+res.err_msg);
	});
}
</script>
<body>
<button type="button" onclick="callpay()">wx pay test</button>
</body>
</html>
