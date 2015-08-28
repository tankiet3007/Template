//
//  PaymentAndTransferViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/17/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//
#define PADDING 10
#import "PaymentAndTransferViewController.h"
#import "AppDelegate.h"
#import "ScrollableCell.h"
#import "PaymentInfoViewController.h"

@interface PaymentAndTransferViewController ()

@end

@implementation PaymentAndTransferViewController
{
    NSMutableArray * arrCellObject;
    int iLastSelectedPayment;
    int iLastSelectedShipping;
}
@synthesize tablePaymentInfo;
@synthesize arrPaymentMethod, arrShippingMethod;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    iLastSelectedPayment = -1;
    iLastSelectedShipping = -1;
    [self initDataTemp];
    [self initUITableView];
    [self initNavigationbar:@"Thanh toán và Vận chuyển"];
}

-(void)initDataTemp
{
    arrCellObject = [NSMutableArray new];
    arrPaymentMethod = [NSMutableArray new];
    arrShippingMethod = [NSMutableArray new];
    MethodObject * mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Voucher";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrShippingMethod addObject:mObject];
    
    mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Giao hàng tận nơi";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrShippingMethod addObject:mObject];
    
    mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Voucher điện tử";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrPaymentMethod addObject:mObject];
    
    
    mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Tiền mặt";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrPaymentMethod addObject:mObject];
    
    mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Thẻ ATM ngân hàng nội địa";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrPaymentMethod addObject:mObject];
    
    mObject = [MethodObject new];
    mObject.strMethodID = @"001";
    mObject.strMethodName = @"Thẻ Visa/Master Card";
    mObject.strNormalImage = @"001";
    mObject.strSelectedImage = @"001";
    [arrShippingMethod addObject:mObject];
    
    [arrCellObject addObject:arrPaymentMethod];
    [arrCellObject addObject:arrShippingMethod];
}

-(void)initUITableView
{
    tablePaymentInfo = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, ScreenHeight -160) style:UITableViewStyleGrouped];
    [self.view addSubview:tablePaymentInfo];
    tablePaymentInfo.backgroundColor = [UIColor whiteColor];
    tablePaymentInfo.dataSource = self;
    tablePaymentInfo.delegate = self;
    tablePaymentInfo.separatorColor = [UIColor clearColor];
    tablePaymentInfo.showsVerticalScrollIndicator = NO;
    tablePaymentInfo.sectionHeaderHeight = 0.0;
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(0, ScreenHeight-160, ScreenWidth, 50)];
    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    [btnDone setTitle:@"ĐỒNG Ý" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnDone addTarget:self action:@selector(selectedDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnDone];
}
-(void)selectedDone
{
//    PaymentInfoViewController * pInfo = [[PaymentInfoViewController alloc]init];
//    [self.navigationController pushViewController:pInfo animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:strTitle];
}
#pragma mark tableview
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return  60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vHeader  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 60)];
    UILabel * lblSum = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 200, 25)];
    lblSum.font = [UIFont boldSystemFontOfSize:14];
    lblSum.textColor = [UIColor darkGrayColor];
    lblSum.textAlignment = NSTextAlignmentLeft;
    lblSum.text = @"TỔNG GIÁ TIỀN";
    [vHeader addSubview:lblSum];
    
    lblSum = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(tableView) - 200, 10, 200, 25)];
    lblSum.font = [UIFont boldSystemFontOfSize:14];
    lblSum.textColor = [UIColor blackColor];
    lblSum.textAlignment = NSTextAlignmentRight;
    lblSum.text = @"1.280.000đ";
    [vHeader addSubview:lblSum];
    
    UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH(tablePaymentInfo), 1)];
    vLine.backgroundColor = [UIColor lightGrayColor];
    [vHeader addSubview:vLine];
    return vHeader;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * vFooter  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 60)];
    UILabel * lblDes = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(tableView), 45)];
    lblDes.font = [UIFont boldSystemFontOfSize:12];
    lblDes.textColor = [UIColor darkGrayColor];
    lblDes.textAlignment = NSTextAlignmentLeft;
    lblDes.text = @"Đặt hàng là bạn đã đồng ý với quy chế sàn giao dịch thương mại điện tử và chính sách đổi trả của Hotdeal";
    lblDes.numberOfLines = 3;
    [vFooter addSubview:lblDes];
    
    return vFooter;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScrollableCell *cell = nil;
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScrollableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    int x = 0;
    NSMutableArray * arrObject = [arrCellObject objectAtIndex:indexPath.row];
    for (int i = 0; i < [arrObject count]; i++) {
        UIButton * itemS = [UIButton buttonWithType:UIButtonTypeCustom];
        if (indexPath.row == 0) {
            cell.lblTitleScroll.text = @"CHỌN HÌNH THỨC GIAO HÀNG";
            if (i == iLastSelectedShipping) {
                itemS.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
            }
            else
                itemS.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            cell.lblTitleScroll.text = @"CHỌN HÌNH THỨC THANH TOÁN";
            if (i == iLastSelectedPayment) {
                itemS.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
            }
            else
                itemS.backgroundColor = [UIColor lightGrayColor];
        }
        
        [itemS setFrame:CGRectMake(x, 0, 100, cell.scrollViewCell.frame.size.height - 30)];
        itemS.titleLabel.textAlignment = NSTextAlignmentCenter;
        itemS.tag = i + 20*indexPath.row;
        MethodObject * pObject = [arrObject objectAtIndex:i];
//        [itemS sd_setImageWithURL:[NSURL URLWithString:pObject.strImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
//        itemS.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [itemS addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(x, HEIGHT(itemS), 100, 28)];
        lblName.font = [UIFont boldSystemFontOfSize:10];
        lblName.text = pObject.strMethodName;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.numberOfLines = 2;
        [cell.scrollViewCell addSubview:itemS];
        x += itemS.frame.size.width+PADDING;
        [cell.scrollViewCell addSubview:lblName];
        
        UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(0, 125, WIDTH(tablePaymentInfo), 1)];
        vLine.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:vLine];
        
        
    }
    cell.scrollViewCell.contentSize = CGSizeMake(x, cell.scrollViewCell.frame.size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)btnSelected:(UIButton *)sender
{
    sender.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
    int iIndexSelected = sender.tag - 20;
    if (iIndexSelected < 0) {
        iIndexSelected = sender.tag;
        //Shipping method
        UA_log(@"%d", iIndexSelected);
        iLastSelectedShipping = iIndexSelected;
    }
    else
    {
        //Payment method
        UA_log(@"%d", iIndexSelected);
        iLastSelectedPayment = iIndexSelected;
    }
    [tablePaymentInfo reloadData];
}
@end
