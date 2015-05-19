//
//  PaymentDetailViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/7/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "AppDelegate.h"
#import "PayItemTableViewCell.h"
#import "AutoSizeTableViewCell.h"
#import "ProductTableViewCell.h"
#import "HotNewDetailViewController.h"
@interface OrderInfoViewController ()
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
@property (nonatomic, strong) AutoSizeTableViewCell *prototypeCell;
@end

@implementation OrderInfoViewController
{
    MBProgressHUD *HUD;
    NSArray * arrProduct;
}
@synthesize pItem;
@synthesize tablePaymentDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrProduct = [pItem objectForKey:@"products"];
    [self initHUD];
    [self initNavigationbar];
    [self initUITableView];

    // Do any additional setup after loading the view.
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
//    pItem = [[PayItem alloc]init];
//    pItem.strID = @"123456";
//    pItem.strBookDate = @"05/05/2015 20:33:15";
//    pItem.strStatus = @"Chưa hoàn tất";
//    pItem.strType = @"Credit card";
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Chi tiết đơn hàng"];
}

-(void)initUITableView
{
    tablePaymentDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, ScreenWidth, ScreenHeight - 40) style:UITableViewStyleGrouped];
    [self.view addSubview:tablePaymentDetail];
    tablePaymentDetail.backgroundColor = [UIColor whiteColor];
    tablePaymentDetail.dataSource = self;
    tablePaymentDetail.delegate = self;
    tablePaymentDetail.separatorColor = [UIColor clearColor];
    tablePaymentDetail.showsVerticalScrollIndicator = NO;
    tablePaymentDetail.sectionHeaderHeight = 0.0;
//    tablePaymentDetail.scrollEnabled = NO;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return [arrProduct count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 105;
    }
    if (indexPath.section == 1) {
        if (IS_IOS8_OR_ABOVE) {
            return UITableViewAutomaticDimension;
        }
        
        // (7)
        //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
        
        //    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
        
        // (8)
        [self.prototypeCell updateConstraintsIfNeeded];
        [self.prototypeCell layoutIfNeeded];
        
        // (9)
        return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    if (indexPath.section == 2) {
        return 80;
    }
    return 120;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)configureCell:(PayItemTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.lblBookID.text = F(@"Đơn hàng số %@",[pItem objectForKey:@"order_id"]);
    double timeStamp = [[pItem objectForKey:@"timestamp"]doubleValue];
    NSString * strDate = [NSDate getStringFromTimestamp:timeStamp];
    cell.lblBookDate.text = F(@"Ngày đặt %@",strDate);
    cell.lblStatus.text = F(@"Trạng thái %@",[pItem objectForKey:@"status"]);
    
    NSString * strTotalPrice = F(@"%d", [[pItem objectForKey:@"total"]intValue]);
    strTotalPrice = [strTotalPrice formatStringToDecimal];
    strTotalPrice = F(@"%@đ", strTotalPrice);
    cell.lblTotalOfBill.text = strTotalPrice;

    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 100)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
}

- (void)configureProductCell:(ProductTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dictProduct = [arrProduct objectAtIndex:indexPath.row];
    cell.lblProductTitle.text = [dictProduct objectForKey:@"shortname"];

    
    NSString * strPrice = F(@"%d", [[dictProduct objectForKey:@"price"]intValue]);
    strPrice = [strPrice formatStringToDecimal];
    strPrice = F(@"%@đ", strPrice);
    cell.lblPriceAndQuantity.text = F(@"Đơn giá: %@ - Số lượng: %d", strPrice, [[dictProduct objectForKey:@"amount"]intValue]);
    cell.lblTotal.text = strPrice;
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth -20, 75)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
    if (indexPath.section == 1) {
        AutoSizeTableViewCell *cell = (AutoSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AutoSizeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureCellAuto:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        ProductTableViewCell *cell = (ProductTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductTableViewCell"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureProductCell:cell forRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
}

- (void)configureCellAuto:(AutoSizeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.titleLabel.text = @"Giao hàng tại địa chỉ";
    cell.desLabel.text = F(@"%@\nĐTDĐ: %@\nToà nhà Yoco Building, 41 Nguyễn Thị Minh Khai, Phường Bến Nghé, Quận 1, TP.HCM \n\n", [pItem objectForKey:@"firstname"], [pItem objectForKey:@"phone"]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 60, 0)];
    lblTemp.lineBreakMode = NSLineBreakByWordWrapping;
    lblTemp.numberOfLines = 0;
    lblTemp.text = cell.desLabel.text;
    if ([cell.desLabel.text isEqualToString:@""]) {
        lblTemp.text = @"\n";
    }
    lblTemp.font = [UIFont systemFontOfSize:12];
    [lblTemp sizeToFit];
    CGRect rect = lblTemp.frame;
    //    fHeightOfDescription = rect.size.height;
    
    //    UA_log(@"height desLabel : %f", rect.size.height );
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth -20, rect.size.height + 15)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        HotNewDetailViewController * detailVC = [[HotNewDetailViewController alloc]init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel * lblProduct = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
    lblProduct.text = @"Sản phẩm";
    lblProduct.font = [UIFont boldSystemFontOfSize:13];
    [view addSubview:lblProduct];
    return view;
}
@end
