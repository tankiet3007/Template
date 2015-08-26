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
#import "SupplierCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
{
    SWRevealViewController *revealController;
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UILabel * lblNumOfDeal;
    MBProgressHUD *HUD;
    BOOL bForceStop;
    int iState;
    UITextField *textFieldSearch;
}
@synthesize tableViewSearch,searchBars;
@synthesize searchText;
@synthesize totalQuatity;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"indexSelected"];
    if (savedValue != nil) {
        iState = [savedValue intValue];
    }
    if (iState == 1) {
        iState = 437;
    }
    else
        iState = 440;
    bForceStop = FALSE;
    [self initSearchBar];
//    [self setupHeader];
    
    [self initNavigationbar];
    [self initHUD];
    arrDeals = [[NSMutableArray alloc]init];
    [self initData2:10 wOffset:1 wType:@"default"];
    
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
    lblNumOfDeal.text = F(@"%d",totalQuatity);
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
    textFieldSearch = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width - 40, 28.0)];
    textFieldSearch.backgroundColor = [UIColor whiteColor];
    textFieldSearch.delegate = self;
    textFieldSearch.layer.cornerRadius = 15;
     textFieldSearch.font = [UIFont systemFontOfSize:11];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, textFieldSearch.frame.size.height)];
    leftView.backgroundColor = textFieldSearch.backgroundColor;
    textFieldSearch.leftView = leftView;
    textFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    
    self.navigationItem.titleView = textFieldSearch;
}
-(void)initSearchBar1
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
                                    F(@"%d", iState), @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    searchText,@"q",
                                    nil];
    
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_SEARCH_DEAL completion:^(NSDictionary * dict, NSError *error) {
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
//        [tableViewSearch reloadData];
        [self initUITableView];
    }];
    
}

-(void)initNavigationbar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUITableView
{
    tableViewSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, -40, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewSearch];
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
    
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView.isDragging) {
//        UIView *myView = cell.contentView;
//        CALayer *layer = myView.layer;
//        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
//        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*0.5, 1.0f, 0.0f, 0.0f);
//        
//        layer.transform = rotationAndPerspectiveTransform;
//        [UIView animateWithDuration:.5 animations:^{
//            layer.transform = CATransform3DIdentity;
//        }];
//    }
//    
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SupplierCell";
    
    SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(indexPath.row != arrDeals.count-1){
        //            NSArray * arrView = cell.subviews;
        //            for (UIView * vItem in arrView) {
        //                if (vItem.tag == 101) {
        //                    [vItem removeFromSuperview];
        //                }
        //            }
    }
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(12, 98, ScreenWidth -20, 1)];
    line.tag = 101;
    line.backgroundColor = [UIColor darkGrayColor];
    [cell addSubview:line];
    
    
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    
    DealObject * item = [arrDeals objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.strTitle;
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    backgroundView.layer.borderColor = [[UIColor clearColor]CGColor];
    backgroundView.layer.borderWidth = 10.0f;
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor clearColor];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsPath = [documentsPath stringByAppendingPathComponent:@"PublicFolder"];
    //        cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    //        NSString *photourl = F(@"%@&size=250x250", item.strBrandImage);;
    //    if (isNetworkConnected == TRUE) {
    //        [[SDImageCache sharedImageCache] removeImageForKey:photourl fromDisk:YES];
    //    }
    //    [cell.imgLogo setImageWithURL:[NSURL URLWithString:photourl]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    //        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://dev.hotdeal.vn/index.php?dispatch=products.image_mapi&product_id=288045&size=250x250"] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    float calculatePercent = (1-(float)((float)item.lDiscountPrice/(float)item.lStandarPrice)) *100;
    cell.lblPercentage.text = F(@"%.0f%%", calculatePercent);
    
    cell.starRating.backgroundColor = [UIColor clearColor];
    //        cell.starRating.rating =  item.iRate ;
    cell.starRating.rating = 4;
    cell.starRating.userInteractionEnabled = NO;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
    cell.lblNumOfBook.text = F(@"%d",item.buy_number);
    //        cell.lblNumOfBook.text = F(@"%d",23595);
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    cell.lblTitle.text = item.strTitle;
    
    if (bForceStop == TRUE) {
        return cell;
    }
    if (indexPath.row == [arrDeals count] - 1)
    {
        [self loadMoreDeal];
    }
    
    return cell;
}

-(void)loadMoreDeal
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    F(@"%d", iState), @"city",
                                    [NSNumber numberWithInteger:[arrDeals count]], @"fetch_count",
                                    [NSNumber numberWithInt:30], @"offset",
                                    @"newest",@"fetch_type",
                                    searchText,@"q",
                                    nil];
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_DEAL_LIST completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        if ([arrProducts count] == 0) {
            bForceStop = YES;
            return;
        }
        
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


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 84;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return viewHeader;
//}
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
