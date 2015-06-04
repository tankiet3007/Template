//
//  ShippingMethod.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 6/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ShippingMethod.h"
#import "AppDelegate.h"
#import "TKDatabase.h"
#import "MethodCell.h"
@interface ShippingMethod ()
@property (nonatomic, strong) NSIndexPath * indexPathSelected;
@end

@implementation ShippingMethod
{
    MBProgressHUD *HUD;
    NSMutableArray * arrPaymentMethod;
    MethodObject * methodSelected;
    UIButton* btnDone;
}
@synthesize tablePayment;
@synthesize indexPathSelected;
@synthesize delegate;
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrPaymentMethod = [[NSMutableArray alloc]init];
    [self initHUD];
    [self initNavigationbar];
    [self initData];
    indexPathSelected = [NSIndexPath indexPathForRow:0 inSection:0] ;
    [self initUITableView];
    
    // Do any additional setup after loading the view.
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thanh toán"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return [arrPaymentMethod count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MethodCell *cell = (MethodCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MethodCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureCell:cell forRowAtIndexPath:indexPath];
        if (![indexPathSelected isEqual:indexPath]) {
            cell.imgStatus.image = [UIImage imageNamed:@"radio"];
        }
        else
        {
            cell.imgStatus.image = [UIImage imageNamed:@"radio_checked"];
        }
        return cell;
    }
    else//btnRegister
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton* button = nil ;
        
        button = btnDone = [self makeButtonDone];
        [cellRe addSubview:btnDone];
        
        // Textfield dimensions
        button.frame = CGRectMake(10, 20, ScreenWidth - 20, 35);
        //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        cellRe.contentView.backgroundColor = [UIColor clearColor];
        return cellRe;
        
    }
    
    
}

- (void)configureCell:(MethodCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MethodObject * mObj = [arrPaymentMethod objectAtIndex:indexPath.row];
    NSString * item = mObj.strMethodName;
    cell.lblTitle.text = item;
    
    UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(10, 38, ScreenWidth-20, 5)];
    imgLine.image = [UIImage imageNamed:@"gach"];
    
    [cell.contentView addSubview:imgLine];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 44)];
    //    [cell.contentView insertSubview:viewBG atIndex:0];
    //    viewBG.layer.borderWidth = 0.5;
    //    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData
{
    MethodObject * mObj = [[MethodObject alloc]init];
    mObj.strMethodID = @"11";
    mObj.strMethodName = @"Bằng tiền mặt khi nhận hàng";
    [arrPaymentMethod addObject:mObj];
    
    mObj = [[MethodObject alloc]init];
    mObj.strMethodID = @"11";
    mObj.strMethodName = @"Bằng thẻ ATM nội địa";
    [arrPaymentMethod addObject:mObj];
    
    mObj = [[MethodObject alloc]init];
    mObj.strMethodID = @"11";
    mObj.strMethodName = @"Bằng thẻ thanh toán quốc tế (Visa, master...)";
    [arrPaymentMethod addObject:mObj];
    
    methodSelected = [arrPaymentMethod objectAtIndex:0];
    
    //    User * user = [[TKDatabase sharedInstance]getUserInfo];
    //    NSString * strParam = F(@"user_id=%@",user.user_id);
    //    [HUD show:YES];
    //    [[TKAPI sharedInstance]getRequest:strParam withURL:URL_GET_PAYMENT_METHOD completion:^(NSDictionary * dict, NSError *error) {
    //        [HUD hide:YES];
    //        if (dict == nil) {
    //            return;
    //        }
    //    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.section == 0) {
    MethodCell *cell = (MethodCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgStatus.image = [UIImage imageNamed:@"radio_checked"];
    indexPathSelected = indexPath;
    methodSelected = [arrPaymentMethod objectAtIndex:indexPath.row];
    [tablePayment reloadData];
     }
    
}
-(UIButton*) makeButtonDone{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"ĐỒNG Ý" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)doneClick
{
    [self.delegate updateShippingMethod:methodSelected];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
