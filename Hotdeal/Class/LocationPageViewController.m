//
//  LocationPageViewController.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "LocationPageViewController.h"
#import "LocationObj.h"
@interface LocationPageViewController ()

@end

@implementation LocationPageViewController
{
    NSMutableArray * arrLocation;
    SWRevealViewController *revealController;
}
@synthesize isFromLeftMenu, tableViewMain;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#f2f2f2" alpha:1];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    AppDelegate * app = [AppDelegate sharedDelegate];
    [app initNavigationbar:self withTitle:@"CHỌN ĐỊA ĐIỂM"];
    [self initData];
    [self initUITableView];
    if (isFromLeftMenu == YES) {
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    }
}

-(void)checkLocation
{
    LocationObj * locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    if (locationStored == nil) {
    }
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
-(NSDictionary *)loadLocationFromDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"location.json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    if (jsonData == nil) {
        return nil;
    }
    NSDictionary *content  =[NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:kNilOptions
                                                              error:nil];
    return content;
}
-(void)initData
{
    arrLocation = [[NSMutableArray alloc]init];
    LocationObj * location = [LocationObj new];
    location.locationID = @"437";
    location.locationName = @"Hồ Chí Minh";
    [arrLocation addObject:location];
    location = [LocationObj new];
    location.locationID = @"440";
    location.locationName = @"Hà Nội";
    [arrLocation addObject:location];
    location = [LocationObj new];
    location.locationID = @"0";
    location.locationName = @"Tỉnh thành khác";
    [arrLocation addObject:location];
}
-(void)initUITableView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor blackColor]; // change this color
    label.text = @"CHỌN KHU VỰC BẠN SỐNG";
    [self.view addSubview:label];
    
    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(22, 93, SCREEN_WIDTH-44, 150) style:UITableViewStylePlain];
    
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textbox_location"]];
    [tempImageView setFrame:CGRectMake(20, 90, SCREEN_WIDTH-40, 150)];
    [self.view addSubview:tempImageView];
//    tableViewMain.backgroundView = tempImageView;
    [self.view addSubview:tableViewMain];
    
    tableViewMain.backgroundColor = [UIColor clearColor];
    tableViewMain.dataSource = self;
    tableViewMain.delegate = self;
    tableViewMain.separatorColor = [UIColor clearColor];
    tableViewMain.showsVerticalScrollIndicator = NO;
    tableViewMain.scrollEnabled = NO;
    
    UIImageView * mascot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_location"]];
    [mascot setFrame:CGRectMake(SCREEN_WIDTH/2 - 135/2, HEIGHT(tableViewMain)+ Y(tableViewMain)+30, 135, 200)];
    [self.view addSubview:mascot];
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
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    LocationObj * obj = [arrLocation objectAtIndex:indexPath.row];
    cell.locationName.text = obj.locationName;
    LocationObj * locationStored = [LocationObj loadCustomObjectWithKey:@"Location"];
    if (locationStored == nil) {
        if (0 == indexPath.row) {
            cell.radioButton.image = [UIImage imageNamed:@"radio_checked.png"];
        }
        else
        {
            cell.radioButton.image = [UIImage imageNamed:@"radio.png"];
        }
    }
    else
    {
        if ([obj.locationID isEqualToString:locationStored.locationID]) {
            cell.radioButton.image = [UIImage imageNamed:@"radio_checked.png"];
        }
        else
        {
            cell.radioButton.image = [UIImage imageNamed:@"radio.png"];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.radioButton.image = [UIImage imageNamed:@"radio_checked"];
    LocationObj * obj = [arrLocation objectAtIndex:indexPath.row];
    [LocationObj saveCustomObject:obj key:@"Location"];
//    [tableViewMain reloadData];
    NotifPost(@"updateLocation");
    HomePageViewController * homepage = [[HomePageViewController alloc]init];
    [self.navigationController pushViewController:homepage animated:YES];
}

@end
