<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.wxap.util.TenpayUtil"%>
<%@ page import="com.wxap.util.MD5Util"%>
<%@ page import="com.wxap.RequestHandler"%>
<%@ page import="com.wxap.ResponseHandler"%>
<%@ page import="com.wxap.client.TenpayHttpClient"%>
<%@ include file="../config.jsp"%>
<% 
//=================================
//维权接口
//=================================
	//创建支付应答对象
	RequestHandler queryReq = new RequestHandler(null, null);
	queryReq.init();
	//初始化页面提交过来的参数
	ResponseHandler resHandler = new ResponseHandler(request, response);
	resHandler.setKey(APP_KEY);
	
	//判断签名
if(resHandler.isWXsign() == true) {
	//回复服务器处理成功
	System.out.print("ok");
	}
	else{
	//SHA1签名失败
	System.out.print("fail");
	}


%>