//
//  LeftMenuViewController.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/26/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "AppDelegate.h"
#import "CategoryObj.h"
#import "CategoryFilterViewController.h"
#import "HomePageViewController.h"
#import "CategoryViewController.h"
#import "LocationPageViewController.h"
@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController
{
    NSMutableArray * listCat;
    id lastItem;
    SWRevealViewController *revealVC;
    LocationObj * locationStored;
}
@synthesize listCategory;
-(void)updateLocation
{
    locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    [_treeView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    NotifReg(self, @selector(updateLocation), @"updateLocation");
    
    revealVC = [self revealViewController];
    listCategory = [self getListCategory];
    listCat = [NSMutableArray new];
    listCat = [CategoryObj parseCategoryToArrayObj:listCategory];
    if ([listCategory count] == 0 ) {
        NotifReg(self, @selector(reloadData), @"reloadCategory");
    }
    [self initView];//NotifPost(@"collapse");
}
-(void)reloadData
{
    listCategory = [self getListCategory];
    listCat = [NSMutableArray new];
    listCat = [CategoryObj parseCategoryToArrayObj:listCategory];
    [self initView];
}
-(NSArray *)getListCategory {
    AppDelegate * app = [AppDelegate sharedDelegate];
    return  [app getListCat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)collapse
//{
//    [_treeView collapseRowForItem:lastItem];
//    NotifUnreg(self, @"collapseItem");
//    lastItem = nil;
//
//}
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    RADataObject *account = [RADataObject dataObjectWithName:@"Account" children:nil cateID:1 imgURL:nil];
    RADataObject *home = [RADataObject dataObjectWithName:@"Trang chủ" children:nil cateID:0 imgURL:@"home"];
    
    RADataObject *info = [RADataObject dataObjectWithName:@"Info" children:nil cateID:2 imgURL:nil];
    NSMutableArray * cateList = [NSMutableArray new];
    for (CategoryObj * item in listCat) {
        NSMutableArray * subList = [NSMutableArray new];
        NSArray * listSubRaw = item.listSubCategory;
        for (CategoryObj * subItem in listSubRaw) {
            RADataObject *subObject = [RADataObject dataObjectWithName:subItem.name children:nil cateID:subItem.categoryId imgURL:subItem.path];
            [subList addObject:subObject];
        }
        RADataObject * cateMain = [RADataObject dataObjectWithName:item.name
                                                          children:subList cateID: item.categoryId imgURL:item.path];
        [cateList addObject:cateMain];
    }
    
    NSMutableArray * cateListAndOption = [NSMutableArray new];
    [cateListAndOption addObject:account];
    [cateListAndOption addObject:home];
    for (RADataObject * item in cateList) {
        [cateListAndOption addObject:item];
    }
    [cateListAndOption addObject:info];
    self.data = [NSArray arrayWithArray:cateListAndOption];
    self.treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 10, 275, HEIGHT(self.view)-20)];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    self.treeView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.treeView];
    [self.treeView reloadData];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([[((RADataObject *)item) name] isEqualToString:@"Account"]) {
        return 210;
    }
    if ([[((RADataObject *)item) name] isEqualToString:@"Info"]) {
        return 50;
    }
    return 50;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo wCell:(UITableViewCell*)cell
{
//    RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
//    cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"ic_expan_down1"];
    return YES;
}
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo wCell:(UITableViewCell*)cell
{
    //    RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
    //    cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"spa"];
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xE8E9EB);
        //        cell.backgroundColor = [UIColor lightGrayColor];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}
-(void)closeLeftMenu
{
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    if (sideMenuController) {
        [sideMenuController closeMenu];
    }
}
#pragma mark TreeView Data Source w
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo atIndexPath:(NSIndexPath *)indexPath//wCell:(UITableViewCell *)cell
{
    if(self.tableTreeView == nil) {
        NSArray *arraySubView = [treeView subviews];
        for(id view in arraySubView) {
            if([view isKindOfClass:[UITableView class]]) {
                self.tableTreeView = view;
                break;
            }
        }
    }
    
    RACellTableViewCell* cellAtIndex = [self.tableTreeView cellForRowAtIndexPath:indexPath];
    if (cellAtIndex.selectionStyle == UITableViewCellSelectionStyleNone) {
        return;
    }
    
    if (lastItem != nil && lastItem != item && [[((RADataObject *)item) children] count] != 0) {
        [treeView collapseRowForItem:lastItem];
        UA_log(@"%@", [((RADataObject *)lastItem) name]);
        if(self.indexPathSelected) {
            RACellTableViewCell* cellSelected = [self.tableTreeView cellForRowAtIndexPath:_indexPathSelected];
            if(cellSelected) {
                UIImageView * imageV = [[UIImageView alloc]initWithFrame:cellSelected.imgExpanse.frame];
                [cellSelected.imgExpanse removeFromSuperview];
                cellSelected.imgExpanse = nil;
//                imageV.image = [UIImage imageNamed:@"ic_expan_gray"];
//                [cellSelected.contentView addSubview:imageV];
//                imageV.tag = 1001;
//                cellSelected.imgExpanse.image = [UIImage imageNamed:@"ic_expan_down1.png"];
                
            }
        }
    }
    lastItem = item;
    
    
    
    
    if ([[((RADataObject *)item) children] count] != 0) {
        self.indexPathSelected = indexPath;
    }
    else
    {
        self.indexPathSelected = nil;
        if ([[((RADataObject *)item) name] isEqualToString:@"Trang chủ"]) {
            HomePageViewController * vc = [[HomePageViewController alloc]init];
            [treeView deselectRowForItem:item animated:YES];
            //            [revealVC.navigationController pushViewController:vc animated:YES];
            //            [revealVC revealToggle:nil];
            UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
            [[self sideMenuController] changeContentViewController:contentNavigationController closeMenu:YES];
            //            [self closeLeftMenu];
        }
        else
        {
            int cateID = [((RADataObject *)item)cateID];
            NSNumber *number = [NSNumber numberWithInt:cateID];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openCategory" object:number];
            //            [revealVC revealToggle:nil];
            [self closeLeftMenu];
        }
    }
    
}
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //    NSInteger numberOfChildren = [treeNodeInfo.children count];
    if ([[((RADataObject *)item) name] isEqualToString:@"Account"])
    {
        AccountTableViewCell *cell = nil;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell.location setTitle:locationStored.locationName forState:UIControlStateNormal];
        [cell.location addTarget:self action:@selector(location) forControlEvents:UIControlEventTouchUpInside];
        [cell.signUp setBackgroundColor:[UIColor colorWithHex:@"#3498db" alpha:1]];
        [cell.signUp addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
        [cell.signIn setBackgroundColor:[UIColor colorWithHex:@"#71be0f" alpha:1]];
        [cell.signIn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.backgroundColor = [UIColor colorWithHex:@"#444444" alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    if ([[((RADataObject *)item) name] isEqualToString:@"Info"]) {
        AppInfoTableViewCell *cell = nil;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AppInfoTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.callBtn addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.callBtn setBackgroundColor:[UIColor colorWithHex:@"#71be0f" alpha:1]];
        [cell.callBtn setImage:[UIImage imageNamed:@"ic_phone"] forState:UIControlStateNormal];
        [cell.callBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
        return cell;
    }
    else
    {
        RACellTableViewCell *cell = nil;
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RACellTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (([[((RADataObject *)item) children] count] == 0)&&(![[((RADataObject *)item) name] isEqualToString:@"Trang chủ"])){
            cell.lblName.font = [UIFont systemFontOfSize:13];
            //            [cell.imgExpanse removeFromSuperview];
            //            cell.imgExpanse = nil;
            [cell.imgLogo removeFromSuperview];
            cell.imgLogo = nil;
            cell.lblName.text = ((RADataObject *)item).name;
        }
        else
        {
            cell.lblName.text = [((RADataObject *)item).name uppercaseString];
            cell.lblName.font = [UIFont boldSystemFontOfSize:14];
            if (![[((RADataObject *)item) name] isEqualToString:@"Trang chủ"]) {
                if ([((RADataObject *)item) cateID] == 557)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_anuong"];
                }
                if ([((RADataObject *)item) cateID] == 579)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_spa"];
                }
                if ([((RADataObject *)item) cateID] == 555)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_daotao"];
                }
                if ([((RADataObject *)item) cateID] == 571)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_sanpham"];
                }
                if ([((RADataObject *)item) cateID] == 581)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_dulich"];
                }
                if ([((RADataObject *)item) cateID] == 593)
                {
                    cell.imgLogo.image = [UIImage imageNamed:@"ic_thoitrang"];
                }
                if (lastItem!= nil && lastItem == item) {
                    cell.imgExpanse.image = [UIImage imageNamed:@"ic_expan_red.png"];
                    //                    lastItem = nil;
                }
                else
                {
                    cell.imgExpanse.image = [UIImage imageNamed:@"ic_expan_gray.png"];
                }
            }
            else
            {
                cell.imgLogo.image = [UIImage imageNamed:@"ic_home"];
            }
        }
        
        return cell;
    }
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

-(void)callAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0936459200"]];
}
-(void)signIn
{
}
-(void)signUp
{
}
-(void)location
{
    LocationPageViewController * vc = [[LocationPageViewController alloc]init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [[self sideMenuController] changeContentViewController:contentNavigationController closeMenu:YES];
}
@end
