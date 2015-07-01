//
//  EndTimeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-31.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "EndTimeViewController.h"
#import "CalendarView.h"

@interface EndTimeViewController ()
<
CalendarDelegate
>
@property (strong, nonatomic) CalendarView *_sampleView;
@end

@implementation EndTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选择结束日期";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self._sampleView = [[CalendarView alloc]init];
    self._sampleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
    self._sampleView.delegate = self;
    [self._sampleView setBackgroundColor:[UIColor whiteColor]];
    self._sampleView.calendarDate = [NSDate date];
    [self.view addSubview:self._sampleView];
    
    
    self.navigationItem.backBarButtonItem = backItem;
    self.view.backgroundColor =[UIColor whiteColor];
}
-(void)tappedOnDate:(NSDate *)selectedDate
{
    
    
    
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [fmt stringFromDate:selectedDate];


    
    BOOL isComparison = [self ComparisonDataForDate1:self.StartTimeStr AndDate2:dateString];
    
    if (isComparison ==NO)
    {
        [self ShowAlertViewForTitle:@"结束日期不可早与开始日期"];
    }else{
        
        [self.delegate SetEndTimeStr:dateString];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //对比
    
  
}
-  (BOOL)ComparisonDataForDate1:(NSString*)date1Str AndDate2:(NSString*)date2Str
{
    
    
    BOOL isCompar;
    NSDateFormatter *DateFormatter1 = [[NSDateFormatter alloc] init];
    
    [DateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *Date1 = [DateFormatter1 dateFromString:date1Str];
    
    NSTimeZone *NowZone = [NSTimeZone systemTimeZone];
    
    NSInteger NowInterval = [NowZone secondsFromGMTForDate: Date1];
    
    Date1 = [Date1  dateByAddingTimeInterval: NowInterval];
    
    NSLog(@"开始时间:%@", Date1);
    
    NSDateFormatter *DateFormatter2 = [[NSDateFormatter alloc] init];
    
    [DateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *Date2 = [DateFormatter2 dateFromString:date2Str];
    
    NSTimeZone *NowZone2 = [NSTimeZone systemTimeZone];
    
    NSInteger NowInterval2 = [NowZone2 secondsFromGMTForDate: Date2];
    
    Date2 = [Date2  dateByAddingTimeInterval: NowInterval2];
    
    NSLog(@"结束时间:%@", Date2);
    
    NSDate * earlyDate = [Date1 earlierDate:Date2];
    
    if ([earlyDate isEqualToDate:Date2]) {
        isCompar = NO;
    }else{
        isCompar = YES;
    }
    
    return isCompar;
    
}
-(void)ShowAlertViewForTitle:(NSString*)title
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
