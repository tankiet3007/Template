//
//  LeftMenuViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "APLQuoteCell.h"
#import "APLSectionInfo.h"
#import "APLSectionHeaderView.h"
#import "MenuItem.h"
#import "CategoryViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
#import "NewDealViewController.h"
#import "StartupViewController.h"
#import "AccoutViewController.h"
#import "HelpViewController.h"
#import "RegisAndLoginController.h"
@interface LeftMenuViewController ()
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;

@property (nonatomic) APLSectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;
@end

@implementation LeftMenuViewController
{
    SWRevealViewController *revealVC;
    UIButton * btnLogin;
    UITableView * autocompleteTableView;
    NSMutableArray * autocompleteItem;
    NSMutableArray * rootData;
}
#pragma mark - APLTableViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#pragma mark -

#define DEFAULT_ROW_HEIGHT 40
#define HEADER_HEIGHT 48
@synthesize arrMenu;
@synthesize searchBars;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    revealVC = [self revealViewController];
    // Set up default values.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self setupLoginBtn];
    [self initSearchBar];
    [self initUITableView];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    self.openSectionIndex = NSNotFound;
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [self initDataSearch];
    [self initSearchTable];
}

-(void)initUITableView
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    //    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = HEADER_HEIGHT;
}

-(void)initData
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"indexSelected"];
    NSInteger iIndexLocation = -1;
    if (savedValue != nil) {
        iIndexLocation = [savedValue integerValue];
    }
    NSArray * arrLocation = [NSArray arrayWithObjects:@"Hà Nội",@"Hồ Chí Minh",@"Bình Dương",@"Đà Nẵng",@"Tỉnh thành khác", nil];
    NSString * location = [arrLocation objectAtIndex:iIndexLocation];
    
    NSArray * subMenu;
    arrMenu = [[NSMutableArray alloc]init];
    MenuItem * menuItem = [[MenuItem alloc]init];
    menuItem.name = F(@"Địa điểm : %@", location);
    menuItem.logo = @"map_pin_fill-512";
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Trang chủ";
    menuItem.logo = @"leftmenu_1";
    
    //    subMenu = [NSArray arrayWithObjects:@"Sub 1 - 1",@"Sub 1 - 2",@"Sub 1 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Khuyến mãi mới";
    menuItem.logo = @"leftmenu_2";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Thời trang - Phụ kiện";
    menuItem.logo = @"leftmenu_3";
    subMenu = [NSArray arrayWithObjects:@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Nhà hàng - Ẩm thực";
    menuItem.logo = @"leftmenu_4";
    subMenu = [NSArray arrayWithObjects:@"Buffet",@"Nhà hàng - Quán ăn",@"Cafe - Kem  - Bánh",@"Thực phẩm",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Sức khoẻ - Làm đẹp";
    menuItem.logo = @"leftmenu_5";
    subMenu = [NSArray arrayWithObjects:@"Spa - Thẩm mỹ viện",@"Salon - Làm đẹp",@"Nha khoa - Sức khỏe",@"Mỹ phẩm",@"Dụng cụ làm đẹp",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Du lịch - Khách sạn";
    menuItem.logo = @"leftmenu_6";
    subMenu = [NSArray arrayWithObjects:@"Khách sạn - Resorts",@"Tour trong nước",@"Tour nước ngoài",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Điện tử - Công nghệ";
    menuItem.logo = @"leftmenu_7";
    subMenu = [NSArray arrayWithObjects:@"Phụ kiện công nghệ",@"Thiết bị điện tử",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Giải trí - Đào tạo";
    menuItem.logo = @"leftmenu_8";
    subMenu = [NSArray arrayWithObjects:@"Giải trí - Vui chơi",@"Đào tạo",@"Thể dục thẩm mỹ",@"Sách - Tạp chí", @"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Gia dụng - Nội thất";
    menuItem.logo = @"leftmenu_9";
    subMenu = [NSArray arrayWithObjects:@"Nhà cửa - Đời sống",@"Thiết bị điện tử",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Tài khoản";
    menuItem.logo = @"leftmenu_10";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Hỗ trợ";
    menuItem.logo = @"leftmenu_11";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    
    self.sectionInfoArray = nil;
    if ((self.sectionInfoArray == nil) ||
        ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView])) {
        
        // For each play, set up a corresponding SectionInfo object to contain the default height for each row.
        NSMutableArray *infoArray = [[NSMutableArray alloc] init];
        
        for (MenuItem *item in arrMenu) {
            
            APLSectionInfo *sectionInfo = [[APLSectionInfo alloc] init];
            sectionInfo.menuItem = item;
            sectionInfo.open = NO;
            
            NSNumber *defaultRowHeight = @(DEFAULT_ROW_HEIGHT);
            NSInteger countOfSubItem = [[sectionInfo.menuItem subItem] count];
            for (NSInteger i = 0; i < countOfSubItem; i++) {
                [sectionInfo insertObject:defaultRowHeight inRowHeightsAtIndex:i];
            }
            
            [infoArray addObject:sectionInfo];
        }
        
        self.sectionInfoArray = infoArray;
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_tableView]) {
        return [arrMenu count] + 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_tableView]) {
        if ([arrMenu count] == section) {
            return 0;
        }
        APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
        NSInteger numStoriesInSection = [[sectionInfo.menuItem subItem] count];
        
        NSInteger numberOfRows = sectionInfo.open ? numStoriesInSection : 0;
        //    UA_log(@"%ld",numberOfRows);
        return numberOfRows;
    }
    return autocompleteItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        static NSString *simpleTableIdentifier = @"APLQuoteCell";
        
        APLQuoteCell *cell = (APLQuoteCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        [cell setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"APLQuoteCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        MenuItem *item = (MenuItem *)[(self.sectionInfoArray)[indexPath.section] menuItem];
        UA_log(@"%@",(item.subItem)[indexPath.row]);
        cell.lblSubMenu.text = (item.subItem)[indexPath.row];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = nil;
        static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        }
        
        cell.textLabel.text = [autocompleteItem objectAtIndex:indexPath.row];
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@ indexpath", indexPath);
    if ([tableView isEqual:_tableView]) {
        CategoryViewController * categoryVC = [[CategoryViewController alloc]init];
        MenuItem *item = (MenuItem *)[(self.sectionInfoArray)[indexPath.section] menuItem];
        UA_log(@"%@",(item.subItem)[indexPath.row]);
        categoryVC.strTitle = (item.subItem)[indexPath.row];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:categoryVC];
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
    }
    else
    {
        SearchViewController *searchVC = [SearchViewController alloc];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
        searchVC.searchText = [autocompleteItem objectAtIndex:indexPath.row];
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_tableView]) {
        if (section == [arrMenu count]) {
            //        return btnLogin;
            UIView * viewFooter = [[UIView alloc]initWithFrame:btnLogin.frame];
            [viewFooter addSubview:btnLogin];
            return viewFooter;
        }
        APLSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        
        APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
        sectionInfo.headerView = sectionHeaderView;
        sectionHeaderView.imgSectionLogo.image = [UIImage imageNamed:sectionInfo.menuItem.logo];
        sectionHeaderView.titleLabel.text = sectionInfo.menuItem.name;
        sectionHeaderView.section = section;
        sectionHeaderView.delegate = self;
        if (section == 2) {
            UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth - 40, 5)];
            imgLine.image = [UIImage imageNamed:@"gach"];
            
            [sectionHeaderView addSubview:imgLine];
        }
        if (section == 9) {
            UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth - 40, 5)];
            imgLine.image = [UIImage imageNamed:@"gach"];
            
            [sectionHeaderView addSubview:imgLine];
        }
        return sectionHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_tableView]) {
        if (indexPath.section == [arrMenu count]) {
            return 0;
        }
        APLSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
        return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
        // Alternatively, return rowHeight.
        
    }
    else
    {
        return 44;
    }
}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    if (sectionOpened == 0) {
        StartupViewController * mainVC = [[StartupViewController alloc]init];
        mainVC.isFromLeftMenu = TRUE;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationUpdateLocation:) name:@"notificationUpdateLocation"
                                                   object:nil];
        
        return;
    }
    
    if (sectionOpened == 1) {
        MainViewController * mainVC = [[MainViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    if (sectionOpened == 2) {
        NewDealViewController * newVC = [[NewDealViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    if (sectionOpened == 10) {//#import "RegisAndLoginController.h"
        AccoutViewController * newVC = [[AccoutViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }//#import "HelpViewController.h"
    if (sectionOpened == 11) {//#import "RegisAndLoginController.h"
        HelpViewController * newVC = [[HelpViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
    sectionInfo.open = YES;
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [sectionInfo.menuItem.subItem count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
        APLSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.menuItem.subItem count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
    
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    if (sectionClosed == 0) {
        StartupViewController * startVC = [[StartupViewController alloc]init];
        startVC.isFromLeftMenu = TRUE;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationUpdateLocation:) name:@"notificationUpdateLocation"
                                                   object:nil];
        
        return;
    }
    if (sectionClosed == 1) {
        MainViewController * mainVC = [[MainViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    if (sectionClosed == 2) {
        NewDealViewController * newVC = [[NewDealViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    if (sectionClosed == 10) {//AccoutViewController
        AccoutViewController * newVC = [[AccoutViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    if (sectionClosed == 11) {//#import "RegisAndLoginController.h"
        HelpViewController * newVC = [[HelpViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
        
        [revealVC setFrontViewController:navigationController animated:YES];
        [revealVC revealToggle:nil];
        return;
    }
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"SEARCH BAR TEXT DID END EDITING");
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //    SearchViewController *searchVC = [SearchViewController alloc];
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    //    [revealVC setFrontViewController:navigationController animated:YES];
    //    [revealVC revealToggle:nil];
    [searchBars setFrame:CGRectMake(0, 0, ScreenWidth - 40, 40)];
    self.revealViewController.rearViewRevealWidth = 320;
    [self.revealViewController setFrontViewPosition: FrontViewPositionRightMost animated: YES];
    _tableView.hidden = YES;
    searchBar.showsCancelButton = YES;
    
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:searchBar.text];
    //    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    _tableView.hidden = NO;
    
    autocompleteTableView.hidden = YES;
    [searchBars setFrame:CGRectMake(0, 0, 245, 40)];
    searchBar.showsCancelButton = NO;
    self.revealViewController.rearViewRevealWidth = 260;
    [self.revealViewController setFrontViewPosition: FrontViewPositionRight animated: YES];
    [searchBars resignFirstResponder];
}

-(void)initDataSearch
{
    rootData = [[NSMutableArray alloc] initWithObjects:@"www.google.com",@"www.zing.vn", @"Tran Tan Kiet",@"Mai Thi Le Quyen", nil];
    autocompleteItem = [[NSMutableArray alloc] init];
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteItem removeAllObjects];
    for(NSString *curString in rootData) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteItem addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
}

-(void)initSearchTable
{
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
}
-(void)initSearchBar
{
    searchBars = [[UISearchBar alloc] init];
    //    searchBars.backgroundColor = [UIColor darkGrayColor];
    [searchBars setFrame:CGRectMake(0, 0, 245, 40)];
    searchBars.placeholder = @"Tìm kiếm";
    searchBars.tintColor = [UIColor colorWithHex:@"#EFEFEF" alpha:1];
    //    [searchBars setBackgroundColor:[UIColor darkGrayColor]];
    [searchBars setBarTintColor:[UIColor darkGrayColor]];
    searchBars.delegate = self;
    [searchBars setValue:@"Hủy" forKey:@"_cancelButtonText"];
    [searchBars setBackgroundImage:[UIImage new]];
    [searchBars setTranslucent:YES];
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:searchBars];
    self.navigationItem.titleView = searchBarView;
    //    [self.view addSubview:searchBars];
}
- (void)notificationUpdateLocation:(NSNotification *)notification {
    [self initData];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationUpdateLocation" object:nil];
}
-(UIButton *)setupLoginBtn
{
    btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(10, -5, 240, 40)];
    [btnLogin setBackgroundColor:[UIColor greenColor]];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitle:@"ĐĂNG NHẬP" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    return btnLogin;
}
-(void)loginClick
{
    RegisAndLoginController * newVC = [[RegisAndLoginController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
    
    [revealVC setFrontViewController:navigationController animated:YES];
    [revealVC revealToggle:nil];
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * viewFooter = [[UIView alloc]initWithFrame:btnLogin.frame];
//    [viewFooter addSubview:btnLogin];
//    return viewFooter;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == [arrMenu count]-1) {
//        return 40;
//    }
//    return 0;
//}
@end

