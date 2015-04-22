//
//  ProductListViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/22/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ProductListViewController.h"
#import "DealCell.h"
#import "DealObject.h"
#import "SVPullToRefresh.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ShortDealInfoCell.h"
@interface ProductListViewController ()

@end

@implementation ProductListViewController
{
    SWRevealViewController *revealController;
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UILabel * lblNumOfDeal;
    UIButton * btnChoiceProducts;
}
@synthesize tableViewDeal;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLoginBtn];
    [self initUITableView];
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Chọn số lượng"];
    

    [self initData];
    
    // Do any additional setup after loading the view.
}


-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)setupHeader
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 300, 20)];
    NSDate * date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM"];
    NSString * strToday = [formatter stringFromDate:date];
    
    NSLog(@"%@ ,%@", strToday ,[date stringWeekday]);
    lblTitle.text = F(@"Deal mới nhất %@ ngày %@",[date stringWeekday],strToday);
    lblTitle.font = [UIFont boldSystemFontOfSize:16];
    lblTitle.textColor = [UIColor redColor];
    [viewHeader addSubview:lblTitle];
    
    return viewHeader;
    
}


-(void)initData
{
    arrDeals = [[NSMutableArray alloc]init];
    
    DealObject * item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.iCount = 123;
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.iCount = 456;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 789;
    item.strDescription = @"Đầm xòe Zara họa tiết chấm bi xuất khẩu - Thiết kế thời trang với phần phối màu xen kẽ họa tiết chấm bi đẹp mắt giúp thể hiện nét đẹp thanh lịch, sành điệu của bạn gái. Chỉ 199.000đ cho trị giá 398.000đ Chỉ 199.000đ cho trị giá 398.000đ";
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.strDescription = @"Bộ miếng dán iPhone mạ vàng và ốp lưng silicon có thiết kế vừa vặn với khung máy sẽ giúp mang đến cho dế yêu của bạn một vẻ đẹp hoàn hảo và đẳng cấp. Chỉ 85.000đ cho trị giá 160.000đ";
    item.iCount = 111;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.iCount = 222;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 333;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.iCount = 121;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.iCount = 212;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 999;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUITableView
{
    tableViewDeal = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, ScreenWidth, ScreenHeight - 40) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewDeal];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewDeal.backgroundColor = [UIColor whiteColor];
    tableViewDeal.dataSource = self;
    tableViewDeal.delegate = self;
    tableViewDeal.separatorColor = [UIColor clearColor];
    tableViewDeal.showsVerticalScrollIndicator = NO;
    tableViewDeal.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrDeals count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShortDealInfoCell *cell = (ShortDealInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShortDealInfoCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShortDealInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];

    cell.btnChoice.tag = indexPath.row;
    [cell.btnChoice addTarget:self action:@selector(showDropbox:) forControlEvents:UIControlEventTouchUpInside];
    DealObject * item = [arrDeals objectAtIndex:indexPath.row];
    cell.lblDescription.text = item.strTitle;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    return viewHeader;
    UIView * viewFooter = [[UIView alloc]initWithFrame:btnChoiceProducts.frame];
    [viewFooter addSubview:btnChoiceProducts];
    return viewFooter;
}
-(UIButton *)setupLoginBtn
{
    btnChoiceProducts = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 300, 40)];
    [btnChoiceProducts setBackgroundColor:[UIColor greenColor]];
    [btnChoiceProducts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChoiceProducts setTitle:@"CHỌN" forState:UIControlStateNormal];
    [btnChoiceProducts addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    return btnChoiceProducts;
}
-(void)loginClick
{
    UA_log(@"clicked");
}
-(void)showDropbox:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    UA_log(@"%ld",btnSelected.tag);
}
@end
