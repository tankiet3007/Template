//
//  PaymentInfoViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/17/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PaymentInfoViewController.h"
#import "TKDatabase.h"
#import "AppDelegate.h"
#import "PaymentInfoCell.h"
#import "PaymentInfoObject.h"
#import "PaymentSuccessViewController.h"
#import "PaymentTemplate.h"
@interface PaymentInfoViewController ()

@end

@implementation PaymentInfoViewController
{
    PaymentTemplate * payTemplate;
}
@synthesize arrPaymentInfo;
@synthesize tablePaymentInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavigationbar:@"Thanh toán và Vận chuyển"];
    [self initDataTemp];
    [self initUITableView];
}

-(void)initUITableView
{
    payTemplate = [[PaymentTemplate alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth -20, ScreenHeight -160)];
    payTemplate.arrInfo = arrPaymentInfo;
    [payTemplate initUITableView];
    [self.view addSubview:payTemplate];
//    tablePaymentInfo = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, ScreenHeight -160) style:UITableViewStyleGrouped];
//    [self.view addSubview:tablePaymentInfo];
//    tablePaymentInfo.backgroundColor = [UIColor whiteColor];
//    tablePaymentInfo.dataSource = self;
//    tablePaymentInfo.delegate = self;
//    tablePaymentInfo.separatorColor = [UIColor clearColor];
//    tablePaymentInfo.showsVerticalScrollIndicator = NO;
//    tablePaymentInfo.sectionHeaderHeight = 0.0;
    
//    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
//    [btnDone setFrame:CGRectMake(0, ScreenHeight-160, ScreenWidth, 50)];
//    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#6AB917" alpha:1]];
//    [btnDone setTitle:@"THANH TOÁN" forState:UIControlStateNormal];
//    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//    [btnDone addTarget:self action:@selector(paymentDone) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btnDone];
}

-(void)paymentDone
{
//    PaymentSuccessViewController * pS = [[PaymentSuccessViewController alloc]init];
//    [self.navigationController pushViewController:pS animated:YES];
    [payTemplate reloadData];
}

-(void)initDataTemp
{
    arrPaymentInfo = [NSMutableArray new];
    PaymentInfoObject * pObject = [PaymentInfoObject new];
    pObject.strName = @"ĐƠN HÀNG";
    pObject.strDescription = @"Combo nước uống tại Urban Station";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"TỔNG GIÁ";
    pObject.strDescription = @"85.000đ";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"NGƯỜI NHẬN";
    pObject.strDescription = @"Nguyễn Văn A";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"EMAIL";
    pObject.strDescription = @"abc@gmail.com";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"ĐIỆN THOẠI";
    pObject.strDescription = @"0909090000";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"ĐỊA CHỈ";
    pObject.strDescription = @"Lữ gia Plaza, 70 Lữ Gia";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"THÀNH PHỐ";
    pObject.strDescription = @"Hồ Chí Minh";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"QUẬN";
    pObject.strDescription = @"11";
    [arrPaymentInfo addObject:pObject];
    
    pObject = [PaymentInfoObject new];
    pObject.strName = @"GHI CHÚ";
    pObject.strDescription = @"Giao hàng trong giờ hành chính, điện thoại trước khi giao hàng.";
    [arrPaymentInfo addObject:pObject];
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationbar:(NSString *)strTitle
{
//    AppDelegate * appdelegate = ApplicationDelegate;
//    [appdelegate initNavigationbar:self withTitle:strTitle];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = strTitle;
    [label sizeToFit];
}
//#pragma mark tableview delegate + datasource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return  1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 9;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 60)];
//    UILabel * lblHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(tableView), 34)];
//    lblHeaderTitle.text = @"THÔNG TIN GIAO HÀNG";
//    lblHeaderTitle.textColor = [UIColor darkGrayColor];
//    lblHeaderTitle.font = [UIFont boldSystemFontOfSize:18];
//    lblHeaderTitle.textAlignment = NSTextAlignmentCenter;
//    [vHeader addSubview:lblHeaderTitle];
//    
//    UIView * underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth - 20, 1)];
//    underLine.backgroundColor = [UIColor lightGrayColor];
//    [vHeader addSubview:underLine];
//    return vHeader;
//}
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *simpleTableIdentifier = @"PaymentInfoCell";
//    
//    PaymentInfoCell *cell = (PaymentInfoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentInfoCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    PaymentInfoObject * pObject = [arrPaymentInfo objectAtIndex:indexPath.row];
//    cell.lblName.text = pObject.strName;
//    cell.lblDescription.text = pObject.strDescription;
//    return cell;
//}
@end
