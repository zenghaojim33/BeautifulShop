//
//  GoodsShelvesViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GoodsShelvesViewController.h"
#import "TypeModel.h"
#import "BrandModel.h"
#import "JENKButton.h"
#import "GoodsModel.h"
#import "GoodsTableViewController.h"
#import "KEY.h"
#import "BWMProductModel.h"
#import "UIStoryboard+BWMStoryboard.h"

@interface GoodsShelvesViewController () {
    NSString *_sellKey;
}
@property(nonatomic,strong)NSMutableArray * TypeArray;
@property(nonatomic,strong)NSMutableArray * BrandArray;

@property(nonatomic,strong)NSMutableArray * TypeBthArray;
@property(nonatomic,strong)NSMutableArray * BrandBthArray;
@property (strong, nonatomic) IBOutlet UITextField *ScarchTF;
@end

@implementation GoodsShelvesViewController

- (void)setSell:(BOOL)sell {
    _sell = sell;
    _sellKey = sell ? @"1" : @"0";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _sellKey = @"0";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"搜索产品";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.TypeArray = [NSMutableArray array];
    self.BrandArray = [NSMutableArray array];
    
    [self upTypeAndBrand];
    
}

#pragma mark 获取品牌与类别
- (void)upTypeAndBrand {
    NSString * link = @"http://server.mallteem.com/json/index.ashx?aim=getbrand";
    [self dataRequest:link SucceedSelector:@selector(UpGetTypeAndBrand:)];
}

- (void)UpGetTypeAndBrand:(NSMutableDictionary*)dict {
    
    NSLog(@"%@", dict);
    
    NSString * status = [dict objectForKey:@"status"];
    
    int statusInt = [status intValue];
    
    if (statusInt == false) {
        [self showAlertViewForTitle:@"获取数据失败" AndMessage:@"请检查您的网络"];
    } else {
     
        NSArray * types = [dict objectForKey:@"type"];
        for (int i = 0; i<types.count; i++) {
            NSMutableDictionary * typeDic = [types objectAtIndex:i];
            TypeModel * model = [[TypeModel alloc]init];
            
            model.TypeID = [typeDic objectForKey:@"id"];
            model.name = [typeDic objectForKey:@"name"];
            NSLog(@"types:%@",model.name);
            [self.TypeArray addObject:model];
        }
        
        NSArray * brands = [dict objectForKey:@"brand"];
        for (int i = 0; i<brands.count; i++) {
            NSMutableDictionary * brandDic = [brands objectAtIndex:i];
            BrandModel * model = [[BrandModel alloc]init];
            
            model.BrandID = [brandDic objectForKey:@"id"];
            model.name = [brandDic objectForKey:@"name"];
            NSLog(@"brands:%@",model.name);
            [self.BrandArray addObject:model];
        }
    
        [self initView];
    
    }
}

#pragma mark 创建View
- (void)initView {
    self.TypeBthArray = [NSMutableArray array];
    self.BrandBthArray = [NSMutableArray array];
    /************************************************************************/
    
    
    UIScrollView * myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50)];
    
    [self.view addSubview:myScrollView];
    
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 49+21+(((self.TypeArray.count/3)+1)*35))];
    view1.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview:view1];
    
    UILabel * TypeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view1.frame.size.width-20, 20)];
    TypeTitleLabel.text = @"类别";
    TypeTitleLabel.textAlignment = NSTextAlignmentCenter;
    TypeTitleLabel.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:TypeTitleLabel];
    
    UIView * TypeView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 21, view1.frame.size.width-20, view1.frame.size.height-21-49)];
    TypeView.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:TypeView];
    
    int TypeBthy = 0;
    int Typeyy = 0;
    int Typexx = -1;
    for (int i = 0; i<self.TypeArray.count; i++) {
        
        TypeBthy ++;
        Typexx ++;
        if (TypeBthy==4) {
            TypeBthy = 1;
            Typeyy += 35;
            Typexx = 0;
        }
        
        int width;

    
        if (Typexx==0||Typexx==3) {
            width =0;
        } else {
            width = (TypeView.frame.size.width/3)*Typexx;
        }
        
        
        JENKButton * button = [[JENKButton alloc]initWithFrame:CGRectMake(width, Typeyy, TypeView.frame.size.width/3, 30)];
        TypeModel * model = [self.TypeArray objectAtIndex:i];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(TouchTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        button.selected = NO;
         button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [TypeView addSubview:button];
        
        
        [self.TypeBthArray addObject:button];
    }
    
    
    UIView * TypeButtonView = [[UIView alloc]initWithFrame:CGRectMake(10, view1.frame.size.height-48, TypeView.frame.size.width, 30)];
    
    TypeButtonView.backgroundColor = [UIColor whiteColor];
    
    [view1 addSubview:TypeButtonView];
    
    
    UIButton * AllTypeButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TypeView.frame.size.width/2, 30)];
    [AllTypeButton1 setTitle:@"全选" forState:UIControlStateNormal];
    [AllTypeButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AllTypeButton1 addTarget:self action:@selector(AllTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    AllTypeButton1.tag = 0;
    AllTypeButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [TypeButtonView addSubview:AllTypeButton1];
    
    UIButton * AllTypeButton2 = [[UIButton alloc]initWithFrame:CGRectMake(TypeView.frame.size.width/2, 0, TypeView.frame.size.width/2, 30)];
    [AllTypeButton2 setTitle:@"全部取消" forState:UIControlStateNormal];
    [AllTypeButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AllTypeButton2 addTarget:self action:@selector(AllTypeButton:) forControlEvents:UIControlEventTouchUpInside];
    AllTypeButton2.tag = 1;
    AllTypeButton2.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [TypeButtonView addSubview:AllTypeButton2];

    /************************************************************************/
    
  
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(10, 15+view1.frame.size.height, self.view.frame.size.width-20, 50+21+(((self.BrandArray.count/3)+1)*35))];
    view2.backgroundColor = [UIColor clearColor];
    [myScrollView addSubview:view2];
    
    UILabel * BrandTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view2.frame.size.width-20, 20)];
    BrandTitleLabel.text = @"品牌";
    BrandTitleLabel.textAlignment = NSTextAlignmentCenter;
    BrandTitleLabel.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:BrandTitleLabel];
    
    UIView * BrandView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 21, view2.frame.size.width-20, view2.frame.size.height-21-50)];
    BrandView.backgroundColor = [UIColor whiteColor];
    [view2 addSubview:BrandView];
    
    int BrandBthy = 0;
    int Brandyy = 0;
    int Brandxx = -1;
    for (int i = 0; i<self.BrandArray.count; i++) {
        
        BrandBthy ++;
        Brandxx ++;
        if (BrandBthy==4) {
            BrandBthy = 1;
            Brandyy += 35;
            Brandxx = 0;
        }
        
        int width;
        
        
        if (Brandxx==0||Brandxx==3) {
            width =0;
        } else {
            width = (BrandView.frame.size.width/3)*Brandxx;
        }
        
        
        JENKButton * button = [[JENKButton alloc]initWithFrame:CGRectMake(width, Brandyy, BrandView.frame.size.width/3, 30)];
        BrandModel * model = [self.BrandArray objectAtIndex:i];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(TouchBrandButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        button.selected = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [BrandView addSubview:button];
        
        [self.BrandBthArray addObject:button];
        
        
    }
    
    UIView * BrandButtonView = [[UIView alloc]initWithFrame:CGRectMake(10, view2.frame.size.height-48, BrandView.frame.size.width, 30)];
    
    BrandButtonView.backgroundColor = [UIColor whiteColor];
    
    [view2 addSubview:BrandButtonView];
    
    
    UIButton * AllBrandButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, BrandView.frame.size.width/2, 30)];
    [AllBrandButton1 setTitle:@"全选" forState:UIControlStateNormal];
    [AllBrandButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AllBrandButton1 addTarget:self action:@selector(AllBrandButton:) forControlEvents:UIControlEventTouchUpInside];
    AllBrandButton1.tag = 0;
    AllBrandButton1.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [BrandButtonView addSubview:AllBrandButton1];
    
    UIButton * AllBrandButton2 = [[UIButton alloc]initWithFrame:CGRectMake(BrandView.frame.size.width/2, 0, BrandView.frame.size.width/2, 30)];
    [AllBrandButton2 setTitle:@"全部取消" forState:UIControlStateNormal];
    [AllBrandButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [AllBrandButton2 addTarget:self action:@selector(AllBrandButton:) forControlEvents:UIControlEventTouchUpInside];
    AllBrandButton2.tag = 1;
    AllBrandButton2.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [BrandButtonView addSubview:AllBrandButton2];

    
    /************************************************************************/
    
    
    if (view1.frame.size.height+view2.frame.size.height>myScrollView.frame.size.height) {
        myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, view1.frame.size.height+view2.frame.size.height+50);
    }
    
}

#pragma mark 选择类别
-(void)TouchTypeButton:(JENKButton*)button {
    NSLog(@"button:%d", (int)button.tag);
    if (button.selected == YES) {
        [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        button.selected = NO;
    } else {
         [button setImage:[UIImage imageNamed:@"选择_紫.png"] forState:UIControlStateNormal];
          button.selected = YES;
    }

}

#pragma mark 选择品牌
-(void)TouchBrandButton:(JENKButton*)button {
    NSLog(@"button:%d", (int)button.tag);
    if (button.selected == YES) {
        [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        button.selected = NO;
    } else {
        [button setImage:[UIImage imageNamed:@"选择_紫.png"] forState:UIControlStateNormal];
        button.selected = YES;
    }
}

#pragma mark 全选类别
- (void)AllTypeButton:(UIButton*)button {
    if (button.tag==0) {
        for (int i = 0; i<self.TypeBthArray.count; i++) {
            JENKButton * button = [self.TypeBthArray objectAtIndex:i];
            button.selected = YES;
                [button setImage:[UIImage imageNamed:@"选择_紫.png"] forState:UIControlStateNormal];
        }
    } else {
        for (int i = 0; i<self.TypeBthArray.count; i++) {
            JENKButton * button = [self.TypeBthArray objectAtIndex:i];
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark 全选品牌
- (void)AllBrandButton:(UIButton*)button {
    if (button.tag==0) {
        for (int i = 0; i<self.BrandBthArray.count; i++) {
            JENKButton * button = [self.BrandBthArray objectAtIndex:i];
            button.selected = YES;
            [button setImage:[UIImage imageNamed:@"选择_紫.png"] forState:UIControlStateNormal];
        }
    } else {
        for (int i = 0; i<self.BrandBthArray.count; i++) {
            JENKButton * button = [self.BrandBthArray objectAtIndex:i];
            button.selected = NO;
            [button setImage:[UIImage imageNamed:@"选择_无.png"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = nil;
            if(jsonObject==nil) {
                message = @"获取数据失败请检查你的网络";
                [self showAlertViewForTitle:message AndMessage:nil];
            } else {
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}

- (IBAction)TFDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)TouchView:(id)sender {
     [sender resignFirstResponder];
}

- (IBAction)TouchScarchButton:(UIButton *)sender {
     [self.ScarchTF resignFirstResponder];
    
    /******************************/
    NSString * scarchStr;
    
    if (self.ScarchTF.text.length==0) {
        scarchStr = @"";
    }else{
        scarchStr = self.ScarchTF.text;
    }
    
    NSLog(@"关键字:%@",scarchStr);
    /******************************/
    
    
    
    NSString * TypeStr = @"";
    NSMutableArray * allSelectedType = [NSMutableArray array];
    
    for (int i = 0; i<self.TypeBthArray.count; i++) {
        JENKButton * button = [self.TypeBthArray objectAtIndex:i];
        if (button.selected ==YES) {
            TypeModel * model = [self.TypeArray objectAtIndex:i];
            [allSelectedType addObject:model];
        }
    }
    
    for (int i = 0 ; i<allSelectedType.count; i++) {
        TypeModel * model = [allSelectedType objectAtIndex:i];
        
        if(i==0) {
            TypeStr = [NSString stringWithFormat:@"%@",model.TypeID];
        } else {
            TypeStr = [NSString stringWithFormat:@"%@,%@",TypeStr,model.TypeID];
        }
        
    }

    NSLog(@"TypeStr:%@",TypeStr);
    /******************************/
    
    NSString * BrandStr = @"";

    
    NSMutableArray * allSelectedBrand = [NSMutableArray array];
    
    for (int i = 0; i<self.BrandBthArray.count; i++) {
        JENKButton * button = [self.BrandBthArray objectAtIndex:i];
        if (button.selected ==YES) {
            BrandModel * model = [self.BrandArray objectAtIndex:i];
            [allSelectedBrand addObject:model];
        }
    }
    
    for (int i = 0 ; i<allSelectedBrand.count; i++) {
        BrandModel * model = [allSelectedBrand objectAtIndex:i];
        
        if(i==0) {
            BrandStr = [NSString stringWithFormat:@"%@",model.BrandID];
        } else {
            
            BrandStr = [NSString stringWithFormat:@"%@,%@",BrandStr,model.BrandID];
        }
    }

    NSLog(@"BrandStr:%@",BrandStr);
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    NSString * link = [NSString stringWithFormat:SearchProduct,@"",shareInfo.userModel.userID,_sellKey,BrandStr,TypeStr,scarchStr,1,@"", (int)_type];
    //穿三个搜索的参数回去
    ((GoodsTableViewController *)self.delegate).BrandStr = BrandStr;
    ((GoodsTableViewController *)self.delegate).TypeStr = TypeStr;
    ((GoodsTableViewController *)self.delegate).scarchStr = scarchStr;

    
    [self dataRequest:link SucceedSelector:@selector(GetproductData:)];
    
    /******************************/
}

- (void)GetproductData:(NSMutableDictionary*)dict {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"dict:%@",dict);
    NSString * status = [dict objectForKey:@"status"];

    int statusInt =[status intValue];
    NSMutableArray * array = [NSMutableArray array];
    if (statusInt == 0) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showAlertViewForTitle:@"获取数据失败" AndMessage:@"请检查您的网络"];
    } else {
        NSArray *productList = [dict objectForKey:@"productList"];
        // BWMMark
        if ([_delegate respondsToSelector:@selector(goodsShelvesViewController:searchDidSuccessful:keyword:)]) {
            [_delegate goodsShelvesViewController:self searchDidSuccessful:[BWMProductModel modelsWithDictArray:productList] keyword:self.ScarchTF.text];
        }
        for (int i = 0; i<productList.count; i++) {
            NSMutableDictionary * GoodDit =  [productList objectAtIndex:i];
            GoodsModel * model = [[GoodsModel alloc]init];
            model.GoodsID = [GoodDit objectForKey:@"id"];
            model.productName = [GoodDit objectForKey:@"productName"];
            model.mainImgUrl = [GoodDit objectForKey:@"mainImgUrl"];
            model.size = [GoodDit objectForKey:@"size"];
            model.saleNum = [GoodDit objectForKey:@"saleNum"];
            model.onSaleDate = [GoodDit objectForKey:@"onSaleDate"];
            model.productDescription = [GoodDit objectForKey:@"desc"];
            model.storeNumber = [[GoodDit objectForKey:@"_number"] integerValue];
            model.finalPrice = [GoodDit objectForKey:@"_finalPrice"];
            model.marketPrice = [GoodDit objectForKey:@"_marketPrice"];
            model.nSize = [GoodDit objectForKey:@"_size"];
            [array addObject:model];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([self.delegate respondsToSelector:@selector(SetArray:)]) {
            [self.delegate SetArray:array];
        }
        NSLog(@"%@", array);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

+ (instancetype)viewControllerWithSell:(BOOL)isSell delegate:(id<GoodsShelvesDelegate>)delegate {
    GoodsShelvesViewController *vc = [UIStoryboard initVCOnMainStoryboardWithID:@"GoodsShelvesViewController"];
    vc.sell = isSell;
    vc.delegate = delegate;
    return vc;
}

+ (instancetype)viewControllerWithDelegate:(id<GoodsShelvesDelegate>)delegate type:(BWMProductModelType)type {
    GoodsShelvesViewController *vc = [UIStoryboard initVCOnMainStoryboardWithID:@"GoodsShelvesViewController"];
    vc.delegate = delegate;
    vc.type = type;
    return vc;
}

@end
