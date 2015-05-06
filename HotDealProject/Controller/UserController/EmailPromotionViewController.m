//
//  EmailPromotionViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "EmailPromotionViewController.h"
#import "AppDelegate.h"
#import "TKDatabase.h"
@interface EmailPromotionViewController ()

@end

@implementation EmailPromotionViewController
{
    NSArray * arrProvine;
    NSMutableArray * arrSelected;
}
@synthesize tableProvine;
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    arrSelected = [[NSMutableArray alloc]init];
    arrSelected = [[TKDatabase sharedInstance]getAllProvineUserSelected];
    [self initData];
    [self initUITableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUITableView
{
    tableProvine.backgroundColor = [UIColor whiteColor];
    tableProvine.dataSource = self;
    tableProvine.delegate = self;
    tableProvine.separatorColor = [UIColor clearColor];
    tableProvine.showsVerticalScrollIndicator = NO;
    tableProvine.sectionHeaderHeight = 0.0;
    tableProvine.scrollEnabled = NO;
    
    tableProvine.layer.borderWidth = 0.3;
    tableProvine.layer.borderColor = [UIColor lightGrayColor].CGColor;

}

-(void)initData
{
    arrProvine = [[NSMutableArray alloc]init];
    arrProvine = [NSArray arrayWithObjects:@"Bà Rịa - Vũng Tàu",@"Bình Dương",@"Cần Thơ",@"Đà Nẵng",@"Đồng Nai",@"Hà Nội",@"Khánh Hoà",@"TP Hồ Chí Minh", nil];
}
-(void)backbtn_click:(id)sender
{
    [self.delegate updateProvine];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Email khuyến mãi"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProvine count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strItem = [arrProvine objectAtIndex:indexPath.row];
    if ([arrSelected containsObject:strItem]) {
//        [arrSelected removeObject:strItem];
        [[TKDatabase sharedInstance]removeProvineSelected:strItem];
        arrSelected = [[TKDatabase sharedInstance]getAllProvineUserSelected];
    }
    else
    {
//        [arrSelected addObject:strItem];
        [[TKDatabase sharedInstance]addProvine:strItem];
        arrSelected = [[TKDatabase sharedInstance]getAllProvineUserSelected];
    }
    [tableProvine reloadData];
}


- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * item = [arrProvine objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    
    UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 38, ScreenWidth - 40, 5)];
    imgLine.image = [UIImage imageNamed:@"gach"];
    
    [cell.contentView addSubview:imgLine];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([arrSelected containsObject:item]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
