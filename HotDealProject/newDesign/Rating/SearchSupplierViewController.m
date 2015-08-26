//
//  SearchSupplierViewController.m
//  FelixV1
//
//  Created by MAC on 9/19/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//
/*
#import "VTVHomeViewController.h"
#import "SearchSupplierViewController.h"
#import "MBProgressHUD.h"
#import "WorkWithDatabase.h"
#import "AppDelegate.h"
#import "DLStarRatingControl.h"
#import "SupplierCell.h"
#import "SupplierObject.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "WorkWithServer.h"
#import "SupplierDetailViewController.h"
//#import "SVPullToRefresh.h"
@interface SearchSupplierViewController ()

@end

@implementation SearchSupplierViewController
{
    UIRefreshControl * refreshControl;
    BOOL isNetworkConnected;
    MBProgressHUD *HUD;
    NSString * strKeyWordMain;
    BOOL shouldBeginEditing;
    BOOL isSearching;
    
}
@synthesize tableSuppliers, arrSupplier,searchBars;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)CheckNetworkAlert
{
    [self showTopMessage:LS(@"NoNetworkConnection")];
}

-(void)refreshTable
{
    AppDelegate * appDelegate = ApplicationDelegate;
    isNetworkConnected = [appDelegate CheckNetworkConnection];
    if (!isNetworkConnected) {
        [self CheckNetworkAlert];
        [refreshControl endRefreshing];
        return;
    }
    
    [self loadMore];
    
}


-(void)initUITableView
{
    tableSuppliers = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:tableSuppliers];
    
    tableSuppliers.delegate = self;
    [tableSuppliers setDragDelegate:self refreshDatePermanentKey:@"SupplierList"];
    tableSuppliers.dataSource = self;
    tableSuppliers.backgroundColor = [UIColor whiteColor];
    tableSuppliers.separatorColor = [UIColor clearColor];
    
//    __weak SearchSupplierViewController *weakSelf = self;
//    
//    // setup pull-to-refresh
//    [weakSelf.tableSuppliers addPullToRefreshWithActionHandler:^{
//        [weakSelf loadMore];
//        //        [weakSelf.tableSuppliers.infiniteScrollingView stopAnimating];
//        [weakSelf.tableSuppliers.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
//        [weakSelf.searchBars resignFirstResponder];
//        //        [weakSelf.tableSuppliers performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//    }];
    
    //    [weakSelf.tableSuppliers addInfiniteScrollingWithActionHandler:^{
    //        [weakSelf loadMore];
    //        [weakSelf.tableSuppliers.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    //        [weakSelf.searchBars resignFirstResponder];
    //    } ];
    
    
    
    //    refreshControl = [[UIRefreshControl alloc]init];
    //    refreshControl.tintColor = [UIColor blackColor];
    //    [self.tableSuppliers addSubview:refreshControl];
    //    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}



- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
    BOOL boolToReturn = shouldBeginEditing;
    shouldBeginEditing = YES;
    return boolToReturn;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    if ([searchBar.text isEqualToString:@""]) {
        //Clear stuff here
//        [searchBars becomeFirstResponder];
        UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
        [rBtest addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [rBtest setTitle:LS(@"AcCancel") forState:UIControlStateNormal];
        //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
        [rBtest setFrame:CGRectMake(0, 0, 50, 30)];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
        self.navigationItem.rightBarButtonItem = barItem;
//    }
}

-(void)initSearchBar
{
    searchBars = [[UISearchBar alloc] init];
    searchBars.delegate = self;
    searchBars.placeholder = LS(@"SearchSupplier");
    self.navigationItem.titleView = searchBars;
    UA_log(@"version ios is: %f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    //    [searchBars becomeFirstResponder];
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f) {
    //        // code
    //        for (UIView *view in searchBars.subviews){
    //            for (UIView *ndLeveSubView in view.subviews){
    //
    //                if ([ndLeveSubView isKindOfClass:[UITextField class]])
    //                {
    //
    //                    if ([ndLeveSubView isKindOfClass: [UITextField class]]) {
    //                        UITextField *tf = (UITextField *)ndLeveSubView;
    ////                        tf.clearButtonMode = UITextFieldViewModeNever;
    //                        tf.delegate = self;
    //                        break;
    //                    }
    //                }
    //
    //            }
    //
    //        }
    //    }
}

-(void)backbtn_click:(id)sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    if (isSearching == FALSE) {
        VTVHomeViewController *info = [[VTVHomeViewController alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:info];
        
        SWRevealViewController *revealVC = [self revealViewController];
        [revealVC setFrontViewController:navigationController animated:YES];
    }
    else
    {
        isSearching = FALSE;
        self.tableSuppliers.contentOffset = CGPointMake(0, 0 - self.tableSuppliers.contentInset.top);
        [HUD showAnimated:YES whileExecutingBlock:^{
            NSDictionary * dictResult = [[WorkWithServer shareInstance]setJsonFromData_SEARCH_SUPPLIERS:@"0" size:@"20" wKeyword:@""];
            arrSupplier = [[NSMutableArray alloc]init];
            NSString * status = [dictResult objectForKey:@"status"];
            if ([status isEqualToString:@"success"]) {
                NSArray * arrSuppliers = [dictResult objectForKey:@"suppliers"];
                for (NSDictionary * dictItem in arrSuppliers) {
                    if ([self checkSupplierCode:[dictItem objectForKey:@"code"]]) {
                        SupplierObject * suppObject = [[SupplierObject alloc]init];
                        suppObject.address = [dictItem objectForKey:@"address"];
                        //                 suppObject.bussinessTypeCode = strProduct;
                        suppObject.code = [dictItem objectForKey:@"code"];
                        suppObject.establishDate = [dictItem objectForKey:@"establishDate"];
                        suppObject.fax = [dictItem objectForKey:@"fax"];
                        suppObject.logoUrl = [dictItem objectForKey:@"logoURL"];
                        suppObject.name = [dictItem objectForKey:@"name"];
                        suppObject.strDateSort = [dictItem objectForKey:@"strDateSort"];
                        suppObject.tel = [dictItem objectForKey:@"tel"];
                        suppObject.brandName = [dictItem objectForKey:@"brandName"];
                        suppObject.shortDescriptions = [dictItem objectForKey:@"shortDescription"];
                        suppObject.descriptions = [dictItem objectForKey:@"description"];
                        suppObject.businessForm = [dictItem objectForKey:@"businessForm"];
                        suppObject.rate =[dictItem objectForKey:@"rate"];
                        
                        [arrSupplier addObject:suppObject];
                    }
                }
            }
            
        } completionBlock:^{
            searchBars.text = @"";
            [tableSuppliers reloadData];
        }];
        
    }
}


-(void)initNavigationbar
{
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;
    
    [self initSearchBar];
    //    [self.searchDisplayController setActive:NO animated:YES];
    //    UIImage *image = [UIImage imageNamed:@"search"];
    //    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [rBtest addTarget:self action:@selector(initSearchBar) forControlEvents:UIControlEventTouchUpInside];
    //    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    //    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    //    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    //    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    //    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UA_log(@"......");
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrSupplier = [[NSMutableArray alloc]init];
    AppDelegate * appDelegate = ApplicationDelegate;
    isNetworkConnected = [appDelegate CheckNetworkConnection];

    [self initUITableView];
    [self initHUD];
    [self initNavigationbar];
    [self searchBarSearchButtonClicked:nil];
    isSearching = FALSE;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SupplierCell";
    
    SupplierCell *cell = (SupplierCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SupplierCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    SupplierObject * supplierDetail =[arrSupplier objectAtIndex:indexPath.row];
    cell.lblTitle.text = supplierDetail.name;
    cell.lblDescription.text = supplierDetail.shortDescriptions;
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    backgroundView.layer.borderColor = [[UIColor clearColor]CGColor];
    backgroundView.layer.borderWidth = 10.0f;
    cell.selectedBackgroundView = backgroundView;
    cell.backgroundColor = [UIColor clearColor];
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsPath = [documentsPath stringByAppendingPathComponent:@"PublicFolder"];
    cell.imgLogo.contentMode = UIViewContentModeScaleAspectFit;
    NSString *photourl =F(@"%@%@%@%@", [[WorkWithServer shareInstance] getIP], PORT, URL_IMAGE,supplierDetail.logoUrl);
//    if (isNetworkConnected == TRUE) {
//        [[SDImageCache sharedImageCache] removeImageForKey:photourl fromDisk:YES];
//    }
//    [cell.imgLogo setImageWithURL:[NSURL URLWithString:photourl]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.imgLogo setImageWithURL:[NSURL URLWithString:photourl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            UA_log(@"error: %@", error.description);
            [[SDImageCache sharedImageCache] removeImageForKey:photourl fromDisk:YES];
        }
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    
    cell.imgLogo.layer.borderWidth=1.0f;
    cell.imgLogo.layer.borderColor=[UIColor redColor].CGColor;
    cell.imgLogo.layer.cornerRadius = 10;
    cell.imgLogo.layer.masksToBounds = YES;
    cell.starRating.backgroundColor = [UIColor clearColor];
    cell.starRating.rating =  [supplierDetail.rate floatValue];
    cell.starRating.userInteractionEnabled = NO;
    //        cell.imgLogo.layer.borderWidth=1.5f;
    //        cell.imgLogo.layer.borderColor=[UIColor colorWithHex:@"#afafaf" alpha:1].CGColor;
    //    DLStarRatingControl *customNumberOfStars = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(220, 15, 80, 25) andStars:5 isFractional:YES];
    //    customNumberOfStars.backgroundColor = [UIColor clearColor];
    //
    //    customNumberOfStars.rating = [supplierDetail.rate floatValue];
    //    //        customNumberOfStars.rating = 4.5;
    //    customNumberOfStars.userInteractionEnabled = NO;
    //    [cell.contentView addSubview:customNumberOfStars];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSupplier count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
//    if (([scroll contentOffset].y + scroll.frame.size.height) > [scroll contentSize].height) {
//        if (strKeyWordMain == nil || [strKeyWordMain isEqualToString:@""]) {
//            [self loadMore];
//        }
//        
//    }
}
-(void)loadMore
{
    int64_t delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        int iLenght = [arrSupplier count];
        NSString * sLenght = F(@"%d", iLenght);
        
        NSString * keyword = searchBars.text;
        NSDictionary * dictResult = [[WorkWithServer shareInstance]setJsonFromData_SEARCH_SUPPLIERS:sLenght size:@"10" wKeyword:keyword];
        
        NSString * status = [dictResult objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray * arrSuppliers = [dictResult objectForKey:@"suppliers"];
            for (NSDictionary * dictItem in arrSuppliers) {
                if ([self checkSupplierCode:[dictItem objectForKey:@"code"]]) {
                    SupplierObject * suppObject = [[SupplierObject alloc]init];
                    suppObject.address = [dictItem objectForKey:@"address"];
                    //                suppObject.bussinessTypeCode = strProduct;
                    suppObject.code = [dictItem objectForKey:@"code"];
                    suppObject.establishDate = [dictItem objectForKey:@"establishDate"];
                    suppObject.fax = [dictItem objectForKey:@"fax"];
                    suppObject.logoUrl = [dictItem objectForKey:@"logoURL"];
                    suppObject.name = [dictItem objectForKey:@"name"];
                    suppObject.strDateSort = [dictItem objectForKey:@"strDateSort"];
                    suppObject.tel = [dictItem objectForKey:@"tel"];
                    suppObject.brandName = [dictItem objectForKey:@"brandName"];
                    suppObject.shortDescriptions = [dictItem objectForKey:@"shortDescription"];
                    suppObject.descriptions = [dictItem objectForKey:@"description"];
                    suppObject.businessForm = [dictItem objectForKey:@"businessForm"];
                    suppObject.rate =[dictItem objectForKey:@"rate"];
                    
                    [arrSupplier addObject:suppObject];
                }
            }
        }
        
        
//        [self.tableSuppliers performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    });
}
#pragma mark search handler
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    //if we only try and resignFirstResponder on textField or searchBar,
    //the keyboard will not dissapear (at least not on iPad)!
    
    [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBars afterDelay: 0.1];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(![searchBar isFirstResponder]) {
        // user tapped the 'clear' button
        shouldBeginEditing = NO;
        // do whatever I want to happen when the user clears the search...
    }
    
//    if ([searchText isEqualToString:@""]) {
//        [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:searchBar afterDelay:0];
//    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
    arrSupplier = [[NSMutableArray alloc]init];
        [self searchBarSearchButtonClicked:nil];
    [searchBars resignFirstResponder];
    //    [self.tableSuppliers performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

//- (UISearchBar *)_searchController
//{
//    return searchBars;
//}
//- (BOOL)searchBarShouldFinalizeBecomingFirstResponder
//{
//    return YES;
//}
//- (UISearchBar *)_searchController
//{
//    return searchBars;
//}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //    AppDelegate *appde = ApplicationDelegate;
    //    [appde initNavigationbar:self withTitle:_strTitle];
    self.navigationItem.rightBarButtonItem = nil;
    arrSupplier = [[NSMutableArray alloc]init];
    [searchBar resignFirstResponder];
    [HUD showAnimated:YES whileExecutingBlock:^{
        NSString * keyword = searchBar.text;
        keyword = [keyword normalizeVietnameseString:keyword];
        keyword = [keyword convertPercentage:keyword];
        strKeyWordMain = keyword;
        if (keyword != nil && ![keyword isEqualToString:@""]) {
            isSearching = TRUE;
        }
        NSDictionary * dictResult = [[WorkWithServer shareInstance]setJsonFromData_SEARCH_SUPPLIERS:@"0" size:@"20" wKeyword:keyword];
        
        NSString * status = [dictResult objectForKey:@"status"];
        if ([status isEqualToString:@"success"]) {
            NSArray * arrSuppliers = [dictResult objectForKey:@"suppliers"];
            for (NSDictionary * dictItem in arrSuppliers) {
                if ([self checkSupplierCode:[dictItem objectForKey:@"code"]]) {
                    SupplierObject * suppObject = [[SupplierObject alloc]init];
                    suppObject.address = [dictItem objectForKey:@"address"];
                    //                 suppObject.bussinessTypeCode = strProduct;
                    suppObject.code = [dictItem objectForKey:@"code"];
                    suppObject.establishDate = [dictItem objectForKey:@"establishDate"];
                    suppObject.fax = [dictItem objectForKey:@"fax"];
                    suppObject.logoUrl = [dictItem objectForKey:@"logoURL"];
                    suppObject.name = [dictItem objectForKey:@"name"];
                    suppObject.strDateSort = [dictItem objectForKey:@"strDateSort"];
                    suppObject.tel = [dictItem objectForKey:@"tel"];
                    suppObject.brandName = [dictItem objectForKey:@"brandName"];
                    suppObject.shortDescriptions = [dictItem objectForKey:@"shortDescription"];
                    suppObject.descriptions = [dictItem objectForKey:@"description"];
                    suppObject.businessForm = [dictItem objectForKey:@"businessForm"];
                    suppObject.rate =[dictItem objectForKey:@"rate"];
                    
                    [arrSupplier addObject:suppObject];
                }
            }
        }
        
    } completionBlock:^{
        [tableSuppliers reloadData];
    }];
}

-(BOOL)checkSupplierCode:(NSString*)strSupplierCode
{
    for (SupplierObject * sObject in arrSupplier) {
        if ([strSupplierCode isEqualToString:sObject.code]) {
            return FALSE;
        }
    }
    return TRUE;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int iIndex = indexPath.row;
    SupplierObject* supplierDetail = [arrSupplier objectAtIndex:iIndex];
    
    if (supplierDetail.code == nil) {
        return;
    }
    UA_log(@"strCode : %@", supplierDetail.code);
    SupplierDetailViewController* supplierController = [[SupplierDetailViewController alloc]init];
    supplierController.supplierItem = supplierDetail;
    UA_log(@"%@", supplierDetail.code);
    [self.navigationController pushViewController:supplierController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)finishRefresh
{
    @try {
        [self refreshTable];
        [tableSuppliers finishRefresh];
        [tableSuppliers reloadData];
    }
    @catch (NSException *exception) {
        UA_log(@"%@",exception.description);
    }
    
    
}

- (void)finishLoadMore
{
    @try {
        [self refreshTable];
        [tableSuppliers finishLoadMore];
        [tableSuppliers reloadData];
    }
    @catch (NSException *exception) {
        UA_log(@"%@",exception.description);
    }
}

-(void)dealloc
{
    tableSuppliers = nil;
    arrSupplier = nil;
    searchBars = nil;
}
#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    //send refresh request(generally network request) here
    
    [self performSelector:@selector(finishRefresh) withObject:nil afterDelay:2];
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    //send load more request(generally network request) here
    
    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

@end
*/