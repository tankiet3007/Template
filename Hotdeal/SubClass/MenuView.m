//
//  MenuView.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/23/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import "MenuView.h"
#import "CategoryObj.h"
#import "CategoryFilterViewController.h"
@implementation MenuView
{
    id lastItem;
}
@synthesize listCategory;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)reloadData
{
     [self.treeView reloadData];
}
-(void)initView
{
    self.backgroundColor = [UIColor darkGrayColor];
    RADataObject *account = [RADataObject dataObjectWithName:@"Account" children:nil cateID:1 imgURL:nil];
    RADataObject *home = [RADataObject dataObjectWithName:@"Trang chủ" children:nil cateID:0 imgURL:@"home"];
    
    RADataObject *info = [RADataObject dataObjectWithName:@"Info" children:nil cateID:2 imgURL:nil];
    NSMutableArray * cateList = [NSMutableArray new];
    for (CategoryObj * item in listCategory) {
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
    self.treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 10, 260, HEIGHT(self)-20)];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    self.treeView.separatorColor = [UIColor clearColor];
    [self addSubview:self.treeView];
    [self.treeView reloadData];
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([[((RADataObject *)item) name] isEqualToString:@"Account"]) {
        return 185;
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
    RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
    cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"food"];
    return YES;
}
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo wCell:(UITableViewCell*)cell
{
    RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
    cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"spa"];
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
        cell.backgroundColor = UIColorFromRGB(0xD4D4D4);
//        cell.backgroundColor = [UIColor lightGrayColor];
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source w
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo wCell:(UITableViewCell *)cell
{
    
    if (lastItem != nil && lastItem != item) {
        [treeView collapseRowForItem:lastItem];
    }
    
    if ([[((RADataObject *)item) children] count] != 0) {
        RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
//        cellAtIndex.backgroundColor = UIColorFromRGB(0xD4D4D4);
        cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"spa"];
    }
    lastItem = item;
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
        [cell.signUp setBackgroundColor:[UIColor colorWithHex:@"#71be0f" alpha:1]];
        [cell.signIn setBackgroundColor:[UIColor colorWithHex:@"#3498db" alpha:1]];
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
        [cell.callBtn setBackgroundColor:[UIColor colorWithHex:@"#3498db" alpha:1]];
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
        if (([[((RADataObject *)item) children] count] == 0)&&(![[((RADataObject *)item) name] isEqualToString:@"homeID"])){
            cell.lblName.font = [UIFont systemFontOfSize:14];
            [cell.imgExpanse removeFromSuperview];
            cell.imgExpanse = nil;
            [cell.imgLogo removeFromSuperview];
            cell.imgLogo = nil;
        }
        cell.lblName.text = ((RADataObject *)item).name;
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
@end
