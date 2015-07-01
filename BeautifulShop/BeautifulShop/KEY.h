//发送短信验证码接口
#define sendSmsCode @"http://server.mallteem.com/json/public.ashx?aim=appcheckcode"


// 登录
#define LoginO2O @"http://server.mallteem.com/json/index.ashx?aim=login&phone=%@&pwd=%@&ecode=ios_%@"

// 获取货品
#define Getproduct @"http://server.mallteem.com/json/index.ashx?aim=getproduct&userid=%@&seller=%@&use=%@&brand=%@&category=%@&key=%@&size=20&index=%d&orderBy=%@"

#define SearchProduct @"http://server.mallteem.com/json/index.ashx?aim=getproduct&userid=%@&seller=%@&use=%@&brand=%@&category=%@&key=%@&size=100&index=%d&orderBy=%@&class=%d"
//查询订单
#define Getorders @"http://server.mallteem.com/json/index.ashx?aim=getorders&seller=%@&buyer=%@&type=%d&key=%@&index=%d&size=20&starttime=%@&endtime=%@"

//每日订单
#define GetOrderCount @"http://server.mallteem.com/json/index.ashx?aim=getordercount&sellerid=%@&size=20&index=%d&day=%@"

//成交金额
#define GetOrderAllPric @"http://server.mallteem.com/json/index.ashx?aim=getorderallpric&sellerid=%@&size=20&index=%d&day=%@"

//每日访客
#define GetVisiterCount @"http://server.mallteem.com/json/index.ashx?aim=getvisitercount&sellerid=%@&size=20&index=%d"

//消息中心
#define MessageCentre @"http://server.mallteem.com/json/index.ashx?aim=massages&size=100&index=%d"

//获取状态
#define Checklogin @"http://server.mallteem.com/json/index.ashx?aim=checklogin&userid=%@&ecode=ios_%@"


//进入“店主升级”获取信息
#define GetUpInfor @"http://server.mallteem.com/json/index.ashx?aim=getupinfor&userid=%@"

//分享我的美店
#define myBeautifulShop @"http://web.mallteem.com/Shop.aspx?ShopId=%@"

//分享产品
#define myProduct @"http://web.mallteem.com/ProductDetail.aspx?id=%@&ShopId=%@"

#define GetVersion ([[UIDevice currentDevice].systemVersion floatValue] < 7.0)

// 屏幕宽度和高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// 自动适配宽度,width为原始iPhone4/5的宽度
#define AUTO_MATE_WIDTH(width) ((width) * SCREEN_WIDTH / 320.0)
#define AUTO_MATE_HEIGHT(height) ((height) * SCREEN_HEIGHT / 480.0)

// 判断是否iPhone4-5/iPhone6/plus
#define IS_IPHONE4_5 (SCREEN_WIDTH==320)
#define IS_IPHONE6 (SCREEN_WIDTH==375)
#define IS_IPHONE6_PLUS (SCREEN_WIDTH==414)