//
//  AccoutViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AccoutViewController.h"
#import "CellObject.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
@interface AccoutViewController ()

@end

@implementation AccoutViewController
{
    NSMutableArray * arrMenu;
    SWRevealViewController *revealController;
}
@synthesize btnAvatar, lblName, tableAccount;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    [self initData];
    [self initUITableView];
    // Do any additional setup after loading the view from its nib.
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
    label.text = NSLocalizedString(@"Home", @"");
    [label sizeToFit];
    
    revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIImage *image = [UIImage imageNamed:@"menu_n.png"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}


-(void)initData
{
    arrMenu = [[NSMutableArray alloc]init];
    CellObject * cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Thông tin tài khoản";
    [arrMenu addObject:cellOBj];
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Thông tin đơn hàng";
    [arrMenu addObject:cellOBj];

    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Đổi mật khẩu";
    [arrMenu addObject:cellOBj];

    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Đăng xuất";
    [arrMenu addObject:cellOBj];

}
-(void)initUITableView
{
    tableAccount.layer.borderWidth = 0.3;
    tableAccount.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableAccount.dataSource = self;
    tableAccount.delegate = self;
    tableAccount.separatorColor = [UIColor clearColor];
    tableAccount.showsVerticalScrollIndicator = NO;
    tableAccount.sectionHeaderHeight = 0.0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMenu count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CellObject * obj = [arrMenu objectAtIndex:indexPath.row];
    cell.imgLeft.image = [UIImage imageNamed:obj.strImageName];
    cell.lblName.text = obj.strName;
    return cell;

}
@end
