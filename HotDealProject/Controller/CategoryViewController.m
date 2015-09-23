//
//  CategoryViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
//#import "HotNewDetailViewController.h"
#import "DetailViewController.h"
#import "SWRevealViewController.h"
#import "DealCell.h"
#import "SupplierCell.h"
#import "CustomCollectionItem.h"
#import "MenuObject.h"
#import "CategorySpaViewController.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    UIButton * btnTitle;
    UIButton * lastBtnMenu;
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UISegmentedControl *segmentedControl;
    
    UILabel * lblNumOfVoucher;
    SWRevealViewController *revealController;
    UITableView * tableViewFilter;
    NSArray * arrSort;
    BOOL isShowSortMenu;
    int iState;
    MBProgressHUD *HUD;
    UIView * viewCT;
    BOOL bForceStop;
    UIButton * btnKind;
    UIButton * btnDistrict;
    UIButton * btnFilter;
    UIView * viewMenu;
    UIView* dimView;
    
    BOOL isShowSortMenu2;
    int iMenuRow1;
    int iMenuRow3;
    NSMutableArray * arrMenu1;
    NSMutableArray * arrMenu2;
    NSMutableArray * arrMenu2_2;
    NSMutableArray * arrMenu3;
    NSIndexPath * lastIndexPathMenu1;
    NSIndexPath * lastIndexPathMenu2;
    NSIndexPath * lastIndexPathMenu2_2;
    NSIndexPath * lastIndexPathMenu3;
    
    int iIndexMenu;
    UIView * vHeaderLocation;
    UIView * vSegment1;
    UIView * vSegment2;
    BOOL is_segment1;
}
#define RowHeight 44
#define CollectionItemHeight1 50
#define CollectionItemHeight2 33
@synthesize tableviewCategory;
@synthesize strTitle;
@synthesize strCateId;
@synthesize cateItem;
@synthesize collectionView;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initDataMenu];
    is_segment1 = TRUE;
    iIndexMenu = -1;
    lastIndexPathMenu1 = [NSIndexPath indexPathForRow:0 inSection:0];
    lastIndexPathMenu2 = [NSIndexPath indexPathForRow:0 inSection:0];
    lastIndexPathMenu2_2 = [NSIndexPath indexPathForRow:0 inSection:0];
    lastIndexPathMenu3 = [NSIndexPath indexPathForRow:0 inSection:0];
    bForceStop = FALSE;
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
    [self initNavigationbar];
    [self initMenu];
    [self initHUD];
    isShowSortMenu = NO;
    arrDeals = [[NSMutableArray alloc]init];
    [self initDataSort];
    [self initData2:10 wOffset:1 wType:@"default"];
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)initData2:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    strCateId, @"category",
                                    F(@"%d", iState), @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
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
        [self initTableViewForSort];
    }];
    
}

-(void)initDataSort
{
    arrSort = [NSArray arrayWithObjects:@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang", nil];
}
-(void)initTableViewForSort
{
    long estimateTableHeight = [arrSort count] * RowHeight;
    if (estimateTableHeight > ScreenHeight - 120) {
        estimateTableHeight = ScreenHeight - 120;
    }
    tableViewFilter = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 40, ScreenWidth/2, estimateTableHeight)];
    
    [self.view addSubview:tableViewFilter];
    //    [tableViewFilter setBounces:NO];
    tableViewFilter.layer.borderWidth = 1;
    tableViewFilter.layer.borderColor=[UIColor blackColor].CGColor;
    tableViewFilter.layer.shadowColor = [UIColor purpleColor].CGColor;
    tableViewFilter.layer.shadowOffset = CGSizeMake(0, 1);
    tableViewFilter.layer.shadowOpacity = 1;
    tableViewFilter.layer.shadowRadius = 1.0;
    tableViewFilter.clipsToBounds = YES;
    tableViewFilter.backgroundColor = [UIColor whiteColor];
    tableViewFilter.dataSource = self;
    tableViewFilter.delegate = self;
    [tableViewFilter setAllowsSelection:YES];
    //    tableViewFilter.separatorColor = [UIColor clearColor];
    tableViewFilter.showsVerticalScrollIndicator = NO;
    tableViewFilter.sectionHeaderHeight = 0.0;
    tableViewFilter.hidden = YES;
}
-(void)showCategory
{
    if(isShowSortMenu == NO)
    {
        isShowSortMenu = YES;
        [self setDimView:NO];
        [self initMainCategory];
    }
    else
    {
        isShowSortMenu = NO;
        [self dissmissProductview];
    }
}
- (void)hiddenView:(id)sender {
    
    [UIView animateWithDuration:.2 animations:^{
        
    } completion:^(BOOL finished) {
        [self dissmissProductview];
        [self dissmissMenu];
        dimView.alpha = 0;
        isShowSortMenu = NO;
        isShowSortMenu2 = NO;
    }];
}

-(void)dissmissProductview
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewCT.frame = CGRectMake(0, -220, ScreenWidth, -220);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [viewCT removeFromSuperview];
                         dimView.alpha = 0;
                     }];
}

-(void)initMainCategory
{
    
    viewCT = [[UIView alloc]initWithFrame:CGRectMake(0, -220, ScreenWidth, 220)];
    [viewCT setBackgroundColor:[UIColor whiteColor]];
    int x = 40;
    int y = 20;
    int size = 52;
    int midPadding = (ScreenWidth - size *3 - x*2)/2;
    viewCT.frame = CGRectMake(0, -220, ScreenWidth, 220);
    
    UIButton * btnCategory = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory setFrame:CGRectMake(x, y, size, size)];
    btnCategory.tag = 110;
    [btnCategory setBackgroundImage:[UIImage imageNamed:@"food"] forState:UIControlStateNormal];
    [btnCategory addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory.layer.borderWidth=1.0f;
    btnCategory.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory];
    
    UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(x, y+size, size, 30)];
    lblName.font = [UIFont boldSystemFontOfSize:10];
    lblName.text = @"ĂN UỐNG";
    lblName.textAlignment = NSTextAlignmentCenter;
    lblName.userInteractionEnabled = NO;
    lblName.backgroundColor = [UIColor clearColor];
    lblName.numberOfLines = 2;
    [viewCT addSubview:lblName];
    
    UIButton * btnCategory2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory2 setFrame:CGRectMake(x+size+midPadding, y, size, size)];
    btnCategory2.tag = 111;
    [btnCategory2 setBackgroundImage:[UIImage imageNamed:@"spa"] forState:UIControlStateNormal];
    [btnCategory2 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory2.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory2.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory2.layer.borderWidth=1.0f;
    btnCategory2.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory2];
    
    UILabel * lblName2 = [[UILabel alloc]initWithFrame:CGRectMake(x+size+midPadding,y+ size, size, 30)];
    lblName2.font = [UIFont boldSystemFontOfSize:10	];
    lblName2.text = @"SPA\nLÀM ĐẸP";
    lblName2.textAlignment = NSTextAlignmentCenter;
    lblName2.userInteractionEnabled = NO;
    lblName2.backgroundColor = [UIColor clearColor];
    lblName2.numberOfLines = 2;
    [viewCT addSubview:lblName2];
    UIButton * btnCategory3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory3 setFrame:CGRectMake(x+size*2+midPadding*2, y, size, size)];
    btnCategory3.tag = 112;
    [btnCategory3 setBackgroundImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    [btnCategory3 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory3.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory3.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory3.layer.borderWidth=1.0f;
    btnCategory3.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory3];
    
    UILabel * lblName3 = [[UILabel alloc]initWithFrame:CGRectMake(x+size*2+midPadding*2, y+size, size, 30)];
    lblName3.font = [UIFont boldSystemFontOfSize:10	];
    lblName3.text = @"ĐÀO TẠO GIẢI TRÍ";
    lblName3.textAlignment = NSTextAlignmentCenter;
    lblName3.userInteractionEnabled = NO;
    lblName3.backgroundColor = [UIColor clearColor];
    lblName3.numberOfLines = 2;
    [viewCT addSubview:lblName3];
    
    UIButton * btnCategory4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory4 setFrame:CGRectMake(x, y + size + 40, size, size)];
    btnCategory4.tag = 113;
    [btnCategory4 setBackgroundImage:[UIImage imageNamed:@"sanpham"] forState:UIControlStateNormal];
    [btnCategory4 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory4.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory4.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory4.layer.borderWidth=1.0f;
    btnCategory4.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory4];
    
    UILabel * lblName4 = [[UILabel alloc]initWithFrame:CGRectMake(x, y + size*2 + 40, size, 30)];
    lblName4.font = [UIFont boldSystemFontOfSize:10	];
    lblName4.text = @"SẢN PHẨM";
    lblName4.textAlignment = NSTextAlignmentCenter;
    lblName4.userInteractionEnabled = NO;
    lblName4.backgroundColor = [UIColor clearColor];
    lblName4.numberOfLines = 2;
    [viewCT addSubview:lblName4];
    
    UIButton * btnCategory5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory5 setFrame:CGRectMake(x+size+midPadding, y + size + 40, size, size)];
    btnCategory5.tag = 114;
    [btnCategory5 setBackgroundImage:[UIImage imageNamed:@"fashion"] forState:UIControlStateNormal];
    [btnCategory5 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory5.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory5.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory5.layer.borderWidth=1.0f;
    btnCategory5.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory5];
    
    UILabel * lblName5 = [[UILabel alloc]initWithFrame:CGRectMake(x+size+midPadding, y + size*2 + 40, size, 30)];
    lblName5.font = [UIFont boldSystemFontOfSize:10	];
    lblName5.text = @"THỜI TRANG";
    lblName5.textAlignment = NSTextAlignmentCenter;
    lblName5.userInteractionEnabled = NO;
    lblName5.backgroundColor = [UIColor clearColor];
    lblName5.numberOfLines = 2;
    [viewCT addSubview:lblName5];
    UIButton * btnCategory6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCategory6 setFrame:CGRectMake(x+size*2+midPadding*2, y + size + 40, size, size)];
    btnCategory6.tag = 115;
    [btnCategory6 setBackgroundImage:[UIImage imageNamed:@"tralvel"] forState:UIControlStateNormal];
    [btnCategory6 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnCategory6.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
    btnCategory6.layer.cornerRadius = btnCategory.bounds.size.width/2;;
    btnCategory6.layer.borderWidth=1.0f;
    btnCategory6.layer.masksToBounds = YES;
    [viewCT addSubview:btnCategory6];
    
    UILabel * lblName6 = [[UILabel alloc]initWithFrame:CGRectMake(x+size*2+midPadding*2, y + size*2 + 40, size, 30)];
    lblName6.font = [UIFont boldSystemFontOfSize:10	];
    lblName6.text = @"DU LỊCH";
    lblName6.textAlignment = NSTextAlignmentCenter;
    lblName6.userInteractionEnabled = NO;
    lblName6.backgroundColor = [UIColor clearColor];
    lblName6.numberOfLines = 2;
    [viewCT addSubview:lblName6];
    
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewCT.frame = CGRectMake(0, 0, ScreenWidth, 220);
                     }
                     completion:^(BOOL finished){
                     }];
    //    [self.view addSubview:self.postStatusView];
    [self.view addSubview:viewCT];
}

-(void)initNavigationbar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    btnTitle = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTitle.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTitle setTitle:cateItem.strTitle forState:UIControlStateNormal];
    [btnTitle addTarget:self action:@selector(showCategory) forControlEvents:UIControlEventTouchUpInside];
    [btnTitle sizeToFit];
    self.navigationItem.titleView = btnTitle;
    
    
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;
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
    tableviewCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableviewCategory];
    
    tableviewCategory.backgroundColor = [UIColor whiteColor];
    tableviewCategory.dataSource = self;
    tableviewCategory.delegate = self;
    [tableviewCategory setAllowsSelection:YES];
    tableviewCategory.separatorColor = [UIColor clearColor];
    tableviewCategory.showsVerticalScrollIndicator = NO;
    tableviewCategory.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:tableViewFilter]) {
        return [arrSort count];
    }
    else
        return [arrDeals count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return viewMenu;
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
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strStardarPrice length], 1)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.lblStandarPrice.attributedText = attributedString2;
    [cell.lblStandarPrice sizeToFit];
    cell.lblNumOfBook.text = F(@"%d",item.buy_number);
    //        cell.lblNumOfBook.text = F(@"%d",23595);
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    //        strDiscountPrice = F(@"%@đ", strDiscountPrice);
    attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strDiscountPrice) attributes:nil];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strDiscountPrice length], 1)];
    
    cell.lblDiscountPrice.attributedText = attributedString2;
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
                                    @437, @"city",
                                    [NSNumber numberWithInteger:10], @"fetch_count",
                                    [NSNumber numberWithLong:[arrDeals count]], @"offset",
                                    @"default",@"fetch_type",
                                    nil];
    HUD.labelText = @"Tải thêm deal";
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
        
        [tableviewCategory reloadData];
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailViewController * detail = [[DetailViewController alloc]init];
    DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
    detail.iProductID = dealObj.product_id;
    [self.navigationController pushViewController:detail animated:YES];
    //    if ([tableView isEqual:tableViewFilter]) {
    //        tableViewFilter.hidden = YES;
    //        isShowSortMenu = YES;
    //        tableviewCategory.userInteractionEnabled = YES;
    //    }
}
-(void)showFilterMenu
{
    //    if (isShowSortMenu == NO) {
    //        tableviewCategory.userInteractionEnabled = NO;
    //    }
    //    else
    //    {
    //        tableviewCategory.userInteractionEnabled = YES;
    //    }
    isShowSortMenu = !isShowSortMenu;
    tableViewFilter.hidden = isShowSortMenu;
}
-(void)setDimView:(BOOL)isMenu
{
    if (dimView != nil) {
        [dimView removeFromSuperview];
        dimView = nil;
    }
    if (isMenu == NO) {
        dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    else
    {
        dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight)];
        
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
    tapGesture.numberOfTapsRequired = 1;
    [dimView addGestureRecognizer:tapGesture];
    
    dimView.backgroundColor = [UIColor blackColor];
    dimView.alpha = 0;
    [self.view addSubview:dimView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         dimView.alpha = 0.6;
                     }];
}
-(void)clickOnCategory:(UIButton *)sender
{
    isShowSortMenu = NO;
    [self dissmissProductview];
    switch (sender.tag) {
        case 110:
        {
            [btnTitle setTitle:@"ĂN UỐNG" forState:UIControlStateNormal];
            break;
        }
        case 111:
        {
            [btnTitle setTitle:@"SPA LÀM ĐẸP" forState:UIControlStateNormal];
            CategoryObject * cateObj = [CategoryObject new];
            cateObj.strTitle = @"SPA LÀM ĐẸP";
            CategorySpaViewController * category = [[CategorySpaViewController alloc]init];
            category.cateItem = cateObj;
            [self.navigationController pushViewController:category animated:YES];
            break;
        }
        case 112:
        {
            [btnTitle setTitle:@"ĐÀO TẠO GIẢI TRÍ" forState:UIControlStateNormal];
            break;
        }
        case 113:
        {
            [btnTitle setTitle:@"SẢN PHẨM" forState:UIControlStateNormal];
            break;
        }
        case 114:
        {
            [btnTitle setTitle:@"THỜI TRANG" forState:UIControlStateNormal];
            break;
        }
        case 115:
        {
            [btnTitle setTitle:@"DU LỊCH" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    [btnTitle sizeToFit];
}
#pragma mark Menu -----
-(void)kindSelect:(UIButton *)sender
{
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDistrict setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    is_segment1 = TRUE;
    iIndexMenu = 1;
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self showMenu];
        lastBtnMenu = sender;
        
    }
    else
    {
        [self callbackMenu];
        lastBtnMenu = sender;
    }

}

-(void)callbackMenu
{
    isShowSortMenu2 = YES;
    [self setDimView:YES];
    if (iIndexMenu == 1) {
        [self initCollectionWithNumOfItem:[arrMenu1 count]];
    }
    if (iIndexMenu == 2) {
        [self initCollectionWithNumOfItem:[arrMenu2 count]];
    }
    if (iIndexMenu == 3) {
        [self initCollectionWithNumOfItem:[arrMenu3 count]];
    }
}
-(void)districtSelect:(UIButton *)sender
{
    iIndexMenu = 2;
    //        is_segment1 = TRUE;
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self showMenu];
        lastBtnMenu = sender;
        
    }
    else
    {
        [self callbackMenu];
        lastBtnMenu = sender;
    }
}
-(void)filterSelect:(UIButton *)sender
{
    iIndexMenu = 3;
    //        is_segment1 = TRUE;
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDistrict setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setDimView:YES];
    if ([lastBtnMenu isEqual:sender] || lastBtnMenu == nil) {
        [self showMenu];
        lastBtnMenu = sender;
        
    }
    else
    {
        [self callbackMenu];
        lastBtnMenu = sender;
    }
}
-(void)initMenu
{
    viewMenu = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [viewMenu setBackgroundColor:[UIColor whiteColor]];
    btnKind = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnKind setTitle:@"DANH MỤC" forState:UIControlStateNormal];
    [btnKind addTarget:self action:@selector(kindSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnKind.frame = CGRectMake(10, 5, ScreenWidth/3 - 20, 30);
    [btnKind.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnKind setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [viewMenu addSubview:btnKind];
    
    btnDistrict = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDistrict setTitle:@"ĐỊA ĐIỂM" forState:UIControlStateNormal];
    [btnDistrict addTarget:self action:@selector(districtSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnDistrict.frame = CGRectMake(ScreenWidth/3 - 15 + 20, 5, ScreenWidth/3 - 20, 30);
    [btnDistrict.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnDistrict setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [viewMenu addSubview:btnDistrict];
    
    btnFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnFilter setTitle:@"SẮP XẾP" forState:UIControlStateNormal];
    [btnFilter addTarget:self action:@selector(filterSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnFilter.frame = CGRectMake((ScreenWidth/3 - 15 + 20)*2, 5, ScreenWidth/3 - 20, 30);
    [btnFilter.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnFilter setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [viewMenu addSubview:btnFilter];
    
    UIView * vLineBreak = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3 - 0.5, 0, 1, 40)];
    vLineBreak.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vLineBreak];
    
    UIView * vLineBreak2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2 - 1, 0, 1, 40)];
    vLineBreak2.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vLineBreak2];
    
    UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 10)];
    vPadding.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
    //    vPadding.backgroundColor = [UIColor lightGrayColor];
    [viewMenu addSubview:vPadding];
    
    UIImageView * vDownBreak = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/3 - 12, 16, 8, 8)];
    vDownBreak.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak];
    
    UIImageView * vDownBreak2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/3*2 - 12, 16, 8, 8)];
    vDownBreak2.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak2];
    
    UIImageView * vDownBreak3 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/3*3 - 12, 16, 8, 8)];
    vDownBreak3.image = [UIImage imageNamed:@"arrow-down"];
    [viewMenu addSubview:vDownBreak3];
    
    
    
    [self.view addSubview:viewMenu];
}

-(void)initDataMenu
{
    arrMenu1 = [[NSMutableArray alloc]init];
    MenuObject * item = [MenuObject new];
    item.strName = @"TẤT CẢ";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"BUFFET & BBQ";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"SET ĂN";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"LẨU";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"ĂN CHAY";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"CAFE & KEM";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"YẾN SÀO";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"LẨU";
    [arrMenu1 addObject:item];
    
    item = [MenuObject new];
    item.strName = @"HẢI SẢN";
    [arrMenu1 addObject:item];
    
    arrMenu2 = [[NSMutableArray alloc]init];
    MenuObject * item2 = [MenuObject new];
    item2.strName = @"QUẬN 1";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 2";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 3";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 4";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 5";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 6";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 7";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 8";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 9";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 10";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 11";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"QUẬN 12";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"GÒ VẤP";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"TÂN BÌNH";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"PHÚ NHUẬN";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"NHÀ BÈ";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"BÌNH TÂN";
    [arrMenu2 addObject:item2];
    
    item2 = [MenuObject new];
    item2.strName = @"CỦ CHI";
    [arrMenu2 addObject:item2];
    
    arrMenu2_2 = [[NSMutableArray alloc]init];
    MenuObject * item2_2 = [MenuObject new];
    item2_2.strName = @"TẤT CẢ";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"LOTTE MART Q7";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"LOTTE MART Q2";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"DIAMOND PLAZA";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"PARKSON H.VƯƠNG";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"CRESENT MALL";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"BIG C";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"QUẬN 8";
    [arrMenu2_2 addObject:item2_2];
    
    item2_2 = [MenuObject new];
    item2_2.strName = @"VIVO CITY";
    [arrMenu2_2 addObject:item2_2];
    
    arrMenu3 = [[NSMutableArray alloc]init];
    MenuObject * item3 = [MenuObject new];
    item3.strName = @"MỚI NHẤT";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"LƯỢT MUA";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"GIÁ";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"ĐÁNH GIÁ";
    [arrMenu3 addObject:item3];
    
    item3 = [MenuObject new];
    item3.strName = @"SẮP HẾT HẠN";
    [arrMenu3 addObject:item3];
    
    
}
-(void)showMenu
{
    if(isShowSortMenu2 == NO)
    {
        [self callbackMenu];
    }
    else
    {
        isShowSortMenu2 = NO;
        [self dissmissMenu];
    }
}

-(void)dissmissMenu
{
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDistrict setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (vHeaderLocation != nil) {
        [vHeaderLocation removeFromSuperview];
        vHeaderLocation = nil;
    }
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, 50, ScreenWidth, collectionView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [self.collectionView removeFromSuperview];
                         dimView.alpha = 0;
                     }];
    
}

-(void)changeSegment:(UIButton *)sender
{
    if (sender.tag == 0) {
        [vSegment2 removeFromSuperview];
        [vSegment1 removeFromSuperview];
        is_segment1 = TRUE;
        vSegment1 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/4 - 30, 24, 40, 2)];
        vSegment1.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
        [vHeaderLocation addSubview:vSegment1];
        [collectionView reloadData];
    }
    else
    {
        [vSegment2 removeFromSuperview];
        [vSegment1 removeFromSuperview];
        is_segment1 = FALSE;
        if (IS_IPHONE_6 || IS_IPHONE_6_PLUS) {
            vSegment2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2+10, 24, 150, 2)];
        }
        else
        {
            vSegment2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-7, 24, 150, 2)];
        }
        vSegment2.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
        [vHeaderLocation addSubview:vSegment2];
        [collectionView reloadData];
    }
}
-(void)initCollectionWithNumOfItem:(int)quantity
{
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    double d = (double)quantity/3; int i = quantity/3;
    if (d > i) {
        iMenuRow1 = i + 1;
    }
    else
        iMenuRow1 = i;
    //    flowLayout.itemSize = CGSizeMake(100, 100);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    //    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    if (self.collectionView != nil) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
    }
    if (iIndexMenu == 1) {
        //    if (iIndexMenu == 1){
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, iMenuRow1*CollectionItemHeight1 + 30) collectionViewLayout:flowLayout];
        [btnKind setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
    }
    if (iIndexMenu == 2) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, iMenuRow1*CollectionItemHeight1 + 30) collectionViewLayout:flowLayout];
        [btnDistrict setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
    }
    if (iIndexMenu == 3)    {
        [btnFilter setTitleColor:[UIColor colorWithHex:@"#0cba06" alpha:1] forState:UIControlStateNormal];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, iMenuRow1*CollectionItemHeight2) collectionViewLayout:flowLayout];
    }
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionItem" bundle:nil] forCellWithReuseIdentifier:@"CustomCollectionItem"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    if (vHeaderLocation != nil) {
        [vHeaderLocation removeFromSuperview];
        vHeaderLocation = nil;
    }
    if (iIndexMenu == 2) {
        vHeaderLocation = [[UIView alloc]initWithFrame:CGRectMake(0, 41, ScreenWidth, 30)];
        vHeaderLocation.backgroundColor = [UIColor whiteColor];
        
        if (is_segment1 == FALSE) {
            if (IS_IPHONE_6 || IS_IPHONE_6_PLUS) {
                vSegment2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2+10, 24, 150, 2)];
            }
            else
            {
                vSegment2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-7, 24, 150, 2)];
            }
            vSegment2.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
            [vHeaderLocation addSubview:vSegment2];
        }
        else
        {
            vSegment1 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/4 - 30, 24, 40, 2)];
            vSegment1.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
            [vHeaderLocation addSubview:vSegment1];
        }
        UIButton * btnDistrict2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnDistrict2 setFrame:CGRectMake(0, 5, ScreenWidth/2-20, 20)];
        [btnDistrict2.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        btnDistrict2.tag = 0;
        [btnDistrict2 setTitle:@"QUẬN" forState:UIControlStateNormal];
        [btnDistrict2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnDistrict2 addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventTouchUpInside];
        [vHeaderLocation addSubview:btnDistrict2];
        
        btnDistrict2 = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnDistrict2 setFrame:CGRectMake(ScreenWidth/2, 5, ScreenWidth/2-20, 20)];
        [btnDistrict2.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        btnDistrict2.tag = 1;
        [btnDistrict2 setTitle:@"TRUNG TÂM THƯƠNG MẠI" forState:UIControlStateNormal];
        [btnDistrict2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnDistrict2 addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventTouchUpInside];
        [vHeaderLocation addSubview:btnDistrict2];
        
        UIView * viewLine = [[UIView alloc]initWithFrame:CGRectMake(10, 26, ScreenWidth-20, 1)];
        viewLine.backgroundColor = [UIColor colorWithHex:@"#DCDCDC" alpha:1];
        [vHeaderLocation addSubview:viewLine];
        [self.view addSubview:vHeaderLocation];
    }
    [UIView animateWithDuration:0
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (iIndexMenu == 1) {
                             collectionView.frame = CGRectMake(0, 41, ScreenWidth, iMenuRow1*CollectionItemHeight1 + 30);
                         }
                         if (iIndexMenu == 2) {
                             collectionView.frame = CGRectMake(0, 40 + 30, ScreenWidth, (iMenuRow1 +1)*CollectionItemHeight1 - 60);
                             
                         }
                         if(iIndexMenu == 3)
                         {
                             collectionView.frame = CGRectMake(0, 41, ScreenWidth, iMenuRow1*CollectionItemHeight2 + 30);
                         }
                         
                     }
                     completion:^(BOOL finished){
                     }];
    //    [self.view addSubview:self.postStatusView];
    
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (iIndexMenu == 1) {
        return [arrMenu1 count];
    }
    else
        if (iIndexMenu == 2) {
            if (is_segment1 == TRUE) {
                return [arrMenu2 count];
            }
            else
            {
                return [arrMenu2_2 count];
            }
        }
        else {
            return [arrMenu3 count];
        }
}

- (void)collectionView:(UICollectionView *)collectionViews didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionItem * cell = (CustomCollectionItem*)[collectionViews cellForItemAtIndexPath:indexPath];
    [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    
    if (iIndexMenu == 1) {
        lastIndexPathMenu1 = indexPath;
        [btnKind setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
    }
    if (iIndexMenu == 2) {
        if (is_segment1 == TRUE) {
            lastIndexPathMenu2 = indexPath;
            [btnDistrict setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
        }
        else
        {
            lastIndexPathMenu2_2 = indexPath;
            [btnDistrict setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
        }
    }
    if (iIndexMenu == 3) {
        lastIndexPathMenu3 = indexPath;
        [btnFilter setTitle:cell.btnName.titleLabel.text forState:UIControlStateNormal];
    }    [self dissmissMenu];
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDistrict setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    isShowSortMenu2 = NO;
}

- (void)buttonClicked:(UIButton *)button
{
    UA_log(@"%@", button.titleLabel.text);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    [[collectionView delegate] collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    if (iIndexMenu == 1) {
        lastIndexPathMenu1 = indexPath;
        [btnKind setTitle:button.titleLabel.text forState:UIControlStateNormal];
    }
    if (iIndexMenu == 2) {
        if (is_segment1 == TRUE) {
            lastIndexPathMenu2 = indexPath;
            [btnDistrict setTitle:button.titleLabel.text forState:UIControlStateNormal];
        }
        else
        {
            lastIndexPathMenu2_2 = indexPath;
            [btnDistrict setTitle:button.titleLabel.text forState:UIControlStateNormal];
        }
    }
    if (iIndexMenu == 3) {
        lastIndexPathMenu3 = indexPath;
        [btnFilter setTitle:button.titleLabel.text forState:UIControlStateNormal];
    }
    
    [btnFilter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDistrict setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnKind setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionViews cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CustomCollectionItem";
    CustomCollectionItem *cell = [collectionViews dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.btnName addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    MenuObject * item  = [MenuObject new];
    if (iIndexMenu == 1) {
        item = [arrMenu1 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu1]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
    }
    if (iIndexMenu == 2) {
        if (is_segment1 == TRUE) {
            item = [arrMenu2 objectAtIndex:indexPath.row];
            if ([indexPath isEqual:lastIndexPathMenu2]) {
                [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
            }
            else
            {
                [cell.btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:0.3]];
            }
        }
        else
        {
            item = [arrMenu2_2 objectAtIndex:indexPath.row];
            if ([indexPath isEqual:lastIndexPathMenu2_2]) {
                [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
            }
            else
            {
                [cell.btnName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:0.3]];
            }
        }
        
    }
    if (iIndexMenu == 3) {
        item = [arrMenu3 objectAtIndex:indexPath.row];
        if ([indexPath isEqual:lastIndexPathMenu3]) {
            [cell.btnName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnName setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        }
    }
    [cell.btnName setTitle:item.strName forState:UIControlStateNormal];
    cell.btnName.layer.cornerRadius = 3;
    cell.btnName.layer.masksToBounds = YES;
    cell.btnName.tag = indexPath.row;
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (iIndexMenu == 1||iIndexMenu == 2) {
        if (IS_IPHONE_6) {
            return  CGSizeMake(105, 50);
        }
        if (IS_IPHONE_6_PLUS) {
            return  CGSizeMake(115, 50);
        }
        return CGSizeMake(90, 50);
    }
    else
    {
        if (IS_IPHONE_6) {
            return  CGSizeMake(105, 33);
        }
        if (IS_IPHONE_6_PLUS) {
            return  CGSizeMake(115, 33);
        }
        return CGSizeMake(90, 33);
    }
}

@end
