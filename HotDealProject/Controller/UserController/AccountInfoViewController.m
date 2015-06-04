//
//  AccountInfoViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"
#import "AppDelegate.h"
#import "AutoSizeTableViewCell.h"


#import "EmailPromotionViewController.h"
@interface AccountInfoViewController ()
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
@property (nonatomic, strong) AutoSizeTableViewCell *prototypeCell;
@end

@implementation AccountInfoViewController
{
    BBBadgeBarButtonItem *barButton;
    NSArray * arrProduct;
    NSArray * arrProvine;
    NSString * strAddressL;
    MBProgressHUD *HUD;
    __block NSDictionary * dictRespone;
    NSIndexPath * indexPathselected;
}
@synthesize tableInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    strAddressL = @"";
    [self initHUD];
    [self getAllProvineSelected];
    [self initNavigationbar];
    
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
}

-(void)initData
{
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSString * strParam = F(@"user_id=%@",user.user_id);
//    NSDictionary * dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"4488",@"user_id", nil];
    
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequest:strParam withURL:URL_GET_USERINFO completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        dictRespone = dict;
        NSDictionary * dictAddress = [dict objectForKey:@"address"];
        NSDictionary * dictWard = [dictAddress objectForKey:@"s_ward"];
        NSDictionary * dictDictrict = [dictAddress objectForKey:@"s_district"];
        NSDictionary * dictState = [dictAddress objectForKey:@"s_state"];
        NSString * floorOptional = F(@"Lầu: %@",[dictAddress objectForKey:@"s_address_note"]);
        if ([dict objectForKey:@"fullname"] == nil || ![[dict objectForKey:@"fullname"] isEqualToString:@""]) {
            strAddressL = @"";
        }
        else if ([dict objectForKey:@"phone"] == nil || ![[dict objectForKey:@"phone"] isEqualToString:@""]) {
            strAddressL = @"";
        }
        else
            if ([dictState objectForKey:@"name"] == nil || ![[dictState objectForKey:@"name"] isEqualToString:@""]) {
                strAddressL = @"";
            }
            else
                if ([dictState objectForKey:@"name"] == nil || ![[dictState objectForKey:@"name"] isEqualToString:@""]) {
                    strAddressL = @"";
                }
                else
                {
                    strAddressL = F(@"%@\n%@\n%d %@ %@ %@ %@", [dict objectForKey:@"fullname"],[dict objectForKey:@"phone"],[[dictAddress objectForKey:@"s_address"]intValue],[dictWard objectForKey:@"name"],[dictDictrict objectForKey:@"name"],[dictState objectForKey:@"name"], floorOptional);
                }
        UA_log(@"%@", dict);
        
        [self initUITableView];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initUITableView
{
    tableInfo = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 66 - 40) style:UITableViewStylePlain];
    [self.view addSubview:tableInfo];
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableInfo.backgroundColor = [UIColor whiteColor];
    tableInfo.dataSource = self;
    tableInfo.delegate = self;
    tableInfo.separatorColor = [UIColor clearColor];
    tableInfo.showsVerticalScrollIndicator = NO;
    tableInfo.sectionHeaderHeight = 0.0;
    tableInfo.scrollEnabled = NO;
}


-(void)updateTotal
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        int iCurrent = item.iCurrentQuantity;
        iBadge += iCurrent;
    }
    barButton.badgeValue = F(@"%d",iBadge);
}
-(void)shoppingCart
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    if ([arrProduct count] == 0) {
        return;
    }
    ShoppingCartController * shopping = [[ShoppingCartController alloc]init];
    shopping.delegate = self;
    [self.navigationController pushViewController:shopping animated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thông tin tài khoản"];
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    // Set a value for the badge
    
    barButton.badgeOriginX = 25;
    barButton.badgeOriginY = -5;
    
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        iBadge += item.iCurrentQuantity;
    }
    barButton.badgeValue = F(@"%d",iBadge);
    
    //    barButton.badgeValue = F(@"%ld",[arrProduct count]);
    self.navigationItem.rightBarButtonItem = barButton;
}
#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)configureCell:(AutoSizeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"Thông tin cá nhân";
        cell.desLabel.text = @"\n";
    }
    if (indexPath.section == 1) {
        cell.titleLabel.text = @"Email khuyến mãi";
        NSString * strProvines = @"";
        for (NSString * strItem in arrProvine) {
            strProvines = F(@"%@, %@",strItem,strProvines);
        }
        if ([strProvines isEqualToString:@""]) {
            cell.desLabel.text = @"\n";
        }
        else
        {
            strProvines = F(@"%@ \n\n",strProvines);
            cell.desLabel.text = strProvines;
        }
    }
    
    if (indexPath.section == 2) {
        cell.titleLabel.text = @"Địa chỉ nhận hàng";
        if ([strAddressL isEqualToString:@""] || strAddressL == nil) {
            cell.desLabel.text = @"";
        }
        else
            cell.desLabel.text = F(@"%@\n\n",strAddressL);
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 0)];
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
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, rect.size.height + 15)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AutoSizeTableViewCell *cell = (AutoSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AutoSizeTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PersonalInfoViewController * pInfo = [[PersonalInfoViewController alloc]init];
        pInfo.dictResponse = dictRespone;
        pInfo.delegate = self;
        [self.navigationController pushViewController:pInfo animated:YES];
    }
    if (indexPath.section == 1) {
        EmailPromotionViewController * pInfo = [[EmailPromotionViewController alloc]init];
        pInfo.delegate = self;
        [self.navigationController pushViewController:pInfo animated:YES];
    }
    if (indexPath.section == 2) {
        AddressViewController * addressVC = [[AddressViewController alloc]init];
        addressVC.delegate = self;
        addressVC.indexPathSelected = indexPathselected;
        addressVC.dictResponse = dictRespone;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
}
-(void)getAllProvineSelected
{
    arrProvine = [[TKDatabase sharedInstance]getAllProvineUserSelected];
}
-(void)updateProvine
{
    [self getAllProvineSelected];
}
-(void)updateAddress:(NSString *)strAddress wIndex:(NSIndexPath *)indexPath
{
    strAddressL = strAddress;
    indexPathselected = indexPath;
    [tableInfo reloadData];
}
-(void)reloadUserInfoData
{
    [self updateInfo];
}
-(void)updateInfo
{
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSString * strParam = F(@"user_id=%@",user.user_id);
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequest:strParam withURL:URL_GET_USERINFO completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        dictRespone = dict;
//        NSDictionary * dictAddress = [dict objectForKey:@"address"];
//        NSDictionary * dictWard = [dictAddress objectForKey:@"s_ward"];
//        NSDictionary * dictDictrict = [dictAddress objectForKey:@"s_district"];
//        NSDictionary * dictState = [dictAddress objectForKey:@"s_state"];
//        NSString * floorOptional = F(@"Lầu: %@",[dictAddress objectForKey:@"s_address_note"]);
//        strAddressL = F(@"%@\n%@\n%d %@ %@ %@ %@", [dict objectForKey:@"fullname"],[dict objectForKey:@"phone"],[[dictAddress objectForKey:@"s_address"]intValue],[dictWard objectForKey:@"name"],[dictDictrict objectForKey:@"name"],[dictState objectForKey:@"name"], floorOptional);
//        UA_log(@"%@", dict);
        
        [tableInfo reloadData];
    }];
}
@end
