//
//  CategoryViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "HotNewDetailViewController.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UISegmentedControl *segmentedControl;
    UIButton * btnFilter;
    UILabel * lblNumOfVoucher;
}
@synthesize tableviewCategory;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate * appdelegate = ApplicationDelegate;
    [self setupSegment];
    arrDeals = [[NSMutableArray alloc]init];
    [self initUITableView];
    
    [appdelegate initNavigationbar:self withTitle:@"DANH MỤC"];
    // Do any additional setup after loading the view.
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
    tableviewCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableviewCategory];
    
    
    [tableviewCategory setDragDelegate:self refreshDatePermanentKey:@"CategoryList"];
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
    return [arrDeals count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    return nil;
}
-(UIView *)setupSegment
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    if (segmentedControl != nil) {
        [segmentedControl removeFromSuperview];
        segmentedControl = nil;
    }
    lblNumOfVoucher = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 220, 18)];
    lblNumOfVoucher.text = F(@"Có %lu khuyến mãi", (unsigned long)[arrDeals count]);
    lblNumOfVoucher.textColor = [UIColor blackColor];
    lblNumOfVoucher.font = [UIFont boldSystemFontOfSize:12];
    [viewHeader addSubview:lblNumOfVoucher];
    btnFilter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFilter setFrame:CGRectMake(ScreenWidth -10 -30, 10, 30, 18)];
    [btnFilter addTarget:self action:@selector(showFilterMenu) forControlEvents:UIControlEventTouchUpInside];
    [btnFilter setBackgroundImage:[UIImage imageNamed:@"clickme-1-320x200"] forState:UIControlStateNormal];
    [viewHeader addSubview:btnFilter];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Bán chạy", @"Mới nhất", nil];
    CGRect myFrame = CGRectMake(60, 35, 200, 24);
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return viewHeader;
}
-(void)mySegmentControlAction
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        UA_log(@"0");
    }
    if (segmentedControl.selectedSegmentIndex == 1) {
        UA_log(@"1");
    }
    [tableviewCategory reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        HotNewDetailViewController * detail = [[HotNewDetailViewController alloc]init];
        [self.navigationController pushViewController:detail animated:YES];
    }
}
-(void)showFilterMenu
{
    UA_log(@"ok show filter");
}
#pragma mark - Drag delegate methods

-(void)refreshTable
{
    int64_t delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //            [self getNEWSCampaign:[arrNews count] andSize:10 wKeyword:searchBars.text];
    });
    ALERT(@"OK", @"Refresh");
}

-(void)loadMore
{
    int64_t delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //            [self getNEWSCampaign:[arrNews count] andSize:10 wKeyword:searchBars.text];
    });
    ALERT(@"OK", @"loadMore");
}
- (void)finishLoadMore
{
    @try {
        [self loadMore];
        [tableviewCategory finishLoadMore];
        [tableviewCategory reloadData];
        if (tableviewCategory == nil) {
            return;
        }
        
    }
    @catch (NSException *exception) {
        UA_log(@"%@",exception.description);
    }
    
}

- (void)finishRefresh
{
    @try {
        
        [self refreshTable];
        [tableviewCategory finishRefresh];
        [tableviewCategory reloadData];
        if (tableviewCategory == nil) {
            return;
        }
        
    }
    @catch (NSException *exception) {
        UA_log(@"%@",exception.description);
    }
}


- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:0.5];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:0.5];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}
@end
