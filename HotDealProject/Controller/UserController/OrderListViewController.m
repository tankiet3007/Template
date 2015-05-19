//
//  PaymentInfoViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/5/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "OrderListViewController.h"
#import "AppDelegate.h"
#import "PayItemTableViewCell.h"
#import "PayItem.h"
#import "OrderInfoViewController.h"
#import "TKDatabase.h"
@interface OrderListViewController ()

@end

@implementation OrderListViewController
{
   __block NSMutableArray * arrOrderlist;
    MBProgressHUD *HUD;
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
    arrOrderlist = [[NSMutableArray alloc]init];
    [self initHUD];
    [self initData2];
    [self initNavigationbar];
    [self initUITableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)initData2
{
//    User * user = [[TKDatabase sharedInstance]getUserInfo];
//    NSString * strParam = F(@"user_id=%@",user.user_id);
//    NSString * strParam = @"user_id=8844";
    NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"8844",@"profile_id", nil];
//    NSDate *date = [NSDate date];
//    NSString * strDate = F(@"%.0f",floor([date timeIntervalSince1970] * 1000));
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:<#(NSTimeInterval)#>];
//    NSTimeInterval unixTimeStamp = floor([date timeIntervalSince1970]);
//    UA_log(@"%@", [NSDate getStringFromTimestamp:unixTimeStamp]);
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequestAFarr:params withURL:URL_GET_ODER_LIST completion:^(NSArray * arr, NSError *error) {
        [HUD hide:YES];
        arrOrderlist = [NSMutableArray arrayWithArray:arr];
        [tablePayment reloadData];
    }];

}
-(void)initData
{
    PayItem * item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
    item.strType = @"Credit card";
    [arrOrderlist addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
        item.strType = @"Credit card";
    [arrOrderlist addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
        item.strType = @"Credit card";
    [arrOrderlist addObject:item];
    
    item = [[PayItem alloc]init];
    item.strID = @"123456";
    item.strBookDate = @"05/05/2015 20:33:15";
    item.strStatus = @"Chưa hoàn tất";
        item.strType = @"Credit card";
    [arrOrderlist addObject:item];
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
    tablePayment = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66 ) style:UITableViewStylePlain];
    [self.view addSubview:tablePayment];
    tablePayment.backgroundColor = [UIColor whiteColor];
    tablePayment.dataSource = self;
    tablePayment.delegate = self;
    tablePayment.separatorColor = [UIColor clearColor];
    tablePayment.showsVerticalScrollIndicator = NO;
    tablePayment.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrOrderlist count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (void)configureCell:(PayItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * item = [arrOrderlist objectAtIndex:indexPath.row];
    cell.lblBookID.text = F(@"Đơn hàng số %@",[item objectForKey:@"order_id"]);
    double timeStamp = [[item objectForKey:@"timestamp"]doubleValue];
    NSString * strDate = [NSDate getStringFromTimestamp:timeStamp];
        cell.lblBookDate.text = F(@"Ngày đặt %@",strDate);
        cell.lblStatus.text = F(@"Trạng thái %@",[item objectForKey:@"status"]);
    
    NSString * strTotalPrice = F(@"%d", [[item objectForKey:@"total"]intValue]);
    strTotalPrice = [strTotalPrice formatStringToDecimal];
    strTotalPrice = F(@"%@đ", strTotalPrice);
    cell.lblTotalOfBill.text = strTotalPrice;
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 100)];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoViewController * pItemVC = [[OrderInfoViewController alloc]init];
    pItemVC.pItem = [arrOrderlist objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:pItemVC animated:YES];
}

@end
