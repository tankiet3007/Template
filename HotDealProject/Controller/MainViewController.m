//
//  MainViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "DealItem.h"
#import "HotNewDetailViewController.h"
#import "CategoryViewController.h"
#import "PromotionViewController.h"
#import "DealCell.h"
#import "DealObject.h"
#import "SVPullToRefresh.h"
#define HEADER_HEIGHT 156
#define PADDING 10
@interface MainViewController ()

@end

@implementation MainViewController
{
    SWRevealViewController *revealController;
    Reachability * reachability;
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
}
@synthesize tableViewMain;
#pragma mark init Method
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self checkNetwork];
    [self initUITableView];
    [self initNavigationbar];
    [self initData];
    [self setupSlide];
    [self setupNewDeal];
    [self setupCategory];
    [self setupSegment];
    // Do any additional setup after loading the view from its nib.
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
    imageSlideTop = [[ImageSlide alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, HEADER_HEIGHT)];
    NSMutableArray * galleryImages = [NSMutableArray arrayWithObjects:@"clickme-1-320x200",@"clickme-1-320x200", nil];
    imageSlideTop.galleryImages = galleryImages;
    imageSlideTop.delegate = self;
    [imageSlideTop initScrollLocal2];
}
-(void)initData
{
    arrDeals = [[NSMutableArray alloc]init];
    arrNewDeals = [NSMutableArray arrayWithObjects:@"Deal 1",@"Deal 2",@"Deal 3",@"Deal 4",@"Deal 5",@"Deal 6",@"Deal 7",@"Deal 8",@"Deal 9",@"Deal 10",@"Deal 11",@"Deal 12", nil];
    
    arrSale = [NSMutableArray arrayWithObjects:@"Sale 1",@"Sale 2",@"Sale 3",@"Sale 4",@"Sale 5",@"Sale 6",@"Sale 7",@"Sale 8",@"Sale 9",@"Sale 10", nil];
    
     arrNew = [NSMutableArray arrayWithObjects:@"New 1",@"New 2",@"New 3",@"New 4",@"New 5",@"New 6",@"New 7",@"New 8",@"New 9",@"New 10", nil];
    
     arrNear = [NSMutableArray arrayWithObjects:@"Near 1",@"Near 2",@"Near 3",@"Near 4",@"Near 5",@"Near 6",@"Near 7",@"Near 8",@"Near 9",@"Near 10", nil];
    DealObject * item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.iCount = 123;
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.strDescription = @"Combo 20 viên rau câu phô mai Pháp tại Petits Choux à le Crème An An hương vị ngọt mát, beo béo thơm vị dâu, vanilla cho cả nhà giải nhiệt mùa hè. Chỉ 30.000đ cho trị giá 60.000đ";
    item.iCount = 456;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 789;
    item.strDescription = @"Đầm xòe Zara họa tiết chấm bi xuất khẩu - Thiết kế thời trang với phần phối màu xen kẽ họa tiết chấm bi đẹp mắt giúp thể hiện nét đẹp thanh lịch, sành điệu của bạn gái. Chỉ 199.000đ cho trị giá 398.000đ Chỉ 199.000đ cho trị giá 398.000đ";
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.strDescription = @"Bộ miếng dán iPhone mạ vàng và ốp lưng silicon có thiết kế vừa vặn với khung máy sẽ giúp mang đến cho dế yêu của bạn một vẻ đẹp hoàn hảo và đẳng cấp. Chỉ 85.000đ cho trị giá 160.000đ";
    item.iCount = 111;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.iCount = 222;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 333;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.iCount = 121;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.iCount = 212;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrDeals addObject:item];
    
    item = [[DealObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCount = 999;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrDeals addObject:item];
}


-(UIScrollView *)setupCategory
{
    if (scrollViewCategory != nil) {
        [scrollViewCategory removeFromSuperview];
        scrollViewCategory = nil;
    }
    scrollViewCategory = [[UIScrollView alloc]initWithFrame:CGRectMake(PADDING, 30, 320, 80)];
    scrollViewCategory.showsHorizontalScrollIndicator = NO;
    scrollViewCategory.backgroundColor = [UIColor clearColor];
    //    [scrollView setBounces:NO];
    
    int x = 0;
    for (int i = 0; i < 10; i++) {
        UIButton * btnCategory = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnCategory setFrame:CGRectMake(x, 0, 130, 70)];
        [btnCategory setBackgroundImage:[UIImage imageNamed:@"clickme-1-320x200"] forState:UIControlStateNormal];
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
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(PADDING, 40, 320, 180)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    //    [scrollView setBounces:NO];
    
    int x = 0;
    for (int i = 0; i < [arrDeals count]; i++) {
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
        itemS.lblNumOfBook.text = F(@"%d",item.iCount);
        
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        itemS.lblDiscountPrice.text = strDiscountPrice;
        itemS.lblTitle.text = item.strTitle;

        
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

-(void)checkNetwork
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:kReachabilityChangedNotification object:nil];
    
    reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
}
- (void)networkChanged:(NSNotification *)notification
{
    
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        NSLog(@"not reachable");
    }
    else if (remoteHostStatus == ReachableViaWiFi) { NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) { NSLog(@"carrier"); }
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
    label.text = NSLocalizedString(@"Home", @"");
    [label sizeToFit];
    
    revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    //    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    //    tap.delegate = self;
    //
    //    [self.view addGestureRecognizer:tap];
    //    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIImage *image = [UIImage imageNamed:@"menu_n.png"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
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
        return HEADER_HEIGHT;
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
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 15, 300, 20)];
        NSDate * date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM"];
        NSString * strToday = [formatter stringFromDate:date];
        
        NSLog(@"%@ ,%@", strToday ,[date stringWeekday]);
        lblTitle.text = F(@"Deal mới nhất %@ ngày %@",[date stringWeekday],strToday);
        lblTitle.font = [UIFont boldSystemFontOfSize:14];
        lblTitle.textColor = [UIColor redColor];
        [cell.contentView addSubview:lblTitle];
        [cell.contentView addSubview:scrollView];
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 5, 300, 20)];
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
        NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
        strStardarPrice = [strStardarPrice formatStringToDecimal];
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblStandarPrice.attributedText = attributedString;
        [cell.lblStandarPrice sizeToFit];
        cell.lblNumOfBook.text = F(@"%d",item.iCount);
        
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        cell.lblDiscountPrice.text = strDiscountPrice;
        cell.lblTitle.text = item.strTitle;
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
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 29)];
    if (segmentedControl != nil) {
        [segmentedControl removeFromSuperview];
        segmentedControl = nil;
    }
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bán chạy", @"Mới nhất", @"Gần nhất", nil];
    CGRect myFrame = CGRectMake(10.0f, 0, 300.0f, 29);
    
    //create an intialize our segmented control
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    //set the size and placement
    segmentedControl.frame = myFrame;
    segmentedControl.tintColor = [UIColor darkGrayColor];
    [segmentedControl addTarget:self action:@selector(mySegmentControlAction) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    [viewHeader addSubview:segmentedControl];
    return viewHeader;

}

-(void)mySegmentControlAction
{
        NSMutableIndexSet *indetsetToUpdate = [[NSMutableIndexSet alloc]init];
    
        [indetsetToUpdate addIndex:4];
        [tableViewMain reloadSections:indetsetToUpdate withRowAnimation:UITableViewRowAnimationFade];
    if (segmentedControl.selectedSegmentIndex == 0) {
        UA_log(@"0");
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        UA_log(@"1");
    }
    if (segmentedControl.selectedSegmentIndex == 2) {
        UA_log(@"2");
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
        DealObject * dealObj = [arrDeals objectAtIndex:indexPath.row];
        detail.dealObj = dealObj;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

#pragma mark - Drag delegate methods

-(void)refreshTable
{
    int64_t delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
    UIButton * btnTag = (UIButton *)sender;
    UA_log(@"button is at %ld index", (long)btnTag.tag);
    
    CategoryViewController * category = [[CategoryViewController alloc]init];
    [self.navigationController pushViewController:category animated:YES];
}

-(void)clickOnItem:(id)sender
{
    UIButton * btnTag = (UIButton *)sender;
    UA_log(@"button is at %ld index", (long)btnTag.tag);
    HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
    DealObject * dealObj = [arrDeals objectAtIndex:(long)btnTag.tag];
    detail.dealObj = dealObj;
    [self.navigationController pushViewController:detail animated:YES];
}

/*UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];//reused
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 if (segmentedControl.selectedSegmentIndex == 0) {
 cell.textLabel.text = [arrSale objectAtIndex:indexPath.row];
 if (indexPath.row == [arrSale count] - 1)
 {
 ALERT(@"OK", @"Cancel");
 }
 }
 if (segmentedControl.selectedSegmentIndex == 1) {
 if (indexPath.row == [arrNew count] - 1)
 {
 ALERT(@"OK", @"Cancel");
 }
 cell.textLabel.text = [arrNew objectAtIndex:indexPath.row];
 }
 if (segmentedControl.selectedSegmentIndex == 2) {
 if (indexPath.row == [arrNear count] - 1)
 {
 ALERT(@"OK", @"Cancel");
 }
 cell.textLabel.text = [arrNear objectAtIndex:indexPath.row];
 }
*/
@end
