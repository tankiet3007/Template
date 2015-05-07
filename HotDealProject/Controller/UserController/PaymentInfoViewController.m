//
//  PaymentInfoViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/5/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PaymentInfoViewController.h"
#import "AppDelegate.h"
#import "PayItemTableViewCell.h"
#import "PayItem.h"
@interface PaymentInfoViewController ()

@end

@implementation PaymentInfoViewController
{
    NSMutableArray * arrListPayment;
}
@synthesize tablePayment;
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrListPayment = [[NSMutableArray alloc]init];
    [self initData];
    [self initNavigationbar];
    [self initUITableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    PayItem * item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
    [arrListPayment addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
    [arrListPayment addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
    [arrListPayment addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
    [arrListPayment addObject:item];
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thanh toán"];
}

-(void)initUITableView
{
    tablePayment = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 66 - 40) style:UITableViewStylePlain];
    [self.view addSubview:tablePayment];
    tablePayment.backgroundColor = [UIColor whiteColor];
    tablePayment.dataSource = self;
    tablePayment.delegate = self;
    tablePayment.separatorColor = [UIColor clearColor];
    tablePayment.showsVerticalScrollIndicator = NO;
    tablePayment.sectionHeaderHeight = 0.0;
    tablePayment.scrollEnabled = NO;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrListPayment count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (void)configureCell:(PayItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayItem * item = [arrListPayment objectAtIndex:indexPath.row];
    cell.lblBookID.text = F(@"Đơn hàng số %@",item.strID);
        cell.lblBookDate.text = F(@"Ngày đặt %@",item.strBookDate);
        cell.lblBookID.text = F(@"Trạng thái %@",item.strStatus);
    
    NSString * strTotalPrice = F(@"%ldđ", item.lTotalPrice);
    strTotalPrice = [strTotalPrice formatStringToDecimal];
//    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
//    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strTotalPrice) attributes:attributes];
//    cell.lblTotalOfBill.text = strTotalPrice;
//    cell.vContain.layer.borderWidth = 0.5;
//    CGRect rectContain = cell.vContain.frame;
//    [cell.vContain setFrame:CGRectMake(rectContain.origin.x, rectContain.origin.y, ScreenWidth - 20, rectContain.size.height)];
//    cell.vContain.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 85)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayItemTableViewCell *cell = (PayItemTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PayItemTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PayItemTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
    
}

@end
