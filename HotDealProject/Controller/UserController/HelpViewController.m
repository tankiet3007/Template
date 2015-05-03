//
//  HelpViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/3/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "HelpViewController.h"
#import "CellObject.h"
#import "SWRevealViewController.h"
#import "MenuTableViewCell.h"
#import "WebViewController.h"
@interface HelpViewController ()

@end

@implementation HelpViewController
{
    NSMutableArray * arrMenu;
    SWRevealViewController *revealController;
}
@synthesize tableHelp;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    [self initData];
    [self initUITableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    label.text = NSLocalizedString(@"Hỗ trợ", @"");
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
    cellOBj.strName = @"Về cùng mua";
    [arrMenu addObject:cellOBj];
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Quy chế sàn giao dịch";
    [arrMenu addObject:cellOBj];
    
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Trả hàng & hoàn tiền";
    [arrMenu addObject:cellOBj];
    
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Hướng dẫn mua hàng";
    [arrMenu addObject:cellOBj];
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Hình thức thanh toán";
    [arrMenu addObject:cellOBj];
    
    
    cellOBj = [[CellObject alloc]init];
    cellOBj.strImageName = @"map_pin_fill-512";
    cellOBj.strName = @"Hình thức giao hàng";
    [arrMenu addObject:cellOBj];
    
    
}
-(void)initUITableView
{
    tableHelp.layer.borderWidth = 0.3;
    tableHelp.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableHelp.dataSource = self;
    tableHelp.delegate = self;
    tableHelp.separatorColor = [UIColor clearColor];
    tableHelp.showsVerticalScrollIndicator = NO;
    tableHelp.sectionHeaderHeight = 0.0;
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
- (IBAction)callHelpCenter:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:2135554321"]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController * web = [[WebViewController alloc]init];
    web.url = [NSURL URLWithString:@"http://m.hamtruyen.com/doc-truyen/ban-long-chapter-83.html"];
    [self.navigationController pushViewController:web animated:YES];
}
@end
