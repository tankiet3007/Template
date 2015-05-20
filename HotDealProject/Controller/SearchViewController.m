//
//  SearchViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/19/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "SearchViewController.h"
#import "DealCell.h"
#import "DealObject.h"
#import "SVPullToRefresh.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
{
    SWRevealViewController *revealController;
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UILabel * lblNumOfDeal;
    MBProgressHUD *HUD;
}
@synthesize tableViewSearch,searchBars;
@synthesize searchText;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initUITableView];
    [self initSearchBar];
    [self setupHeader];
    
    [self initNavigationbar];
    [self initHUD];
    [self initData];
    
    // Do any additional setup after loading the view.
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(UIView *)setupHeader
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 84)];
    
    UIView * viewForSearch = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    viewForSearch.backgroundColor = [UIColor clearColor];
    [viewForSearch addSubview:searchBars];
    [viewHeader addSubview:viewForSearch];
    
    UILabel * lblHave = [[UILabel alloc]initWithFrame:CGRectMake(13, 54, 25, 20)];
    lblHave.font = [UIFont systemFontOfSize:14];
    lblHave.text = @"Có";
    [viewHeader addSubview:lblHave];
    lblNumOfDeal = [[UILabel alloc]initWithFrame:CGRectMake(36, 54, 40, 20)];
    lblNumOfDeal.font = [UIFont boldSystemFontOfSize:14];
    lblNumOfDeal.text = @"1232";
    lblNumOfDeal.textAlignment = NSTextAlignmentCenter;
    [viewHeader addSubview:lblNumOfDeal];
    
    lblHave = [[UILabel alloc]initWithFrame:CGRectMake(85, 54, 120, 20)];
    lblHave.font = [UIFont systemFontOfSize:14];
    lblHave.text = @"khuyến mãi";
    [viewHeader addSubview:lblHave];
    
    return viewHeader;
    
}

-(void)initSearchBar
{
    searchBars = [[UISearchBar alloc] init];
//    searchBars.showsCancelButton = YES;
    //    searchBars.backgroundColor = [UIColor darkGrayColor];
    [searchBars setFrame:CGRectMake(0, 5, ScreenWidth, 34)];
    searchBars.placeholder = @"Tìm kiếm";
    [searchBars setBackgroundColor:[UIColor clearColor]];
    [searchBars setBarTintColor:[UIColor clearColor]];
    searchBars.delegate = self;
    
}

-(void)initData2:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    @437, @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    searchText,@"search_text",
                                    nil];
    
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_DEAL_LIST completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        for (NSDictionary * dictItem in arrProducts) {
            DealObject * item = [[DealObject alloc]init];
            item.strTitle = [dictItem objectForKey:@"title"];
            item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDeals addObject:item];
        }
        UA_log(@"%lu item", [arrDeals count]);
        [tableViewSearch reloadData];
    }];
    
}

-(void)initData
{
    arrDeals = [[NSMutableArray alloc]init];
    
    DealObject * item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.buy_number = 123;
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.buy_number = 456;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.buy_number = 789;
    item.strDescription = @"Đầm xòe Zara họa tiết chấm bi xuất khẩu - Thiết kế thời trang với phần phối màu xen kẽ họa tiết chấm bi đẹp mắt giúp thể hiện nét đẹp thanh lịch, sành điệu của bạn gái. Chỉ 199.000đ cho trị giá 398.000đ Chỉ 199.000đ cho trị giá 398.000đ";
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.strDescription = @"Bộ miếng dán iPhone mạ vàng và ốp lưng silicon có thiết kế vừa vặn với khung máy sẽ giúp mang đến cho dế yêu của bạn một vẻ đẹp hoàn hảo và đẳng cấp. Chỉ 85.000đ cho trị giá 160.000đ";
    item.buy_number = 111;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.buy_number = 222;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.buy_number = 333;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.buy_number = 121;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.buy_number = 212;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.buy_number = 999;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
}
-(void)initNavigationbar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(searchText, @"");
    [label sizeToFit];
    
    revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIImage *image = [UIImage imageNamed:@"menu_n.png"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUITableView
{
    tableViewSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewSearch];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewSearch.backgroundColor = [UIColor whiteColor];
    tableViewSearch.dataSource = self;
    tableViewSearch.delegate = self;
    tableViewSearch.separatorColor = [UIColor clearColor];
    tableViewSearch.showsVerticalScrollIndicator = NO;
    tableViewSearch.sectionHeaderHeight = 0.0;
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
    
    return 230;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isDragging) {
        UIView *myView = cell.contentView;
        CALayer *layer = myView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*0.5, 1.0f, 0.0f, 0.0f);
        
        layer.transform = rotationAndPerspectiveTransform;
        [UIView animateWithDuration:.5 animations:^{
            layer.transform = CATransform3DIdentity;
        }];
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealCell *cell = (DealCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    DealObject * item = [arrDeals objectAtIndex:indexPath.row];
    if (item.isNew == FALSE) {
        cell.lblNew.hidden = YES;
    }
    if (item.iType == 1) {
        cell.lblEVoucher.hidden = YES;
    }
    //        [cell.imgBrand sd_setImageWithURL:[NSURL URLWithString:item.strBrandImage] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    [cell.imgBrand sd_setImageWithURL:[NSURL URLWithString:@"http://www.fightersgeneration.com/characters2/link-wind11.jpg"] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
    cell.lblNumOfBook.text = F(@"%d",item.buy_number);
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    cell.lblTitle.text = item.strTitle;

    
    if (item.isNew == FALSE) {
        cell.lblNew.hidden = YES;
    }
    if (item.iType == 1) {
        cell.lblEVoucher.hidden = YES;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 84;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return viewHeader;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTextx
{
    if ([searchTextx length] == 0) {
        [self performSelector:@selector(hideKeyboardWithSearchBar:) withObject:searchBar afterDelay:0];
    }
}

- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
    DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
    detail.dealObj = dealObj;
    detail.arrDealRelateds = arrDeals;
    [self.navigationController pushViewController:detail animated:YES];

}
@end
