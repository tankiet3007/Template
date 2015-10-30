//
//  HomePageViewController.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageTableViewCell.h"
#import "SWRevealViewController.h"
#import "ReflectionView.h"
#import "LocationObj.h"
#import "AppDelegate.h"
#import "CategoryViewController.h"
#import "SearchViewController.h"
#import "TestCalendarViewController.h"
#import "DetailDealViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    SWRevealViewController *revealController;
    LocationObj * locationStored;
}
- (void)openCategory:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"openCategory"]) {
        NSNumber * nCateID = (NSNumber *)notification.object;
        [self opendCategry:nCateID withTitle:@""];
    }
}

-(void)openLeftMenu
{
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    if (sideMenuController) {
        [sideMenuController openMenu];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openCategory:)
                                                 name:@"openCategory"
                                               object:nil];
    [self loadBannerDataFromCache];
    [self loadHomeDataFromCache];
    
    // Do any additional setup after loading the view.
    tableHomeView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tableHomeView.backgroundColor = [UIColor whiteColor];//
    tableHomeView.dataSource = self;
    tableHomeView.delegate = self;
    tableHomeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableHomeView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableHomeView];
    
    contentBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    contentBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    contentBanner.clipsToBounds = YES;
    tableHomeView.tableHeaderView = contentBanner;
    
    bannerCarousel = [[iCarousel alloc]initWithFrame:contentBanner.bounds];
    bannerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    bannerCarousel.slideItemWithDelay = YES;
    bannerCarousel.centerItemWhenSelected = YES;
    bannerCarousel.pagingEnabled = YES;
    bannerCarousel.delegate = self;
    bannerCarousel.dataSource = self;
    bannerCarousel.type = iCarouselTypeLinear;
    [contentBanner addSubview:bannerCarousel];
    
    UIView *footerTable = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 15)];
    tableHomeView.tableFooterView = footerTable;
    
    pgCtr = [[DDPageControl alloc]initWithType:DDPageControlTypeOnFullOffFull];
    [pgCtr setCenter: CGPointMake(bannerCarousel.bounds.size.width/2, bannerCarousel.bounds.size.height - 20)] ;
    [pgCtr setTag:12];
    //    pgCtr.delegate = self;
    pgCtr.numberOfPages=_bannerSource!=nil?[_bannerSource count]:0;
    [pgCtr setOnColor:[UIColor colorWithRed:228.0/255.0 green:0.0 blue:28.0/255.0 alpha:1.0]];
    pgCtr.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [bannerCarousel addSubview:pgCtr];
    
    [self getDataForBanner];
    [self getDataHomePage];
    [self setupNavigationBar];
}

-(void)setupNavigationBar
{
    AppDelegate * app = [AppDelegate sharedDelegate];
    [app initNavigationbarWithImage:self];
}
-(void)cart
{
    TestCalendarViewController * calendar = [[TestCalendarViewController alloc]init];
    [self.navigationController pushViewController:calendar animated:YES];
}
-(void)search
{
    SearchViewController * search = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Function

-(void)opendCategry:(NSNumber *)idProduct withTitle:(NSString *)title {
    CategoryViewController *aVC = [[CategoryViewController alloc] initWithProductID:[idProduct intValue] withTitle:title];
    [self.navigationController pushViewController:aVC animated:YES];
}

- (void)opendDetailDeal:(ProductObj *)itemData {
    DetailDealViewController *aVC = [[DetailDealViewController alloc] initWithProduct:itemData];
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - API

-(void)getDataHomePage {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + [AppDelegate sharedDelegate].distanTimeServer;
    NSString *signAPI = [[AppDelegate sharedDelegate] getSignAPI:currentDate withAPIName:kBOGetHomePage];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetHomePage forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    [param setObject:[NSNumber numberWithInt:[locationStored.locationID intValue]] forKey:@"stateId"];
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSArray *dataGet = [[json objectForKey:@"data"] objectForKey:@"listCategory"];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if(self.dataSource) {
                    self.dataSource = nil;
                }
                self.dataSource = [[NSMutableArray alloc]init];
                for(int i = 0; i < [dataGet count];i++) {
                    NSDictionary *item = [dataGet objectAtIndex:i];
                    CategoryHome *category = [[CategoryHome alloc]initWithData:item];
                    [_dataSource addObject:category];
                }
//                self.dataSource = [[NSMutableArray alloc]initWithArray:dataGet copyItems:YES];
                [tableHomeView reloadData];
                [self saveHomeDataFromCache:dataGet];
            });
            
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"error message %s = %@", __PRETTY_FUNCTION__, error.localizedDescription);
    }];
}

- (void)getDataForBanner {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + [AppDelegate sharedDelegate].distanTimeServer;
    NSString *signAPI = [[AppDelegate sharedDelegate] getSignAPI:currentDate withAPIName:kBOGetBannerPage];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetBannerPage forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    [param setObject:@"home" forKey:@"type"];
    [param setObject:[NSNumber numberWithInt:[locationStored.locationID intValue]] forKey:@"stateId"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSArray *dataGet = [[json objectForKey:@"data"] objectForKey:@"listBanner"];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.bannerSource) {
                    self.bannerSource = nil;
                }
                self.bannerSource = [[NSArray alloc]initWithArray:dataGet];
                pgCtr.numberOfPages=_bannerSource!=nil?[_bannerSource count]:0;
                pgCtr.currentPage = 0;
                if(_bannerSource && [_bannerSource count] > 0) {
                    [self saveBannerDataFromCache:dataGet];
                }
                [bannerCarousel reloadData];
            });
            
        }
    } failure:^(NSURLSessionDataTask * task, NSError * error) {
        NSLog(@"error message %s = %@", __PRETTY_FUNCTION__, error.localizedDescription);
    }];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = _dataSource!=nil?(int)[_dataSource count]:0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *cellIdentifier = @"HomePageCell";
    static NSString *cellIdentifier = @"HomePageDealCell";
    
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[HomePageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.rootView = self;
    }
    if(indexPath.row < [_dataSource count]) {
        CategoryHome *itemData = [_dataSource objectAtIndex:indexPath.row];
        [cell setupDataForeCell:itemData];
    }
    
    cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    cell.layer.shouldRasterize = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}

#pragma mark - iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)(_bannerSource==nil?0:[_bannerSource count]);
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    UIImage * imageDefault = [UIImage imageNamed:@"img_thumb.png"];
    
    view = [[ReflectionView alloc]initWithFrame:CGRectMake(0, 0, carousel.bounds.size.width, carousel.bounds.size.height)];//
    
    UIImageView *cover = [[UIImageView alloc]initWithFrame:view.bounds];
    cover.contentMode = UIViewContentModeScaleAspectFill;
    cover.userInteractionEnabled = NO;
    [view addSubview:cover];
    
    NSDictionary *item = [_bannerSource objectAtIndex:index];
    NSString *linkImage = [item objectForKey:@"image"];
    [cover setImageWithURL:[NSURL URLWithString:linkImage] placeholderImage:imageDefault];

//    UILabel *lableIndex = [[UILabel alloc]initWithFrame:carousel.bounds];
//    lableIndex.backgroundColor = [UIColor grayColor];
//    lableIndex.textColor = [UIColor whiteColor];
//    lableIndex.text = [NSString stringWithFormat:@"%d", index];
//    [view addSubview:lableIndex];
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 1;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImage * imageDefault = [UIImage imageNamed:@"img_thumb.png"];
    
    view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];

    ((UIImageView *)view).image = imageDefault;
    
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * bannerCarousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return 1.0f;//value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (bannerCarousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
//    NSDictionary *item = [_bannerSource objectAtIndex:index];
    
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    pgCtr.currentPage = bannerCarousel.currentItemIndex;
}

#pragma mark - Cache DataLoad

- (void)loadHomeDataFromCache {
    NSArray *dataSave;
    NSString *file = [kDocumentDirectory stringByAppendingPathComponent:kHomePageFromCache];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        dataSave = [[NSArray alloc]initWithContentsOfFile:file];
        self.dataSource = [[NSMutableArray alloc]init];
        for(int i = 0; i < [dataSave count];i++) {
            NSDictionary *item = [dataSave objectAtIndex:i];
            CategoryHome *category = [[CategoryHome alloc]initWithData:item];
            [_dataSource addObject:category];
        }
    }
}

- (void)saveHomeDataFromCache:(NSArray *)homeData {
    if (homeData && [homeData count] > 0) {
        if (![homeData writeToFile:[kDocumentDirectory stringByAppendingPathComponent:kHomePageFromCache] atomically:YES]) {
#if DEBUG
            //NSLog(@"%s, cannot save forms to cache",__PRETTY_FUNCTION__);
#endif
        }
    }
}

- (void)loadBannerDataFromCache {
    NSArray *dataSave;
    NSString *file = [kDocumentDirectory stringByAppendingPathComponent:kBannerPageFromCache];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        dataSave = [[NSArray alloc]initWithContentsOfFile:file];
        self.bannerSource = dataSave;
    }
}

- (void)saveBannerDataFromCache:(NSArray *)bannerData {
    if (bannerData && [bannerData count] > 0) {
        if (![bannerData writeToFile:[kDocumentDirectory stringByAppendingPathComponent:kBannerPageFromCache] atomically:YES]) {
#if DEBUG
            //NSLog(@"%s, cannot save forms to cache",__PRETTY_FUNCTION__);
#endif
        }
    }
}
-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
