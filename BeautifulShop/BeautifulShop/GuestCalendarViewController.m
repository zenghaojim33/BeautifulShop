//
//  GuestCalendarViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestCalendarViewController.h"
#import "BWMMBProgressHUD.h"

@interface GuestCalendarViewController ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
{
    NSString * DateStr;
    NSString * Hours;
    NSString * Minutes;

}
@property (strong, nonatomic) IBOutlet UIView *pickerBGView;
@property (strong, nonatomic) IBOutlet UIView *buttonBGView;
@property (strong, nonatomic) NSArray * hoursData;
@property (strong, nonatomic) IBOutlet CalendarView *_sampleView;


@property (strong, nonatomic) NSArray * minutesData;
@end

@implementation GuestCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置时间";
    
    self.hoursData = @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23"];
    
    self.minutesData = @[@"00", @"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59"];
    
    
    // Do any additional setup after loading the view.
//    self._sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0, 0, self.sampleBGView.frame.size.width, self.sampleBGView.frame.size.height)];
    self._sampleView.delegate = self;
    [self._sampleView setBackgroundColor:[UIColor whiteColor]];
    self._sampleView.calendarDate = [NSDate date];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:self._sampleView.calendarDate];
    NSLog(@"selectedDate:%@", dateString);
    DateStr = dateString;


    
    NSLog(@"_sampleView:%.2f",self._sampleView.frame.size.height);

    
    
    //    [self.sampleBGView addSubview:_sampleView];
    
//    float higth = self.view.bounds.size.height-(_sampleView.frame.size.height)-42-64;

    UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    CGRect pickerRect;
    if ([[UIScreen mainScreen] currentMode].size.height == 480||[[UIScreen mainScreen] currentMode].size.height == 960)
        
    {
        
        NSLog(@"这是3.5寸的iPhone设备");
       pickerRect = CGRectMake(0, -40, self.pickerBGView.frame.size.width, self.pickerBGView.frame.size.height);

        
    }else if([[UIScreen mainScreen] currentMode].size.height == 1536&&[[UIScreen mainScreen] currentMode].size.width == 2048){
        
        NSLog(@"这是iPad设备");
        pickerRect = CGRectMake(0, -40, self.pickerBGView.frame.size.width, self.pickerBGView.frame.size.height);
 
        
    }else{

        NSLog(@"当前不是3.5寸的设备或者Ipad");
     
        pickerRect = CGRectMake(0, 0, self.pickerBGView.frame.size.width, self.pickerBGView.frame.size.height);
     
    }

    [pickerView setFrame:pickerRect];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    
    //获取当前时间
    NSDate* nowHours = [NSDate date];
    NSDateFormatter* fmtHours = [[NSDateFormatter alloc] init];
    fmtHours.dateStyle = kCFDateFormatterShortStyle;
    fmtHours.timeStyle = kCFDateFormatterShortStyle;
    [fmtHours setDateFormat:@"HH"];
    fmtHours.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* HoursString = [fmtHours stringFromDate:nowHours];
    NSLog(@"当前时:%@",HoursString);
    Hours = HoursString;
    NSDate* nowMinutes = [NSDate date];
    NSDateFormatter* fmtMinutes = [[NSDateFormatter alloc] init];
    fmtMinutes.dateStyle = kCFDateFormatterShortStyle;
    fmtMinutes.timeStyle = kCFDateFormatterShortStyle;
    [fmtMinutes setDateFormat:@"mm"];
    fmtMinutes.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    NSString* MinutesString = [fmtMinutes stringFromDate:nowMinutes];
    NSLog(@"当前分:%@",MinutesString);
    Minutes = MinutesString;
    
    int hours = [HoursString intValue];
    int minutes = [MinutesString intValue];
    [pickerView selectRow:hours inComponent:0 animated:YES];
    [pickerView selectRow:minutes inComponent:1 animated:YES];
    
    [self.pickerBGView addSubview:pickerView];
 
   
    
    
    
   
    
    UIButton * DoneBth = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.buttonBGView.frame.size.width/2-1, 40)];
    [DoneBth setBackgroundColor:[UIColor whiteColor]];
    [DoneBth setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [DoneBth addTarget:self action:@selector(TouchDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBGView addSubview:DoneBth];
    
    UIButton * CancelBth = [[UIButton alloc]initWithFrame:CGRectMake(self.buttonBGView.frame.size.width/2, 0, self.view.frame.size.width/2-1, 40)];
    [CancelBth setBackgroundColor:[UIColor whiteColor]];
    [CancelBth setTitle:@"取消" forState:UIControlStateNormal];
    [CancelBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [CancelBth addTarget:self action:@selector(TouchCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBGView addSubview:CancelBth];
    
}
//选项默认值
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    return;
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.hoursData.count;
    }else{
        return self.minutesData.count;
    }
    
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return self.hoursData[row];
    }else{
        return self.minutesData[row];
    }
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component==0) {
      
        Hours = [self.hoursData objectAtIndex:row];
        
    }else{
    
        Minutes =  [self.minutesData objectAtIndex:row];
        
    }

}
- (void)TouchDone:(UIButton*)button
{
    if (DateStr.length==0||Hours.length==0||Minutes.length==0)
    {
        NSLog(@"有空值");
    }else{
        
        NSString * HandM = [NSString stringWithFormat:@"%@ %@:%@:00",DateStr,Hours,Minutes];
    
  
//         [Tools showPromptToView:self.view atPoint:self.view.center withText:HandM duration:1.0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:HandM];
        
        
        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";

        NSString* dateString = [fmt stringFromDate:date];
        
        [self SetLocalNotificationForDate:dateString];
    }
}

- (void)SetLocalNotificationForDate:(NSString*)date
{

    NSDate* now = [NSDate date];
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateStyle = kCFDateFormatterShortStyle;
    
    fmt.timeStyle = kCFDateFormatterShortStyle;
    
    [fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    NSString* dateString = [fmt stringFromDate:now];
    
    NSLog(@"当前时间:%@",dateString);
    
    NSLog(@"选择时间:%@",date);
    
    NSDateFormatter *NowDateFormatter = [[NSDateFormatter alloc] init];
    
    [NowDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *nowDate = [NowDateFormatter dateFromString:dateString];
    
    NSTimeZone *NowZone = [NSTimeZone systemTimeZone];
    
    NSInteger NowInterval = [NowZone secondsFromGMTForDate: nowDate];
    
    nowDate = [nowDate  dateByAddingTimeInterval: NowInterval];
    
    NSLog(@"当前时间:%@", nowDate);
    
    /********************************************************************/
    
    NSDateFormatter *SelectDateFormatter = [[NSDateFormatter alloc] init];
    
    [SelectDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *selectData = [SelectDateFormatter dateFromString:date];
    
    NSTimeZone *SelectZone = [NSTimeZone systemTimeZone];
    
    NSInteger SelectInterval = [SelectZone secondsFromGMTForDate: selectData];
    
    selectData = [selectData  dateByAddingTimeInterval: SelectInterval];
    
    NSLog(@"选择时间:%@", selectData);

    //先对比选择的是否比当前时间晚
    
   NSDate * earlyDate = [nowDate earlierDate:selectData];
    if ([earlyDate isEqualToDate:selectData]) {
        NSLog(@"选择的Date比当前时间早");
        [BWMMBProgressHUD showTitle:@"提醒日期不可早于当前日期"
                             toView:self.view
                          hideAfter:2.0f
                            msgType:BWMMBProgressHUDMsgTypeWarning];
    }else{
        NSLog(@"选择的Date比当前时间晚");
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSCalendarUnitSecond;//年、月、日、时、分、秒、周等等都可以
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate toDate:selectData options:0];
       long int second = [comps second];//时间差
        NSLog(@"second:%ld",second);
        
        
        NSDate * date = [NSDate date];
        
        UILocalNotification *noti = [[UILocalNotification alloc]init];
        
        noti.fireDate = [date dateByAddingTimeInterval:second];
        
        noti.alertBody = @"客户提醒";
        
        noti.applicationIconBadgeNumber += 1;
        
        noti.userInfo = @{@"name": @"zhangsan"};
        
        noti.soundName = UILocalNotificationDefaultSoundName;
        
//       [noti setRepeatInterval:NSCalendarUnitMinute];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:noti];
        
        
        UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"设置提醒成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        av.tag = 999;
        
        [av show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999&&buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)TouchCancel:(UIButton*)button
{
    NSLog(@"Touch Cancel");

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tappedOnDate:(NSDate *)selectedDate
{

    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:selectedDate];
    NSLog(@"selectedDate:%@", dateString);
    
    DateStr = dateString;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
