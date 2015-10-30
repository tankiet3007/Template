//
//  CategoryFilterViewController.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/28/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "CategoryFilterViewController.h"

@interface CategoryFilterViewController ()

@end

@implementation CategoryFilterViewController
{
    UIButton * btnDone;
    NSMutableArray * listResult;
    NSMutableArray * cellSelected;
}
@synthesize tableviewFilter;
@synthesize filterList;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    cellSelected = [NSMutableArray array];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F5F5F5" alpha:1];
    // Do any additional setup after loading the view.
    listResult = [[NSMutableArray alloc]init];
    filterList = [NSMutableArray arrayWithObjects:@"Tất cả",@"Thời trang trẻ em",@"Thời trang nữ",@"Thời trang nam",@"Quần áo",@"Giày dép",@"Phụ kiện", nil];
    [self initNavigationBar];
    [self initTableViewFilter];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initTableViewFilter
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor blackColor]; // change this color
    label.text = @"Danh mục";
    [self.view addSubview:label];
    tableviewFilter = [[UITableView alloc]initWithFrame:CGRectMake(20, 40, SCREEN_WIDTH -40, SCREEN_HEIGHT - 160) style:UITableViewStylePlain];
    [self.view addSubview:tableviewFilter];
    tableviewFilter.backgroundColor = [UIColor whiteColor];
    tableviewFilter.dataSource = self;
    tableviewFilter.delegate = self;
    tableviewFilter.separatorColor = [UIColor clearColor];
    tableviewFilter.showsVerticalScrollIndicator = NO;
    tableviewFilter.sectionHeaderHeight = 0.0;
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(0, SCREEN_HEIGHT - 110, SCREEN_WIDTH, 50);
    [btnDone setTitle:@"LỌC" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#71be0f" alpha:1]];
    [self.view addSubview:btnDone];
    [btnDone addTarget:self action:@selector(filterDone) forControlEvents:UIControlEventTouchUpInside];
}

-(void)filterDone
{
    [self.delegate updateCategoryWithFilterList:listResult];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationBar
{
    AppDelegate * app = [AppDelegate sharedDelegate];
    [app initNavigationbar:self withTitle:@"Bộ lọc"];
}

-(void)backbtn_click
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filterList count];
//    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([cellSelected containsObject:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, WIDTH(tableviewFilter), 0.5)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor colorWithHex:@"#F5F5F5" alpha:1];// you can also put image here
    [cell.contentView addSubview:separatorLineView];
    
    cell.textLabel.font = kBoldsyStemFonSizeRevert(13);
    cell.textLabel.text = [filterList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if you want only one cell to be selected use a local NSIndexPath property instead of array. and use the code below
    //self.selectedIndexPath = indexPath;
    
    //the below code will allow multiple selection
    if ([cellSelected containsObject:indexPath])
    {
        [cellSelected removeObject:indexPath];
    }
    else
    {
        [cellSelected addObject:indexPath];
    }
    [tableView reloadData];
}
@end
