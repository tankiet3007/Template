//
//  StartupViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "StartupViewController.h"
#import "MainViewController.h"
#import "LocationTableViewCell.h"
#import "TKAPI.h"
#import "SWRevealViewController.h"
@interface StartupViewController ()

@end

@implementation StartupViewController
{
    NSArray * arrLocation;
    NSInteger iIndexSelected;
    SWRevealViewController *revealController;
}
@synthesize tableViewMain;
@synthesize isFromLeftMenu;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    iIndexSelected = -1;
    if (isFromLeftMenu == TRUE) {
        [self initNavigationbar];
    }
    [self initData];
    [self initUITableView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)homeClick:(id)sender {
        MainViewController * mainVC = [[MainViewController alloc]init];
        [self.navigationController pushViewController:mainVC animated:YES];
//    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @"Value1", @"Key1",
//                                    @"Value2", @"Key2",
//                                    nil];
//
//    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:@"http://chrisrisner.com/Labs/day7test.php?name=KietTran" completion:^(NSDictionary * dict, NSError *error) {
//        [self showMainView:dict wError:error];
//    }];
//    [TKAPI postRequest:jsonDictionary withURL:@"http://chrisrisner.com/Labs/day7test.php?name=KietTran"];
}

-(void)showMainView:(NSDictionary *)data wError :(NSError *)error
{
//    UA_log(@"%@",data);
//    MainViewController * mainVC = [[MainViewController alloc]init];
//    [self.navigationController pushViewController:mainVC animated:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
    label.text = NSLocalizedString(@"DANH MUC", @"");
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
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"indexSelected"];
    if (savedValue != nil) {
        iIndexSelected = [savedValue integerValue];
    }
    arrLocation = [NSArray arrayWithObjects:@"Hà Nội",@"Hồ Chí Minh",@"Bình Dương",@"Đà Nẵng",@"Tỉnh thành khác", nil];
}
-(void)initUITableView
{
    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(20, 80, ScreenWidth-40, 150) style:UITableViewStylePlain];
    [self.view addSubview:tableViewMain];
    tableViewMain.layer.borderWidth = 0.3;
    tableViewMain.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableViewMain.backgroundColor = [UIColor whiteColor];
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    tableViewMain.separatorColor = [UIColor clearColor];
    tableViewMain.showsVerticalScrollIndicator = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrLocation count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"LocationTableViewCell";
    
    
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    cell.locationName.text = [arrLocation objectAtIndex:indexPath.row];
//    cell.contentView.layer.borderWidth = 0.5;
    
    if (iIndexSelected == indexPath.row) {
        cell.radioButton.image = [UIImage imageNamed:@"radio_checked"];
    }
    else
    {
        cell.radioButton.image = [UIImage imageNamed:@"radio"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.radioButton.image = [UIImage imageNamed:@"radio_checked"];
    iIndexSelected = indexPath.row;
    NSString *valueToSave = F(@"%ld", (long)indexPath.row);
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"indexSelected"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableViewMain reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationUpdateLocation" object:nil];
    MainViewController * mainVC = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainVC animated:YES];
}

//1 item --> height = 20 --> 10 item height = 200  // filter
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
