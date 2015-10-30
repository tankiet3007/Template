//
//  TestCalendarViewController.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/30/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "TestCalendarViewController.h"

@interface TestCalendarViewController ()

@end

@implementation TestCalendarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationBar];
    [self initCalendar];
    // Do any additional setup after loading the view.
}
-(void)initNavigationBar
{
    AppDelegate * app = [AppDelegate sharedDelegate];
    [app initNavigationbar:self withTitle:@"Test"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backbtn_click
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initCalendar
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.view = view;
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    
    //    calendar.minimumDate = [NSDate date];
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.allowsMultipleSelection = NO;
    [self.view addSubview:calendar];
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date
{
    BOOL shouldDedeselect = date.fs_day != 5;
    if (!shouldDedeselect) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be selected",date.fs_string] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date
{
    BOOL shouldDedeselect = date.fs_day != 7;
    if (!shouldDedeselect) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Forbidden date %@ to be deselected",date.fs_string] message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return NO;
    }
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[obj fs_stringWithFormat:@"yyyy/MM/dd"]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date
{
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[obj fs_stringWithFormat:@"yyyy/MM/dd"]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
}
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
//    return [NSDate date];
    return [NSDate fs_dateWithYear:1970 month:1 day:1];
}
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
//{
//    
//}
@end
