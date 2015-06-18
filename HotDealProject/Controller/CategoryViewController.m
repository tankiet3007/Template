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
#import "SWRevealViewController.h"
#import "DealCell.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController
{
    NSMutableArray * arrDeals;
    UIView * viewHeader;
    UISegmentedControl *segmentedControl;
    UIButton * btnFilter;
    UILabel * lblNumOfVoucher;
    SWRevealViewController *revealController;
    UITableView * tableViewFilter;
    NSArray * arrSort;
    BOOL isShowSortMenu;
}
#define RowHeight 44
@synthesize tableviewCategory;
@synthesize strTitle;
@synthesize isFrommenu;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    if (isFrommenu) {
        [self initNavigationbar];
    }
    else
    {
        AppDelegate * appdelegate = ApplicationDelegate;
        [appdelegate initNavigationbar:self withTitle:strTitle];
    }
    [self setupSegment];
    isShowSortMenu = YES;
    arrDeals = [[NSMutableArray alloc]init];
    [self initDataSort];
//    [self initData];
    [self initUITableView];
    [self initTableViewForSort];
//    [self initNavigationbar];
//    [appdelegate initNavigationbar:self withTitle:@"DANH MỤC"];
    // Do any additional setup after loading the view.
}

-(void)initDataSort
{
    arrSort = [NSArray arrayWithObjects:@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nữ",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang",@"Thời trang nam",@"Thời trang trẻ em",@"Phụ kiện thời trang", nil];
}
-(void)initTableViewForSort
{
    long estimateTableHeight = [arrSort count] * RowHeight;
    if (estimateTableHeight > ScreenHeight - 120) {
        estimateTableHeight = ScreenHeight - 120;
    }
    tableViewFilter = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 40, ScreenWidth/2, estimateTableHeight)];

    [self.view addSubview:tableViewFilter];
//    [tableViewFilter setBounces:NO];
    tableViewFilter.layer.borderWidth = 1;
    tableViewFilter.layer.borderColor=[UIColor blackColor].CGColor;
    tableViewFilter.layer.shadowColor = [UIColor purpleColor].CGColor;
    tableViewFilter.layer.shadowOffset = CGSizeMake(0, 1);
    tableViewFilter.layer.shadowOpacity = 1;
    tableViewFilter.layer.shadowRadius = 1.0;
    tableViewFilter.clipsToBounds = YES;
    tableViewFilter.backgroundColor = [UIColor whiteColor];
    tableViewFilter.dataSource = self;
    tableViewFilter.delegate = self;
    [tableViewFilter setAllowsSelection:YES];
//    tableViewFilter.separatorColor = [UIColor clearColor];
    tableViewFilter.showsVerticalScrollIndicator = NO;
    tableViewFilter.sectionHeaderHeight = 0.0;
    tableViewFilter.hidden = YES;
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
//    label.text = NSLocalizedString(@"DANH MỤC", @"");
    label.text = strTitle;
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
    tableviewCategory = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-44) style:UITableViewStyleGrouped];
    [self.view addSubview:tableviewCategory];

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
    if ([tableView isEqual:tableViewFilter]) {
        return [arrSort count];
    }
    else
        return [arrDeals count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewFilter]) {
        return 44;
    }
    else
        return 350;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tableViewFilter]) {
        static NSString *CellIdentifier = @"CellIdentifier";
        
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString * strTitles = [arrSort objectAtIndex:indexPath.row];
        cell.textLabel.text = strTitles;
        cell.textLabel.font = [UIFont systemFontOfSize:11];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;

    }
    else
    {
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
    return cell;
    }

}

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
//
//}

-(UIView *)setupSegment
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
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
    [btnFilter setFrame:CGRectMake(ScreenWidth -60, 10, 50, 30)];
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
    if ([tableView isEqual:tableViewFilter]) {
        return 0;
    }
    return 70.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:tableViewFilter]) {
        return nil;
    }
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
    
    if ([tableView isEqual:tableViewFilter]) {
        tableViewFilter.hidden = YES;
        isShowSortMenu = YES;
        tableviewCategory.userInteractionEnabled = YES;
    }
}
-(void)showFilterMenu
{
//    if (isShowSortMenu == NO) {
//        tableviewCategory.userInteractionEnabled = NO;
//    }
//    else
//    {
//        tableviewCategory.userInteractionEnabled = YES;
//    }
    isShowSortMenu = !isShowSortMenu;
    tableViewFilter.hidden = isShowSortMenu;
    
}
@end
