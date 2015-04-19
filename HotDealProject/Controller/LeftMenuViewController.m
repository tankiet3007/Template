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
}
#pragma mark - APLTableViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#pragma mark -

#define DEFAULT_ROW_HEIGHT 30
#define HEADER_HEIGHT 48
@synthesize arrMenu;
@synthesize searchBars;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    // Set up default values.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initSearchBar];
    [self initUITableView];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    self.openSectionIndex = NSNotFound;
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

-(void)initUITableView
{
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
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
    NSArray * subMenu;
    arrMenu = [[NSMutableArray alloc]init];
    MenuItem * menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Trang chủ";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 1 - 1",@"Sub 1 - 2",@"Sub 1 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Khuyến mãi mới";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Tài khoản";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Hỗ trợ";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    //    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Thời trang - Phụ kiện";
    subMenu = [NSArray arrayWithObjects:@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Nhà hàng - Ẩm thực";
    subMenu = [NSArray arrayWithObjects:@"Buffet",@"Nhà hàng - Quán ăn",@"Cafe - Kem  - Bánh",@"Thực phẩm",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Sức khoẻ - Làm đẹp";
    subMenu = [NSArray arrayWithObjects:@"Spa - Thẩm mỹ viện",@"Salon - Làm đẹp",@"Nha khoa - Sức khỏe",@"Mỹ phẩm",@"Dụng cụ làm đẹp",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Du lịch - Khách sạn";
    subMenu = [NSArray arrayWithObjects:@"Khách sạn - Resorts",@"Tour trong nước",@"Tour nước ngoài",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Điện tử - Công nghệ";
    subMenu = [NSArray arrayWithObjects:@"Phụ kiện công nghệ",@"Thiết bị điện tử",@"XEM TẤT CẢ", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [arrMenu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numStoriesInSection = [[sectionInfo.menuItem subItem] count];
    
    NSInteger numberOfRows = sectionInfo.open ? numStoriesInSection : 0;
    //    UA_log(@"%ld",numberOfRows);
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ indexpath", indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    APLSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;
    
    sectionHeaderView.titleLabel.text = sectionInfo.menuItem.name;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APLSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}


#pragma mark - SectionHeaderViewDelegate

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
    if (sectionOpened == 0) {
        MainViewController * mainVC = [[MainViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        revealVC = [self revealViewController];
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
        MainViewController * mainVC = [[MainViewController alloc]init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        revealVC = [self revealViewController];
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
    CategoryViewController * categoryVC = [[CategoryViewController alloc]init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:categoryVC];
    
    revealVC = [self revealViewController];
    [revealVC setFrontViewController:navigationController animated:YES];
    [revealVC revealToggle:nil];
    return NO;
}
-(void)initSearchBar
{
    searchBars = [[UISearchBar alloc] init];
    //    searchBars.backgroundColor = [UIColor darkGrayColor];
    [searchBars setFrame:CGRectMake(0, 20, 259, 40)];
    searchBars.placeholder = @"Tìm kiếm                              ";
    [searchBars setBackgroundColor:[UIColor darkGrayColor]];
    [searchBars setBarTintColor:[UIColor darkGrayColor]];
    searchBars.delegate = self;
    [self.view addSubview:searchBars];
}
@end

