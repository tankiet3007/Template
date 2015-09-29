//
//  MainViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//
#import "CategoryObject.h"
#import "UIScrollView+UzysAnimatedGifPullToRefresh.h"
#import "MainViewController.h"
#import "DealItem.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"
#import "CategoryViewController.h"
#import "PromotionViewController.h"
#import "DealCell.h"
#import "DealObject.h"
#import "SVPullToRefresh.h"
#import "NearLocationViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"
#import "SupplierCell.h"
#import "SearchViewController.h"
#import "CategorySpaViewController.h"
#import "CategoryFashionViewController.h"
#import "CategoryTravelViewController.h"
#import "DetailViewController.h"
#import "DetailHasProductViewController.h"
#define HEADER_HEIGHT 140
#define PADDING 12
#define FETCH_COUNT 10
@interface MainViewController ()

@end

@implementation MainViewController
{
    BOOL isShowSortMenu;
    UIButton * menuBtn;
    UIView * viewMenu;
    int iMenuselected;
    UIButton * btnHCM;
    UIButton * btnHN;
    UIButton * btnOther;
    
    SWRevealViewController *revealController;
    ImageSlide *imageSlideTop;
    UIScrollView * scrollView;
    UIScrollView * scrollViewCategory;
    NSMutableArray * arrNewDeals;
    UISegmentedControl *segmentedControl;
    UIView * viewHeader;
    UIView * viewLarge;
    
    NSMutableArray * arrSale;
    NSMutableArray * arrNew;
    NSMutableArray * arrNear;
    
    __weak IBOutlet UILabel *lblNetwordStatus;
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
    
    NSMutableArray * arrCategory;
}
@synthesize tableViewMain;
#pragma mark init Method
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    isShowSortMenu= NO;
    iMenuselected = 0;
    //    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LS(@"MessageBoxTitle") message:@"Có lỗi trong quá trình lấy dữ liệu" delegate:self cancelButtonTitle:@"Tải lại" otherButtonTitles:@"Huỷ", nil];
    //    [alert show];
    //    [self showDialog];
    //    lblNetwordStatus.text = @"Có lỗi trong quá trình lấy dữ liệu";
    
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
    //    [self setupSegment];
    [self setupLargeBanner];
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
    imageSlideTop = [[ImageSlide alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
    NSMutableArray * galleryImages = [NSMutableArray arrayWithObjects:@"http://images.hotdeals.vn/images/detailed/748/130693--feature--(1).jpg",@"http://images.hotdeals.vn/images/detailed/730/155360-eden-resort-feature.jpg", nil];
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
    HUD.labelText = @"";
    [self getLocation];
    [[TKAPI sharedInstance]getRequestAF:jsonDictionary withURL:URL_DEAL_LIST completion:^(NSDictionary * dict, NSError *error) {
        //        [HUD hide:YES];
        if (dict == nil) {
            [HUD hide:YES];
            ALERT_DELEGATE(LS(@"MessageBoxTitle"), LS(@"NetworkError"), self);
            [self initUITableView];
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
            item.isNew = YES;
            item.strBrandImage = [dictItem objectForKey:@"image_link"];
            item.iType = [[dictItem objectForKey:@"type"]intValue];
            [arrDeals addObject:item];
        }
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
            item.iType = [[dictItem objectForKey:@"product_kind"]intValue];
            if ([arrDeals count]>10) {
                break;
            }
            [arrDeals addObject:item];
        }
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
        [tableViewMain reloadData];
    }];
}


-(UIScrollView *)setupCategory
{
    arrCategory = [NSMutableArray new];
    CategoryObject * categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"food";
    categoryItem.strTitle = @"ĂN UỐNG";
    [arrCategory addObject:categoryItem];
    
    categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"spa";
    categoryItem.strTitle = @"SPA LÀM ĐẸP";
    [arrCategory addObject:categoryItem];
    
    categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"fashion";
    categoryItem.strTitle = @"THỜI TRANG";
    [arrCategory addObject:categoryItem];
    
    categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"tralvel";
    categoryItem.strTitle = @"DU LỊCH";
    [arrCategory addObject:categoryItem];
    
    categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"enter";
    categoryItem.strTitle = @"ĐÀO TẠO GIẢI TRÍ";
    [arrCategory addObject:categoryItem];
    
    categoryItem = [CategoryObject new];
    categoryItem.strID = @"1010";
    categoryItem.strImage = @"sanpham";
    categoryItem.strTitle = @"SẢN PHẨM";
    [arrCategory addObject:categoryItem];
    
    if (scrollViewCategory != nil) {
        [scrollViewCategory removeFromSuperview];
        scrollViewCategory = nil;
    }
    scrollViewCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 110)];
    scrollViewCategory.showsHorizontalScrollIndicator = NO;
    scrollViewCategory.backgroundColor = [UIColor whiteColor];
    
    //    [scrollViewCategory setBounces:NO];
    int x = 20;
    for (int i = 0; i < [arrCategory count]; i++) {
        categoryItem = [arrCategory objectAtIndex:i];
        UIButton * btnCategory = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCategory setFrame:CGRectMake(x, 0, 52, 52)];
//        [btnCategory setBackgroundImage:[UIImage imageNamed:categoryItem.strImage] forState:UIControlStateNormal];
        [btnCategory setImage:[UIImage imageNamed:categoryItem.strImage] forState:UIControlStateNormal];
        btnCategory.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnCategory.tag = i;
        [btnCategory addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
//        btnCategory.layer.borderColor = [UIColor colorWithHex:@"#D2D7D3" alpha:1].CGColor;
//        btnCategory.layer.cornerRadius = btnCategory.bounds.size.width/2;;
//        btnCategory.layer.borderWidth=1.0f;
//        btnCategory.layer.masksToBounds = YES;
        [scrollViewCategory addSubview:btnCategory];
        
        UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(x, 52, 52, 30)];
        lblName.font = [UIFont boldSystemFontOfSize:10	];
        lblName.text = categoryItem.strTitle;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.userInteractionEnabled = NO;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.numberOfLines = 2;
        [scrollViewCategory addSubview:lblName];
        //        [cell.scrollViewCell addSubview:itemS];
        x += btnCategory.frame.size.width+25;
        
        
    }
    scrollViewCategory.contentSize = CGSizeMake(x, scrollViewCategory.frame.size.height);
    UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 100, x, 10)];
    vPadding.backgroundColor = [UIColor colorWithHex:@"#C8C8C8" alpha:0.8];
    [scrollViewCategory addSubview:vPadding];
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
- (void)refresh:(id)sender
{
    NSLog(@"Refreshing");
}
-(void)initUITableView
{
    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 66) style:UITableViewStylePlain];
    [self.view addSubview:tableViewMain];
    // Initialize Refresh Control
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    [tableViewMain setAllowsSelection:YES];
    tableViewMain.separatorColor = [UIColor clearColor];
    
    tableViewMain.showsVerticalScrollIndicator = NO;
    //    tableViewMain.sectionHeaderHeight = 0.0;
    
    __weak MainViewController *weakSelf = self;
    
    // setup pull-to-refresh
    [weakSelf.tableViewMain addPullToRefreshWithActionHandler:^{
        [self refreshTable];
        [weakSelf.tableViewMain.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    //    __weak typeof(self) weakSelf =self;
    //    [self.tableViewMain addPullToRefreshActionHandler:^{
    //         [weakSelf refreshTable];
    //    }
    //                            ProgressImagesGifName:@"cupido.gif"
    //                             LoadingImagesGifName:@"jgr.gif"
    //                          ProgressScrollThreshold:60
    //                            LoadingImageFrameRate:30];
    //    CGFloat landscapeTopInset = 32.0;
    //    [self.tableViewMain addTopInsetInPortrait:0 TopInsetInLandscape:landscapeTopInset];
    
    
}

-(BOOL) isInternetReachable
{
    BOOL isConnected = [AFNetworkReachabilityManager sharedManager].reachable;
    return isConnected;
}

-(void)initNavigationbar
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width - 80, 28.0)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:12];
    textField.layer.cornerRadius = 15;
    textField.placeholder = @"Tìm kiếm";
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, textField.frame.size.height)];
    leftView.backgroundColor = textField.backgroundColor;
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    self.navigationItem.titleView = textField;
    //    UIImage *image = [UIImage imageNamed:@"menu_n.png"];
    menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setTitle:@"HCM" forState:UIControlStateNormal];
    menuBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [menuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    //    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    [menuBtn setFrame:CGRectMake(0, 0, 40, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuBtn];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"icon_cart.png"] forState:UIControlStateNormal];
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    barButton.badgeOriginX = 25;
    barButton.badgeOriginY = -5;
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        iBadge += item.iCurrentQuantity;
    }
    barButton.badgeValue = F(@"%d",iBadge);
//    self.navigationItem.rightBarButtonItem = barButton;
    
    
    UIButton *customButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // Add your action to your button
    [customButton2 addTarget:self action:@selector(mapAction) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton2 setImage:[UIImage imageNamed:@"icon_location"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc]initWithCustomView:customButton2];

    
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:barButton,rightButton2,nil];
    [self.navigationItem setRightBarButtonItems:myButtonArray];
//    self.navigationItem.rightBarButtonItem = rightButton;
    
}
-(void)mapAction
{
    NearLocationViewController * nearLC = [[NearLocationViewController alloc]init];
    [self.navigationController pushViewController:nearLC animated:YES];
}
-(void)shoppingCart
{
    //    NearLocationViewController * nearLC = [[NearLocationViewController alloc]init];
    //    [self.navigationController pushViewController:nearLC animated:YES];
    if ([arrProduct count] == 0) {
        return;
    }
    CartViewController * shopping = [[CartViewController alloc]init];
    //        shopping.delegate = self;
    [self.navigationController pushViewController:shopping animated:YES];
    //    CategoryViewController * category = [[CategoryViewController alloc]init];
    //    category.strTitle = @"Danh mục";
    //    [self.navigationController pushViewController:category animated:YES];
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
        //        return headerHeight;
        return 120;
    }    if (indexPath.section == 1) {
        //        return 230;
        return headerHeight;
    }
    //    if (indexPath.section == 2) {
    //        return 120;
    //    }
    if (indexPath.section == 2) {
        //        return 40;
        return 265;
    }
    if (indexPath.section == 4) {
        return 100;
    }
    return 50;
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
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:scrollViewCategory];
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:imageSlideTop];
        
        UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 130, ScreenWidth, 10)];
        vPadding.backgroundColor = [UIColor colorWithHex:@"#C8C8C8" alpha:0.8];
        [cell.contentView addSubview:vPadding];
        
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell.contentView addSubview:viewHeader];
        [cell.contentView addSubview:viewLarge];
        
        return cell;
    }
    if (indexPath.section == 4) {
        static NSString *simpleTableIdentifier = @"SupplierCell";
        
        SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(12, 98, ScreenWidth -20, 1)];
        line.tag = 101;
        line.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:line];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
//        DLStarRatingControl *starRating = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(82, 37, 120, 26) andStars:5 isFractional:YES];
        DLStarRatingControl *starRating = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(75, 41, 120, 26)];
        starRating.backgroundColor = [UIColor clearColor];
        //        cell.starRating.rating =  item.iRate ;
        starRating.rating = 3.5;
        starRating.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        starRating.isFractionalRatingEnabled = YES;
        starRating.userInteractionEnabled = NO;
        [cell.contentView addSubview:starRating];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.section == 3) {
        UIView * vHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        UILabel *lblDeal = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-80, 25, 140, 20)];
        lblDeal.text = @"DEAL TỔNG HỢP";
        lblDeal.font = [UIFont boldSystemFontOfSize:15];
        lblDeal.textAlignment = NSTextAlignmentCenter;
        lblDeal.textColor = [UIColor blackColor];
        [vHead addSubview:lblDeal];
        
        UIView * vPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 10)];
        vPadding.backgroundColor = [UIColor colorWithHex:@"#C8C8C8" alpha:0.7];
        [vHead addSubview:vPadding];
        
        UIView * vLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-80, 46, 140, 4)];
        vLine.backgroundColor = [UIColor redColor];
        [vHead addSubview:vLine];
        
        UIView * vLine2 = [[UIView alloc]initWithFrame:CGRectMake(10, 50, ScreenWidth - 20, 1)];
        vLine2.backgroundColor = [UIColor lightGrayColor];
        [vHead addSubview:vLine2];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        [cell.contentView addSubview:viewHeader];
        [cell.contentView addSubview:vHead];
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

-(UIView *)setupLargeBanner
{
    if (viewLarge != nil) {
        [viewLarge removeFromSuperview];
        viewLarge = nil;
    }
    viewLarge = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 255)];
    UIButton * btnBanner = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBanner setFrame:CGRectMake(PADDING, 13, ScreenWidth-PADDING*2, 120)];
    [btnBanner setBackgroundImage:[UIImage imageNamed:@"demo0.jpg"] forState:UIControlStateNormal];
    //    [btnBanner sd_setImageWithURL:[NSURL URLWithString:@"http://images5.fanpop.com/image/photos/31700000/Link-Zelda-the-legend-of-zelda-31742637-900-678.png"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    [btnBanner addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    
    btnBanner.layer.borderWidth = 2.0f;
    btnBanner.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    
    [viewLarge addSubview:btnBanner];
    
    UIButton * btnBanner2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBanner2 setFrame:CGRectMake(PADDING, HEIGHT(btnBanner)+PADDING+13, ScreenWidth/2-PADDING*2 + PADDING/2,120 )];
    //    [btnBanner2 sd_setImageWithURL:[NSURL URLWithString:@"http://images5.fanpop.com/image/photos/31700000/Link-Zelda-the-legend-of-zelda-31742637-900-678.png"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    [btnBanner2 setBackgroundImage:[UIImage imageNamed:@"demo1.jpg"] forState:UIControlStateNormal];
    [btnBanner2 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnBanner2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnBanner2.layer.borderWidth = 2;
    [viewLarge addSubview:btnBanner2];
    
    UIButton * btnBanner3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBanner3 setFrame:CGRectMake(ScreenWidth/2 + PADDING/2, HEIGHT(btnBanner)+PADDING+13, ScreenWidth/2-PADDING*2 + PADDING/2,  120)];
    //    btnBanner3.layer.borderColor=[UIColor grayColor].CGColor;    [btnBanner3 sd_setImageWithURL:[NSURL URLWithString:@"http://images5.fanpop.com/image/photos/31700000/Link-Zelda-the-legend-of-zelda-31742637-900-678.png"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"clickme-1-320x200"]];
    [btnBanner3 setBackgroundImage:[UIImage imageNamed:@"demo2.jpg"] forState:UIControlStateNormal];
    [btnBanner3 addTarget:self action:@selector(clickOnCategory:) forControlEvents:UIControlEventTouchUpInside];
    btnBanner3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnBanner3.layer.borderWidth = 2;
    [viewLarge addSubview:btnBanner3];
    
    return viewLarge;
    
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
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            if (indexPath.row == 0) {
//                DetailHasProductViewController * detail = [[DetailHasProductViewController alloc]init];
//                DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
//                detail.iProductID = dealObj.product_id;
//                [self.navigationController pushViewController:detail animated:YES];
//                
//            }
//            else
//            {
                DetailViewController * detail = [[DetailViewController alloc]init];
                DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
                detail.iProductID = dealObj.product_id;
                [self.navigationController pushViewController:detail animated:YES];
//            }
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
        long iI = btnTag.tag;
        if (iI == 0) {
            CategoryObject * cateObj = [arrCategory objectAtIndex:btnTag.tag];
            CategoryViewController * category = [[CategoryViewController alloc]init];
            category.cateItem = cateObj;
            category.strTitle = @"Danh mục";
            [self.navigationController pushViewController:category animated:YES];
            
        }
        if (iI == 1) {
            CategoryObject * cateObj = [arrCategory objectAtIndex:btnTag.tag];
            CategorySpaViewController * category = [[CategorySpaViewController alloc]init];
            category.cateItem = cateObj;
            [self.navigationController pushViewController:category animated:YES];
        }
        if (iI == 2) {
            CategoryObject * cateObj = [arrCategory objectAtIndex:btnTag.tag];
            CategoryFashionViewController * category = [[CategoryFashionViewController alloc]init];
            category.cateItem = cateObj;
            [self.navigationController pushViewController:category animated:YES];
        }
        if (iI == 3) {
            CategoryObject * cateObj = [arrCategory objectAtIndex:btnTag.tag];
            CategoryTravelViewController * category = [[CategoryTravelViewController alloc]init];
            category.cateItem = cateObj;
            [self.navigationController pushViewController:category animated:YES];
        }
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
    [dialogView setFrame:CGRectMake(10, 50, ScreenWidth - 20, 200)];
    
    dialogView.layer.borderWidth=0.5f;
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
    [self initData:FETCH_COUNT wOffset:1 wType:@"default"];
    [self hiddenView:nil];
    
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
    
    [UIView animateWithDuration:.5 animations:^{
        dialogView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self dissmissProductview];
        isShowSortMenu = NO;
        dimView.alpha = 0;
    }];
}

-(void)getLocation
{
    [[TKAPI sharedInstance]getRequestLocation:nil withURL:URL_GET_LOCATION];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self initData:FETCH_COUNT wOffset:1 wType:@"default"];
        return;
    }
    if (buttonIndex == 0) {
        return;
    }
}
-(void)setCurrentImage:(long)index
{}
#pragma mark category
-(void)showMenu
{
    
    if(isShowSortMenu == NO)
    {
        isShowSortMenu = YES;
        [self setDimView];
        [self initProvinceMenu];
    }
    else
    {
        isShowSortMenu = NO;
        [self dissmissProductview];
    }
}
-(void)dissmissProductview
{
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewMenu.frame = CGRectMake(0, -60, ScreenWidth, 60);
                     }
                     completion:^(BOOL finished){
                         if (finished)
                             [viewMenu removeFromSuperview];
                         dimView.alpha = 0;
                     }];
}
-(void)initProvinceMenu
{
    viewMenu = [[UIView alloc]initWithFrame:CGRectMake(0, -60, ScreenWidth, 60)];
    [viewMenu setBackgroundColor:[UIColor whiteColor]];
    
    btnHCM = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnHCM setTitle:@"TP HỒ CHÍ MINH" forState:UIControlStateNormal];
    [btnHCM addTarget:self action:@selector(provinceSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnHCM.frame = CGRectMake(10, 15, ScreenWidth/3 - 20, 30);
    [btnHCM.titleLabel setFont:[UIFont systemFontOfSize:10]];
    btnHCM.layer.cornerRadius = 3;
    btnHCM.layer.masksToBounds = YES;
    if (iMenuselected == 0) {
        [btnHCM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnHCM setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    }
    else
    {
        [btnHCM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHCM setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:0.3]];
    }
    [viewMenu addSubview:btnHCM];
    
    btnHN = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnHN setTitle:@"HÀ NỘI" forState:UIControlStateNormal];
    [btnHN addTarget:self action:@selector(provinceSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnHN.frame = CGRectMake(ScreenWidth/3 - 15 + 25, 15, ScreenWidth/3 - 20, 30);
    [btnHN.titleLabel setFont:[UIFont systemFontOfSize:10]];
    btnHN.layer.cornerRadius = 3;
    btnHN.layer.masksToBounds = YES;
    if (iMenuselected == 1) {
        [btnHN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnHN setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    }
    else
    {
        [btnHN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHN setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:0.3]];
    }
    
    
    [viewMenu addSubview:btnHN];
    
    btnOther = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnOther setTitle:@"KHÁC" forState:UIControlStateNormal];
    [btnOther addTarget:self action:@selector(provinceSelect:) forControlEvents:UIControlEventTouchUpInside];
    btnOther.frame = CGRectMake((ScreenWidth/3 - 15 + 20)*2, 15, ScreenWidth/3 - 20, 30);
    [btnOther.titleLabel setFont:[UIFont systemFontOfSize:10]];
    btnOther.layer.cornerRadius = 3;
    btnOther.layer.masksToBounds = YES;
    if (iMenuselected == 2) {
        [btnOther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnOther setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    }
    else
    {
        [btnOther setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnOther setBackgroundColor:[UIColor colorWithHex:@"#DCDCDC" alpha:0.3]];
    }
    
    [viewMenu addSubview:btnOther];
    //    [self.view addSubview:viewCT];
    
    viewMenu.frame = CGRectMake(0, -60, ScreenWidth, 60);
    
    [UIView animateWithDuration:0.2
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         viewMenu.frame = CGRectMake(0, 0, ScreenWidth, 60);
                     }
                     completion:^(BOOL finished){
                     }];
    //    [self.view addSubview:self.postStatusView];
    [self.view addSubview:viewMenu];
}

-(void)provinceSelect:(id)sender
{
    
    UIButton * btnSender = (UIButton*)sender;
    if ([btnSender isEqual:btnHCM]) {
        iMenuselected = 0;
        [btnHCM setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnHCM setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        
        [btnHN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHN setBackgroundColor:[UIColor whiteColor]];
        
        
        [btnOther setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnOther setBackgroundColor:[UIColor whiteColor]];
        [menuBtn setTitle:@"HCM" forState:UIControlStateNormal];
        
    }
    if ([btnSender isEqual:btnHN]) {
        iMenuselected = 1;
        [btnHN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnHN setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        
        [btnHCM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHCM setBackgroundColor:[UIColor whiteColor]];
        
        
        [btnOther setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnOther setBackgroundColor:[UIColor whiteColor]];
        
        [menuBtn setTitle:@"HN" forState:UIControlStateNormal];
    }
    
    if ([btnSender isEqual:btnOther]) {
        iMenuselected = 2;
        [btnOther setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnOther setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
        
        [btnHN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHN setBackgroundColor:[UIColor whiteColor]];
        
        
        [btnHCM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnHCM setBackgroundColor:[UIColor whiteColor]];
        [menuBtn setTitle:@"KHÁC" forState:UIControlStateNormal];
    }
    [self dissmissProductview];
    isShowSortMenu = NO;
}
#pragma mark textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController * searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

@end
