<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.wxap.ResponseHandler"%>
<%@ page import="com.wxap.RequestHandler"%>
<%@page import="java.util.TreeMap"%>
<%@ page import="com.wxap.client.TenpayHttpClient"%>
<%@page import="java.util.SortedMap"%>
<%@page import="com.wxap.util.Sha1Util"%>
<%@ page import="com.wxap.util.TenpayUtil"%>
<%@ page import="com.wxap.util.MD5Util"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.OutputStream"%>
<%@page import="com.google.gson.Gson"%>
<%@ include file="../config.jsp"%>

<%

//=================================
//jsapi接口
//=================================
//初始化

	RequestHandler reqHandler = new RequestHandler(request, response);
	TenpayHttpClient httpClient = new TenpayHttpClient();
	
	TreeMap<String, String> outParams = new TreeMap<String, String>();
	 //初始化 
	reqHandler.init();
	reqHandler.init(APP_ID, APP_SECRET, PARTNER_KEY, APP_KEY);
	
	//当前时间 yyyyMMddHHmmss
	String currTime = TenpayUtil.getCurrTime();
	//8位日期
	String strTime = currTime.substring(8, currTime.length());
	//四位随机数
	String strRandom = TenpayUtil.buildRandom(4) + "";
	//10位序列号,可以自行调整。
	String strReq = strTime + strRandom;
	//订单号，此处用时间加随机数生成，商户根据自己情况调整，只要保持全局唯一就行
	String out_trade_no = strReq;
	
	//获取提交的商品价格
	String order_price = request.getParameter("order_price");
	//获取提交的商品名称
	String product_name = request.getParameter("product_name");
	
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
		signParams.put("appid", APP_ID);
		signParams.put("nonceStr", noncestr);
		signParams.put("package", packageValue);
		signParams.put("timestamp", timestamp);
		//生成支付签名，要采用URLENCODER的原始值进行SHA1算法！
		String sign = Sha1Util.createSHA1Sign(signParams);
		
		//增加非参与签名的额外参数
		signParams.put("paySign", sign);
		signParams.put("signType", "sha1");
		
		
	
%>
<html>
	<head>
		<script language="javascript">
		function callpay(){
		 WeixinJSBridge.invoke('getBrandWCPayRequest',{
  		 "appId" : "<%= APP_ID %>","timeStamp" : "<%= timestamp %>", "nonceStr" : "<%= noncestr %>", "package" : "<%= packageValue %>","signType" : "SHA1", "paySign" : "<%= sign %>" 
   			},function(res){
					WeixinJSBridge.log(res.err_msg);
					alert(res.err_code + res.err_desc + res.err_msg);
					}
			}
		</script>
	</head>
  <body>
    <button type="button" onclick="callpay()" >wx pay test</button>
  </body>
</html>
