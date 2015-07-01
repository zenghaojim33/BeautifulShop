//
//  StartTimeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-31.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "StartTimeViewController.h"
#import "EndTimeViewController.h"
#import "CalendarView.h"
@interface StartTimeViewController ()
<
CalendarDelegate,EndTimeDelegate
>
@property (strong, nonatomic) CalendarView *_sampleView;
@end

@implementation StartTimeViewController

-(void)SetEndTimeStr:(NSString*)endTimeStr {
    NSLog(@"%@", endTimeStr);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选择开始日期";
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
    
    [self.delegate SetStartTimteStr:dateString];
    [self.navigationController popViewControllerAnimated:YES];
    
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
