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
}
@synthesize tableViewMain;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self checkNetwork];
    [self initUITableView];
    [self initNavigationbar];
    [self initData];
    [self setupSlide];
    [self setupNewDeal];
    [self setupCategory];
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
    arrNewDeals = [[NSMutableArray alloc]init];
    arrNewDeals = [NSMutableArray arrayWithObjects:@"Deal 1",@"Deal 2",@"Deal 3",@"Deal 4",@"Deal 5",@"Deal 6",@"Deal 7",@"Deal 8",@"Deal 9",@"Deal 10",@"Deal 11",@"Deal 12", nil];
}
-(void)clickOnItem:(id)sender
{
    UIButton * btnTag = (UIButton *)sender;
    UA_log(@"button is at %ld index", (long)btnTag.tag);
}
-(void)clickOnCategory:(id)sender
{
    UIButton * btnTag = (UIButton *)sender;
    UA_log(@"button is at %ld index", (long)btnTag.tag);
    
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
    for (int i = 0; i < [arrNewDeals count]; i++) {
        DealItem *itemS = [[[NSBundle mainBundle] loadNibNamed:@"DealItem" owner:self options:nil] objectAtIndex:0];
        [itemS setFrame:CGRectMake(x, 0, 250, 180)];
        [itemS.btnTemp addTarget:self action:@selector(clickOnItem:) forControlEvents:UIControlEventTouchUpInside];
        itemS.btnTemp.tag = i;
        itemS.backgroundColor = [UIColor greenColor];
        itemS.lblBooks.text = @"Something like this";
        itemS.lblName.text = [arrNewDeals objectAtIndex:i];
        x += itemS.frame.size.width + PADDING;
        [scrollView addSubview:itemS];
    }
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    return scrollView;
}
-(void)initUITableView
{
    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableViewMain];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewMain.backgroundColor = [UIColor whiteColor];
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    [tableViewMain setAllowsSelection:YES];
    tableViewMain.separatorColor = [UIColor clearColor];
    tableViewMain.showsVerticalScrollIndicator = NO;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 10;
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
    return 110;
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
        [cell.contentView addSubview:imageSlideTop];
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 15, 300, 20)];
        NSDate * date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM"];
        NSString * strToday = [formatter stringFromDate:date];
        
        NSLog(@"%@", strToday);
        lblTitle.text = F(@"Deal mới nhất ngày %@",strToday);
        lblTitle.font = [UIFont boldSystemFontOfSize:14];
        lblTitle.textColor = [UIColor redColor];
        [cell.contentView addSubview:lblTitle];
        [cell.contentView addSubview:scrollView];
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
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
        UILabel * lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(PADDING, 5, 300, 20)];
        lblTitle.text = @"Chọn danh mục";
        
        return cell;
    }
    
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    float width = tableView.bounds.size.width;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
//    view.backgroundColor = [UIColor colorWithHex:@"#afafaf" alpha:1];
//    view.userInteractionEnabled = YES;
//    view.tag = section;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 35)];
//    label.text = @"LỊCH PHÁT SÓNG";
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor redColor];
//    label.shadowColor = [UIColor darkGrayColor];
//    label.shadowOffset = CGSizeMake(0,1);
//    label.font = [UIFont boldSystemFontOfSize:25];
//    label.textAlignment =NSTextAlignmentCenter;
//    [view addSubview:label];
//
//    return view;
//
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSMutableIndexSet *indetsetToUpdate = [[NSMutableIndexSet alloc]init];
    //
    //    [indetsetToUpdate addIndex:1];
    //    [tableViewMain reloadSections:indetsetToUpdate withRowAnimation:UITableViewRowAnimationFade];
}
-(void)topCellClick:(long)index
{
    NSLog(@"delegate %ld",index);
}
@end
