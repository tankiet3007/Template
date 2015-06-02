//
//  MainViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "MainViewController.h"
#import "DealItem.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"
#import "CategoryViewController.h"
#import "PromotionViewController.h"
#import "DealCell.h"
#import "DealObject.h"
#import "SVPullToRefresh.h"

#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"
#define HEADER_HEIGHT 166
#define PADDING 10
#define FETCH_COUNT 10
@interface MainViewController ()

@end

@implementation MainViewController
{
    SWRevealViewController *revealController;
    ImageSlide *imageSlideTop;
    UIScrollView * scrollView;
    UIScrollView * scrollViewCategory;
    NSMutableArray * arrNewDeals;
    UISegmentedControl *segmentedControl;
    UIView * viewHeader;
    NSMutableArray * arrSale;
    NSMutableArray * arrNew;
    NSMutableArray * arrNear;
    
    NSMutableArray * arrDeals;
    BBBadgeBarButtonItem *barButton;
    NSArray * arrProduct;
    UIView *dialogView;
    UIView* dimView;
    MBProgressHUD *HUD;
    BOOL bForceStop;
    NSString * strCategory;
    BOOL isConnection;
    float headerHeight;
    UILabel * lblLastestDeal;
}
@synthesize tableViewMain;
#pragma mark init Method
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    if (IS_IPHONE_6) {
        headerHeight = HEADER_HEIGHT + 30;
    }
    if (IS_IPHONE_6_PLUS) {
        headerHeight = HEADER_HEIGHT + 50;
    }
    else
    {
        headerHeight = HEADER_HEIGHT;
    }
    
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    bForceStop = FALSE;
    
    
    [self initNavigationbar];
    [self initHUD];
    strCategory = @"default";
    [self initData:FETCH_COUNT wOffset:1 wType:@"default" ];
    
    [self setupSlide];
    //    [self setupNewDeal];
    [self setupCategory];
    [self setupSegment];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateDealCount:) name:@"notiDealCount"
                                               object:nil];
    
    //    [self showDialog];
    // Do any additional setup after loading the view from its nib.
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notiDealCount" object:nil];
}
- (void)updateDealCount:(NSNotification *)notification {
    [self updateTotal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupSlide
{
    if (imageSlideTop != nil) {
        [imageSlideTop removeFromSuperview];
        imageSlideTop = nil;
    }
    imageSlideTop = [[ImageSlide alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, headerHeight)];
    NSMutableArray * galleryImages = [NSMutableArray arrayWithObjects:@"http://desktop.freewallpaper4.me/view/original/5976/link-from-legend-of-zelda.jpg",@"http://desktop.freewallpaper4.me/view/original/5976/link-from-legend-of-zelda.jpg", nil];
    imageSlideTop.galleryImages = galleryImages;
    imageSlideTop.delegate = self;
    [imageSlideTop initScrollLocal2];
}
-(void)initData:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    @437, @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    nil];
    arrDeals = [[NSMutableArray alloc]init];
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [self getLocation];
    [[TKAPI sharedInstance]getRequestAF:jsonDictionary withURL:URL_DEAL_LIST completion:^(NSDictionary * dict, NSError *error) {
//        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        NSArray * arrProducts = [dict objectForKey:@"product"];
        UA_log(@"%lu item", [arrDeals count]);
        for (NSDictionary * dictItem in arrProducts) {
            DealObject * item = [[DealObject alloc]init];
            item.strTitle = [dictItem objectForKey:@"title"];
            item.product_id = [[dictItem objectForKey:@"product_id"]intValue];
            item.buy_number = [[dictItem objectForKey:@"buy_number"]intValue];
            item.lDiscountPrice = [[dictItem objectForKey:@"price"]doubleValue];
            item.lStandarPrice = [[dictItem objectForKey:@"list_price"]doubleValue];
            item.isNew = YES;
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDeals addObject:item];
        }
        UA_log(@"%lu item", [arrDeals count]);
        if ([arrDeals count] == 0) {
            return ;
        }
        //        [tableViewMain reloadData];
        [self initUITableView];
        
        [self setupNewDeal];
        [HUD hide:YES];
    }];
    
}
-(void)initData2:(int)iCount wOffset:(int)iOffset wType:(NSString *)sType
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    @437, @"city",
                                    [NSNumber numberWithInt:iCount], @"fetch_count",
                                    [NSNumber numberWithInt:iOffset], @"offset",
                                    sType,@"fetch_type",
                                    nil];
    
    NSMutableIndexSet *indetsetToUpdate = [[NSMutableIndexSet alloc]init];
    
    [indetsetToUpdate addIndex:4];
    
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
            if ([arrDeals count]>10) {
                break;
            }
            [arrDeals addObject:item];
        }
        UA_log(@"%lu item", [arrDeals count]);
        [tableViewMain reloadSections:indetsetToUpdate withRowAnimation:UITableViewRowAnimationFade];
        //        [tableViewMain reloadData];
    }];
    
}

-(void)loadMoreDeal
{
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @123, @"category",
                                    @437, @"city",
                                    [NSNumber numberWithInteger:FETCH_COUNT], @"fetch_count",
                                    [NSNumber numberWithLong:[arrDeals count]], @"offset",
                                    strCategory,@"fetch_type",
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
        [tableViewMain reloadData];
    }];
}


-(UIScrollView *)setupCategory
{
    if (scrollViewCategory != nil) {
        [scrollViewCategory removeFromSuperview];
        scrollViewCategory = nil;
    }
    scrollViewCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(PADDING, 30, ScreenWidth, 80)];
    scrollViewCategory.showsHorizontalScrollIndicator = NO;
    scrollViewCategory.backgroundColor = [UIColor clearColor];
    //    [scrollView setBounces:NO];
    
    int x = 0;
    for (int i = 0; i < 10; i++) {
        UIButton * btnCategory = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCategory setFrame:CGRectMake(x, 0, 130, 70)];
        //        [btnCategory setBackgroundImage:[UIImage imageNamed:@"clickme-1-320x200"] forState:UIControlStateNormal];
        [btnCategory sd_setImageWithURL:[NSURL URLWithString:@"http://images5.fanpop.com/image/photos/31700000/Link-Zelda-the-legend-of-zelda-31742637-900-678.png"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
        btnCategory.tag = i;
        [btnCategory addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
        x += btnCategory.frame.size.width + PADDING;
        [scrollViewCategory addSubview:btnCategory];
    }
    scrollViewCategory.contentSize = CGSizeMake(x, scrollViewCategory.frame.size.height);
    return scrollViewCategory;
}

-(UIScrollView *)setupNewDeal
{
    if (scrollView != nil) {
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(PADDING, 40, ScreenWidth, 180)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    //    [scrollView setBounces:NO];
    
    int x = 0;
    for (int i = 0; i < 10; i++) {
        DealItem *itemS = [[[NSBundle mainBundle] loadNibNamed:@"DealItem" owner:self options:nil] objectAtIndex:0];
        [itemS setFrame:CGRectMake(x, 0, 250, 180)];
        [itemS.btnTemp addTarget:self action:@selector(clickOnItem:) forControlEvents:UIControlEventTouchUpInside];
        itemS.btnTemp.tag = i;
        //        itemS.backgroundColor = [UIColor greenColor];
        
        DealObject * item = [arrDeals objectAtIndex:i];
        NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
        strStardarPrice = [strStardarPrice formatStringToDecimal];
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
        itemS.lblStandarPrice.attributedText = attributedString;
        [itemS.lblStandarPrice sizeToFit];
        itemS.lblNumOfBook.text = F(@"%d",item.buy_number);
        
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        itemS.lblDiscountPrice.text = strDiscountPrice;
        itemS.lblTitle.text = item.strTitle;
        //        [itemS.imgBrand sd_setImageWithURL:[NSURL URLWithString:item.strBrandImage] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
        [itemS.imgBrand sd_setImageWithURL:[NSURL URLWithString:@"http://www.fightersgeneration.com/characters2/link-wind11.jpg"] placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
        if (item.isNew == FALSE) {
            itemS.lblNew.hidden = YES;
        }
        if (item.iType == 1) {
            itemS.lblEVoucher.hidden = YES;
        }
        
        x += itemS.frame.size.width + PADDING;
        [scrollView addSubview:itemS];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    return scrollView;
}
-(void)initUITableView
{
    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66) style:UITableViewStylePlain];
    [self.view addSubview:tableViewMain];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewMain.backgroundColor = [UIColor whiteColor];
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    [tableViewMain setAllowsSelection:YES];
    tableViewMain.separatorColor = [UIColor clearColor];
    tableViewMain.showsVerticalScrollIndicator = NO;
    tableViewMain.sectionHeaderHeight = 0.0;
    
    __weak MainViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [weakSelf.tableViewMain addPullToRefreshWithActionHandler:^{
        [self refreshTable];
        [weakSelf.tableViewMain.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    
    
}

-(BOOL) isInternetReachable
{
    BOOL isConnected = [AFNetworkReachabilityManager sharedManager].reachable;
    return isConnected;
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
    label.text = NSLocalizedString(@"Hotdeal", @"");
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
        int iCurrent = item.iCurrentQuantity;
        iBadge += iCurrent;
    }
    barButton.badgeValue = F(@"%d",iBadge);
    self.navigationItem.rightBarButtonItem = barButton;
    
}

-(void)shoppingCart
{
    
    //    if ([arrProduct count] == 0) {
    //        return;
    //    }
    ShoppingCartController * shopping = [[ShoppingCartController alloc]init];
    shopping.delegate = self;
    [self.navigationController pushViewController:shopping animated:YES];
}
#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 4) {
        return [arrDeals count];
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return headerHeight;
    }    if (indexPath.section == 1) {
        return 230;
    }
    if (indexPath.section == 2) {
        return 120;
    }
    if (indexPath.section == 3) {
        return 29;
    }
    return 230;
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
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:imageSlideTop];
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        NSArray * arrSubview = [cell.contentView subviews];
        if (lblLastestDeal == nil) {
            lblLastestDeal = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 15, ScreenWidth - 20, 20)];
            NSDate * date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd/MM"];
            NSString * strToday = [formatter stringFromDate:date];
            
            NSLog(@"%@ ,%@", strToday ,[date stringWeekday]);
            lblLastestDeal.text = F(@"Deal mới nhất %@ ngày %@",[date stringWeekday],strToday);
            lblLastestDeal.font = [UIFont boldSystemFontOfSize:14];
            lblLastestDeal.textColor = [UIColor redColor];
            [cell.contentView addSubview:lblLastestDeal];
        }
        else
            [cell.contentView addSubview:lblLastestDeal];
        [cell.contentView addSubview:scrollView];
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 5, ScreenWidth - 20, 20)];
        lblTitle.text = @"Chọn danh mục";
        lblTitle.font = [UIFont boldSystemFontOfSize:14];
        lblTitle.textColor = [UIColor redColor];
        [cell.contentView addSubview:lblTitle];
        [cell.contentView addSubview:scrollViewCategory];
        return cell;
    }
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:viewHeader];
        
        return cell;
    }
    if (indexPath.section == 4) {
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
        
        if (bForceStop == TRUE) {
            return cell;
        }
        if (indexPath.row == [arrDeals count] - 1)
        {
            //            [HUD showAnimated:YES whileExecutingBlock:^{
            [self loadMoreDeal];
            //            }completionBlock:^{
            //                [self.tableViewMain performSelectorOnMainThread:@selector(reloadData)
            //                                                       withObject:nil
            //                                                    waitUntilDone:NO];
            //
            //            }];
        }
        
        
        return cell;
    }
    
    
    return nil;
}
-(UIView *)setupSegment
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 29)];
    if (segmentedControl != nil) {
        [segmentedControl removeFromSuperview];
        segmentedControl = nil;
    }
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bán chạy", @"Mới nhất", @"Gần nhất", nil];
    CGRect myFrame = CGRectMake(10.0f, 0, ScreenWidth -20, 29);
    
    //create an intialize our segmented control
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    //set the size and placement
    segmentedControl.frame = myFrame;
    segmentedControl.tintColor = [UIColor darkGrayColor];
    [segmentedControl addTarget:self action:@selector(mySegmentControlAction) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [viewHeader addSubview:segmentedControl];
    return viewHeader;
    
}

-(void)mySegmentControlAction
{
    arrDeals = [[NSMutableArray alloc]init];
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        //        UA_log(@"0");
        strCategory = @"default";
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        UA_log(@"1");
        strCategory = @"newest";
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        UA_log(@"2");
        strCategory = @"sale";
    }
    [self initData2:10 wOffset:1 wType:strCategory];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isInternetReachable]) {
        if (indexPath.section == 4) {
            HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
            DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
            detail.iProductID = dealObj.product_id;
//            [[TKDatabase sharedInstance]getDictrictByStateID:@"423"];
            
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    else
    {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
    }
    
}

#pragma mark - Drag delegate methods

-(void)refreshTable
{
    int64_t delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self initData:10 wOffset:1 wType:@"default" ];
        segmentedControl.selectedSegmentIndex = 0;
        [tableViewMain reloadData];
        //            [self getNEWSCampaign:[arrNews count] andSize:10 wKeyword:searchBars.text];
    });
    
}

#pragma mark -- show deal detail

-(void)topCellClick:(long)index
{
    NSLog(@"delegate %ld",index);
    PromotionViewController * promotionDetail = [[PromotionViewController alloc]init];
    [self.navigationController pushViewController:promotionDetail animated:YES];
}

-(void)clickOnCategory:(id)sender
{
    if ([self isInternetReachable]) {
        UIButton * btnTag = (UIButton *)sender;
        UA_log(@"button is at %ld index", (long)btnTag.tag);
        
        CategoryViewController * category = [[CategoryViewController alloc]init];
        category.strTitle = @"Danh mục";
        [self.navigationController pushViewController:category animated:YES];
    }
    else
    {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
    }
}

-(void)clickOnItem:(id)sender
{
    if ([self isInternetReachable]) {
        UIButton * btnTag = (UIButton *)sender;
        UA_log(@"button is at %ld index", (long)btnTag.tag);
        HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
        DealObject * dealObj = [arrDeals objectAtIndex:(long)btnTag.tag];
        detail.iProductID = dealObj.product_id;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
    }
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

-(void)showDialog
{
    
    [self setDimView];
    if (dialogView != nil) {
        [UIView animateWithDuration:.5 animations:^{
            dialogView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
        return;
    }
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NetworkErrorView" owner:self options:nil];
    
    dialogView = [[UIView alloc] initWithFrame:CGRectMake(10, 50, ScreenWidth -20, 200)]; // or if it exists, MCQView *view = [[MCQView alloc] init];
    dialogView = (UIView *)[nib objectAtIndex:0]; // or if it exists, (MCQView *)[nib objectAtIndex:0];
    [dialogView setFrame:CGRectMake(10, 200, ScreenWidth - 20, 200)];
    
    dialogView.layer.borderWidth=1.0f;
    dialogView.layer.borderColor=[UIColor whiteColor].CGColor;
    dialogView.layer.cornerRadius = 5;
    dialogView.layer.masksToBounds = YES;
    
    [self.view addSubview:dialogView];
    dialogView.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        dialogView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
}
- (IBAction)refreshView:(id)sender {
    
    
}
-(void)setDimView
{
    if (dimView != nil) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             dimView.alpha = 0.6;
                         }];
        return;
    }
    dimView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
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
- (IBAction)hiddenView:(id)sender {
    dimView.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        dialogView.alpha = 0;
    } completion:^(BOOL finished) {
    }];
}

-(void)getLocation
{
    [[TKAPI sharedInstance]getRequestLocation:nil withURL:URL_GET_LOCATION];
}
//-(void)getLocation
//{
//    
//    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
//                            stringForKey:@"SyncDone"];
//    if (savedValue != nil && ![savedValue isEqualToString:@""]) {
//        [HUD hide:YES];
//        return;
//    }
////    [HUD show:YES];
//    [[TKAPI sharedInstance]getRequest:nil withURL:URL_GET_LOCATION completion:^(NSDictionary * dict, NSError *error) {
//        [HUD hide:YES];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSArray * arrState = [dict objectForKey:@"states"];
//            NSArray * arrDistrict = [dict objectForKey:@"districts"];
//            NSArray * arrWard = [dict objectForKey:@"wards"];
//            for (NSDictionary * dictItem in arrState) {
//                NSString * ID_Tinh_Thanh = [dictItem objectForKey:@"ID_Tinh_Thanh"];
//                NSString * Ten_Tinh_Thanh = [dictItem objectForKey:@"Ten_Tinh_Thanh"];
//                NSString * logistic_location_id = [dictItem objectForKey:@"logistic_location_id"];
//                [[TKDatabase sharedInstance]addState:ID_Tinh_Thanh wStateName:Ten_Tinh_Thanh wStateLogictic:logistic_location_id];
//            }
//            for (NSDictionary * dictItem in arrDistrict) {
//                NSString * ID_Tinh_Thanh = [dictItem objectForKey:@"ID_Tinh_Thanh"];
//                NSString * ID_Quan_Huyen = [dictItem objectForKey:@"ID_Quan_Huyen"];
//                NSString * Ten_Quan_Huyen = [dictItem objectForKey:@"Ten_Quan_Huyen"];
//                NSString * logistic_location_id = [dictItem objectForKey:@"logistic_location_id"];
//                [[TKDatabase sharedInstance]addDistrict:ID_Quan_Huyen wDistrictName:Ten_Quan_Huyen wDistrictLogictic:logistic_location_id wStateID:ID_Tinh_Thanh];
//            }
//            
//            for (NSDictionary * dictItem in arrWard) {
//                NSString * ID_Phuong_Xa = [dictItem objectForKey:@"ID_Phuong_Xa"];
//                NSString * Ten_Phuong_Xa = [dictItem objectForKey:@"Ten_Phuong_Xa"];
//                NSString * ID_Quan_Huyen = [dictItem objectForKey:@"ID_Quan_Huyen"];
//                [[TKDatabase sharedInstance]addWard:ID_Phuong_Xa wWardName:Ten_Phuong_Xa wDistrictID:ID_Quan_Huyen];
//            }
//            UA_log(@"%lu [arrState count]", (unsigned long)[arrState count]);
//            UA_log(@"%lu [arrDistrict count]", (unsigned long)[arrDistrict count]);
//            UA_log(@"%lu [arrWard count]", (unsigned long)[arrWard count]);
//            NSString *valueToSave = @"SyncDone";
//            [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"SyncDone"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
////        [HUD hide:YES];
//        });
//    }];
//    
//}
@end
