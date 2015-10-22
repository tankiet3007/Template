
//The MIT License (MIT)
//
//Copyright (c) 2013 Rafał Augustyniak
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of
//this software and associated documentation files (the "Software"), to deal in
//the Software without restriction, including without limitation the rights to
//use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//the Software, and to permit persons to whom the Software is furnished to do so,
//subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "RAViewController.h"
#import "RATreeView.h"
#import "RADataObject.h"
#import "RACellTableViewCell.h"
#import "AccountTableViewCell.h"
#import "AppInfoTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface RAViewController () <RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation RAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    RADataObject *account = [RADataObject dataObjectWithName:@"Account" children:nil cateID:@"Account" imgURL:nil];
    
    RADataObject *info = [RADataObject dataObjectWithName:@"Info" children:nil cateID:@"Info" imgURL:nil];
    
    
    RADataObject *phone1 = [RADataObject dataObjectWithName:@"Phone 1" children:nil cateID:@"01" imgURL:@"www.google.com"];
    RADataObject *phone2 = [RADataObject dataObjectWithName:@"Phone 2" children:nil cateID:@"02" imgURL:@"www.google.com"];
    RADataObject *phone3 = [RADataObject dataObjectWithName:@"Phone 3" children:nil cateID:@"03" imgURL:@"www.google.com"];
    RADataObject *phone4 = [RADataObject dataObjectWithName:@"Phone 4" children:nil cateID:@"04" imgURL:@"www.google.com"];
    
    
    RADataObject *phone = [RADataObject dataObjectWithName:@"Phones"
                                                  children:[NSArray arrayWithObjects:phone1, phone2, phone3, phone4, nil]cateID:@"01" imgURL:@"www.google.com"];
    
    RADataObject *computer1 = [RADataObject dataObjectWithName:@"Computer 1"
                                                      children:nil cateID:@"01" imgURL:@"www.google.com"];
    RADataObject *computer2 = [RADataObject dataObjectWithName:@"Computer 2" children:nil cateID:@"01" imgURL:@"www.google.com"];
    RADataObject *computer3 = [RADataObject dataObjectWithName:@"Computer 3" children:nil cateID:@"01" imgURL:@"www.google.com"];
    
    RADataObject *computer = [RADataObject dataObjectWithName:@"Computers"
                                                     children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil] cateID:@"01" imgURL:@"www.google.com"];
    RADataObject *car = [RADataObject dataObjectWithName:@"Cars" children:[NSArray arrayWithObjects:computer1, computer2, computer3, nil] cateID:@"homeID" imgURL:@"www.google.com"];
    
    self.data = [NSArray arrayWithObjects:account,car,phone, computer,info, nil];
    
//    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, -48, ScreenWidth, ScreenHeight + 48)];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    //  [treeView expandRowForItem:phone withRowAnimation:RATreeViewRowAnimationLeft]; //expands Row
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
    //    UIView * vHeader = [self setupHeaderView];
    //    [self.view addSubview: vHeader];
}

-(UIView*)setupHeaderView
{
    UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    UIButton * btnAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAvatar setFrame:CGRectMake(0, 20, 50, 50)];
    [btnAvatar setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateNormal];
    [vHeader addSubview:btnAvatar];
    
    UILabel * lblName = [[UILabel alloc]initWithFrame:CGRectMake(80, 60, 80, 20)];
    lblName.text = @"Guest";
    lblName.font = [UIFont systemFontOfSize:12];
    [vHeader addSubview:lblName];
    
    UILabel * lblLocation = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 80, 20)];
    lblLocation.text = @"Địa điểm";
    lblLocation.font = [UIFont systemFontOfSize:12];
    [vHeader addSubview:lblLocation];
    
    UIButton * btnLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setTitle:@"HCM" forState:UIControlStateNormal];
    [btnLocation setFrame:CGRectMake(80, 80, 80, 20)];
    [vHeader addSubview:btnLocation];
    
    return vHeader;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    self.treeView.frame = self.view.bounds;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if ([[((RADataObject *)item) cateID] isEqualToString:@"Account"]) {
        return 160;
    }
    if ([[((RADataObject *)item) cateID] isEqualToString:@"Info"]) {
        return 77;
    }
    return 40;
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
    //  if ([item isEqual:self.expanded]) {
    //    return YES;
    //  }
    return YES;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source w
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo wCell:(UITableViewCell *)cell
{
    NSLog(@"%@",((RADataObject *)item).name);
    if ([[((RADataObject *)item) children] count] != 0) {
        RACellTableViewCell* cellAtIndex = (RACellTableViewCell*)cell;
        cellAtIndex.imgExpanse.image = [UIImage imageNamed:@"spa"];
        
    }
}
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    NSInteger numberOfChildren = [treeNodeInfo.children count];
    //    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    //    static NSString *simpleTableIdentifier = @"RACellTableViewCell";
    if ([[((RADataObject *)item) cateID] isEqualToString:@"Account"])
    {
        AccountTableViewCell *cell = nil;//(RACellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell";
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AccountTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;

    }
    else
    {
        RACellTableViewCell *cell = nil;//(RACellTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell";
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RACellTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (([[((RADataObject *)item) children] count] == 0)&&(![[((RADataObject *)item) cateID] isEqualToString:@"homeID"])){
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

@end
