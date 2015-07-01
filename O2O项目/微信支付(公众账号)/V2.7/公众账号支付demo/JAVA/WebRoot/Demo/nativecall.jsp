<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.wxap.util.TenpayUtil"%>
<%@ page import="com.wxap.util.MD5Util"%>
<%@ page import="com.wxap.RequestHandler"%>
<%@ page import="com.wxap.ResponseHandler"%>
<%@ page import="com.wxap.client.TenpayHttpClient"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.SortedMap"%>
<%@page import="com.wxap.util.Sha1Util"%>
<%@ include file="../config.jsp"%>

<%

response.resetBuffer();
response.setHeader("ContentType","text/xml");
out.println("<?xml version=\"1.0\" encoding=\"GBK\"?>");
out.println("<root>");
int retcode;
String xml_body="";
 //初始化
    RequestHandler reqHandler = new RequestHandler(null, null);
	reqHandler.init(APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY);
	
	//当前时间 
	String currTime = TenpayUtil.getCurrTime();
	//8位日期
	String strTime = currTime.substring(8, currTime.length());
	//四位随机数
	String strRandom = TenpayUtil.buildRandom(4) + "";
	//10位序列号,可以自行调整。
	String strReq = strTime + strRandom;
	//订单号
	String out_trade_no = strReq;
	
	//设置package订单参数
	SortedMap<String, String> packageParams = new TreeMap<String, String>();
			packageParams.put("bank_type", "WX");  //支付类型   
			packageParams.put("body", "商品名称"); //商品描述   
			packageParams.put("fee_type","1"); 	  //银行币种
			packageParams.put("input_charset", "GBK"); //字符集    
			packageParams.put("notify_url", NOTIFY_URL); //通知地址  
			packageParams.put("out_trade_no", out_trade_no); //商户订单号  
			packageParams.put("partner", PARTNER); //设置商户号
			packageParams.put("total_fee", "1"); //商品总金额,以分为单位
			packageParams.put("spbill_create_ip",  request.getRemoteAddr()); //订单生成的机器IP，指用户浏览器端IP
		
		//获取package包
		String packageValue = reqHandler.genPackage(packageParams);
		String noncestr = Sha1Util.getNonceStr();
		String timestamp = Sha1Util.getTimeStamp();
		
		//设置支付参数
		SortedMap<String, String> signParams = new TreeMap<String, String>();
		
			signParams.put("AppId", APP_ID);
			signParams.put("NonceStr", noncestr);
			signParams.put("Package", packageValue);
			signParams.put("TimeStamp", timestamp);
			signParams.put("RetCode", "0");
			signParams.put("RetErrMsg",	"OK");
			
			xml_body = reqHandler.parseXML();
		
		String sign = Sha1Util.createSHA1Sign(signParams);
       		signParams.put("app_signature",sign);
			signParams.put("sign_method","SHA1");
			
			response.setHeader("ContentType", "text/xml");
			out.clear();
			out.println(signParams);
			out.println(reqHandler.parseXML());
%>

