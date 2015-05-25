//
//  AddressViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AddressViewController.h"
#import "AppDelegate.h"
#import "AddressCell.h"

@interface AddressViewController ()

@end

@implementation AddressViewController
{
    NSMutableArray * arrRawAddress;
    NSMutableArray * arrAddress;
    
    UIView * vFooter;
}
#define RowHeight 70
@synthesize tableAddress;
@synthesize delegate;
@synthesize dictResponse;
@synthesize indexPathSelected;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationBar];
    [self setupFooterView];
    [self initData];
    [self initUITableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initNavigationBar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Địa chỉ giao hàng"];
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    arrRawAddress = [NSMutableArray new];
    arrAddress = [NSMutableArray new];
//    arrAddress = [NSMutableArray arrayWithObjects:@"33 ấp 4 xã Phước Kiển huyện Nhà Bè, TP.HCM, toà nha Yoco Building",@"41 Nguyễn Thị Minh Khai, toà nhà Yoco Buiding Phường Bến Nghé, Quận 1, TP.HCM", nil];
    arrRawAddress = [dictResponse objectForKey:@"profiles"];
    for (NSDictionary * dictItem in arrRawAddress) {
//        s_address_note: "a"
        NSString * strAddressNode = [dictItem objectForKey:@"s_address_note"];
        if ([strAddressNode isEqualToString:@""] || strAddressNode == nil) {
            strAddressNode = @"";
        }
        else
        {
            strAddressNode = F(@"Lầu: %@,", strAddressNode);
        }
        NSDictionary * dictWard = [dictItem objectForKey:@"s_ward"];
        NSDictionary * dictDictrict = [dictItem objectForKey:@"s_district"];
        NSDictionary * dictState = [dictItem objectForKey:@"s_state"];
        NSString * addressItem = F(@"%@ %@ %@ %@ %@",strAddressNode,[dictItem objectForKey:@"s_address"],[dictWard objectForKey:@"name"],[dictDictrict objectForKey:@"name"], [dictState objectForKey:@"name"]);
        [arrAddress addObject:addressItem];
    }
    
}
-(void)initUITableView
{
    tableAddress = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, ScreenWidth -20 , RowHeight * [arrAddress count] + 50) style:UITableViewStylePlain];
    [self.view addSubview:tableAddress];
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableAddress.backgroundColor = [UIColor whiteColor];
    tableAddress.dataSource = self;
    tableAddress.delegate = self;
    tableAddress.layer.borderWidth = 0.3;
    tableAddress.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableAddress.separatorColor = [UIColor clearColor];
    tableAddress.showsVerticalScrollIndicator = NO;
    tableAddress.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrAddress count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return RowHeight;
    
}


- (void)configureCell:(AddressCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblContain.text = [arrAddress objectAtIndex:indexPath.row];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell.btnEdit addTarget:self action:@selector(editAddress:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnEdit.tag = indexPath.row;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self configureCell:cell forRowAtIndexPath:indexPath];
    if (![indexPathSelected isEqual:indexPath]) {
        cell.imgStatus.image = [UIImage imageNamed:@"radio"];
    }
    else
    {
        cell.imgStatus.image = [UIImage imageNamed:@"radio_checked"];
    }
    return cell;
    
}
-(UIView *)setupFooterView
{
    if (vFooter != nil) {
        [vFooter removeFromSuperview];
        vFooter = nil;
    }
    vFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 50)];
    UIButton * btnAddAddress = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnAddAddress setFrame:CGRectMake(0, 5, 120, 40)];
    [btnAddAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnAddAddress.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btnAddAddress setTitle:@"Thêm địa chỉ" forState:UIControlStateNormal];
    [btnAddAddress addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [vFooter addSubview:btnAddAddress];
    return vFooter;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return vFooter;
}
-(void)addAddress
{
    UA_log(@"Add Address");
    AddressTableViewController * addressTable = [[AddressTableViewController alloc]init];
    addressTable.strTitle = @"Địa chỉ giao hàng";
    addressTable.delegate = self;
    [self.navigationController pushViewController:addressTable animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = (AddressCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgStatus.image = [UIImage imageNamed:@"radio_checked"];
    indexPathSelected = indexPath;
    [tableAddress reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate updateAddress:[arrAddress objectAtIndex:indexPath.row]wIndex:indexPath];
}

-(void)editAddress:(id)sender
{
    UIButton * btnEdit = (UIButton *)sender;
    int iIndex = (int)btnEdit.tag;
//    NSDictionary * dictAddress = [arrRawAddress objectAtIndex:iIndex];
    AddressTableViewController * addressTable = [[AddressTableViewController alloc]init];
    addressTable.dictResponse = dictResponse;
    addressTable.iIndexAddress = iIndex;
    addressTable.strTitle = @"Chỉnh sửa địa chỉ";
    [self.navigationController pushViewController:addressTable animated:YES];
    //    UA_log(@"%ld selected", btnEdit.tag);
}
-(void)updateTableAddress:(NSString *)strAddress
{
    [arrAddress addObject:strAddress];
    [tableAddress setFrame:CGRectMake(10, 20, ScreenWidth -20 , RowHeight * [arrAddress count] + 50)];
    
    [tableAddress reloadData];
    //    tableAddress = [[UITableView alloc]initWithFrame:CGRectMake(10, 20, ScreenWidth -20 , RowHeight * [arrAddress count] + 50) style:UITableViewStylePlain];
    
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
