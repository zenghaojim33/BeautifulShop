<%@LANGUAGE="VBSCRIPT" CODEPAGE="936"%>
<!--#include file="./config.asp"-->
<!--#include file="./classes/PayResponseHandler.asp"-->
<%
'---------------------------------------------------------
'΢��֧���ӿڴ���ص�ʾ�����̻����մ�ʾ�����п�������
'---------------------------------------------------------
'==================
'֪ͨ��֤�߼�
'==================
log_result("notify:qstring:"&chr(10)&request.querystring&chr(10))

'����֧��Ӧ�����
Dim resHandler
Set resHandler = new PayResponseHandler

'��ʼ��ҳ���ύ�����Ĳ���
resHandler.Init
resHandler.setKey PARTNER_KEY, APP_KEY

log_result("notify:"&chr(10)&resHandler.getDebugInfo&chr(10))
'�ж�ǩ��
If resHandler.isValidSign() = True Then
	If resHandler.isWXsign() = True Then
		Dim notify_id
		Dim transaction_id
		Dim total_fee
		Dim out_trade_no
		Dim discount
		Dim trade_state
		'�̻����յ���̨֪ͨ�����֪ͨID��Ƹ�ͨ������֤ȷ�ϣ����ú�̨ϵͳ���ý���ģʽ	
		notify_id = resHandler.getParameter("notify_id")	 '֪ͨid

		'�̻����׵���
		out_trade_no = resHandler.getParameter("out_trade_no")	

		'�Ƹ�ͨ���׵���
		transaction_id = resHandler.getParameter("transaction_id")

		'��Ʒ���,�Է�Ϊ��λ
		total_fee = resHandler.getParameter("total_fee")
		
		'�����ʹ���ۿ�ȯ��discount��ֵ��total_fee+discount=ԭ�����total_fee
		discount = resHandler.getParameter("discount")
		
		'֧�����
		trade_state = resHandler.getParameter("trade_state")
		
		'�ɻ�ȡ��������������
		'bank_type			��������,Ĭ�ϣ�BL
		'fee_type			�ֽ�֧������,Ŀǰֻ֧�������,Ĭ��ֵ��1-�����
		'input_charset		�ַ�����,ȡֵ��GBK��UTF-8��Ĭ�ϣ�GBK��
		'partner			�̻���,�ɲƸ�ͨͳһ�����10λ������(120XXXXXXX)��
		'product_fee		��Ʒ���ã���λ�֡������ֵ�����뱣֤transport_fee + product_fee=total_fee
		'sign_type			ǩ�����ͣ�ȡֵ��MD5��RSA��Ĭ�ϣ�MD5
		'time_end			֧�����ʱ��
		'transport_fee		�������ã���λ�֣�Ĭ��0�������ֵ�����뱣֤transport_fee +  product_fee = total_fee
		'�ж�ǩ�������
		If "0" = trade_state Then
			'----------------------
			'��ʱ���ʴ���ҵ��ʼ
			'-----------------------
			'�������ݿ��߼�
			'ע�⽻�׵���Ҫ�ظ�����
			'ע���жϷ��ؽ��
			'-----------------------
			'��ʱ���ʴ���ҵ�����
			'-----------------------
			'���Ƹ�ͨϵͳ���ͳɹ���Ϣ�����Ƹ�ͨϵͳ�յ��˽�����ڽ��к���֪ͨ
			log_result("success ��̨֪ͨ�ɹ�")
		Else  
			log_result("fail ֧��ʧ��")
		End If
		'�ظ�����������ɹ�
		Response.Write("success")
	Else'SHA1ǩ��ʧ��
		Response.Write("fail -SHA1 failed")
		log_result("debugInfo:" & resHandler.getDebugInfo & chr(10))
	End If
Else'MD5ǩ��ʧ��
	Response.Write("fail -Md5 failed")
	log_result("debugInfo:" & resHandler.getDebugInfo & chr(10))
End If
%>