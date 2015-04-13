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


@interface LeftMenuViewController ()
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;

@property (nonatomic) APLSectionHeaderView *sectionHeaderView;

// use the uniformRowHeight property if the pinch gesture should change all row heights simultaneously
@property (nonatomic) NSInteger uniformRowHeight;
@end

@implementation LeftMenuViewController
#pragma mark - APLTableViewController

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

#pragma mark -

#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 48
@synthesize arrMenu;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Set up default values.
    [self initData];
    [self initUITableView];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    self.openSectionIndex = NSNotFound;
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

-(void)initUITableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    menuItem.name = @"Menu 1";
    subMenu = [NSArray arrayWithObjects:@"Sub 1 - 1",@"Sub 1 - 2",@"Sub 1 - 3", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Menu 2";
    subMenu = [NSArray arrayWithObjects:@"Sub 2 - 1",@"Sub 2 - 2",@"Sub 2 - 3", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Menu 3";
    subMenu = [NSArray arrayWithObjects:@"Sub 3 - 1",@"Sub 3 - 2",@"Sub 3 - 3", nil];
    menuItem.subItem = subMenu;
    [arrMenu addObject:menuItem];
    
    menuItem = [[MenuItem alloc]init];
    menuItem.name = @"Menu 0";
    //    subMenu = [NSArray arrayWithObjects:@"Sub 3 - 1",@"Sub 3 - 2",@"Sub 3 - 3", nil];
    //    menuItem.subItem = subMenu;
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
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"APLQuoteCell";
    
    APLQuoteCell *cell = (APLQuoteCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"APLQuoteCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    MenuItem *item = (MenuItem *)[(self.sectionInfoArray)[indexPath.section] menuItem];
    //    cell.quotation = (item.subItem)[indexPath.row];
    
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
@end
