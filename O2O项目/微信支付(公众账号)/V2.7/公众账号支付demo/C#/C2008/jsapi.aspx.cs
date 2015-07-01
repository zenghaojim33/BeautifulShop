using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using tenpayApp;
//=================================
//JSAPI支付
//=================================
public partial class _Default : System.Web.UI.Page
{
    public String appId = TenpayUtil.appid;
    public String timeStamp = "";
    public String nonceStr = "";
    public String packageValue = "";
    public String paySign = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string sp_billno = Request["order_no"];
        //当前时间 yyyyMMdd
        string date = DateTime.Now.ToString("yyyyMMdd");

        if (null == sp_billno)
        {
            //生成订单10位序列号，此处用时间和随机数生成，商户根据自己调整，保证唯一
            sp_billno = DateTime.Now.ToString("HHmmss") + TenpayUtil.BuildRandomStr(4);
        }
        else
        {
            sp_billno = Request["order_no"].ToString();
        }

        sp_billno = TenpayUtil.partner + sp_billno;



        //创建支付应答对象
        RequestHandler packageReqHandler = new RequestHandler(Context);
        //初始化
        packageReqHandler.init();


        //设置package订单参数
        packageReqHandler.setParameter("partner", TenpayUtil.partner);		  //商户号
        packageReqHandler.setParameter("fee_type", "1");                    //币种，1人民币
        packageReqHandler.setParameter("input_charset", "GBK");
        packageReqHandler.setParameter("out_trade_no", sp_billno);		//商家订单号
        packageReqHandler.setParameter("total_fee", "1");			        //商品金额,以分为单位(money * 100).ToString()
        packageReqHandler.setParameter("notify_url", TenpayUtil.tenpay_notify);		    //接收财付通通知的URL
        packageReqHandler.setParameter("body", "JSAPIdemo");	                    //商品描述
        packageReqHandler.setParameter("spbill_create_ip", Page.Request.UserHostAddress);   //用户的公网ip，不是商户服务器IP

        //获取package包
        packageValue = packageReqHandler.getRequestURL();

        //调起微信支付签名
        timeStamp = TenpayUtil.getTimestamp();
        nonceStr = TenpayUtil.getNoncestr();

        //设置支付参数
        RequestHandler paySignReqHandler = new RequestHandler(Context);
        paySignReqHandler.setParameter("appid", appId);
        paySignReqHandler.setParameter("appkey", TenpayUtil.appkey);
        paySignReqHandler.setParameter("noncestr", nonceStr);
        paySignReqHandler.setParameter("timestamp", timeStamp);
        paySignReqHandler.setParameter("package", packageValue);
        paySign = paySignReqHandler.createSHA1Sign();



        //获取debug信息,建议把请求和debug信息写入日志，方便定位问题
        //string pakcageDebuginfo = packageReqHandler.getDebugInfo();
        //Response.Write("<br/>pakcageDebuginfo:" + pakcageDebuginfo + "<br/>");
        //string paySignDebuginfo = paySignReqHandler.getDebugInfo();
        //Response.Write("<br/>paySignDebuginfo:" + paySignDebuginfo + "<br/>");
      

    }
} 