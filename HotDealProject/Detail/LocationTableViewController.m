//
//  LocationTableViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "LocationTableViewController.h"
#import "LocationCell.h"
#import "AppDelegate.h"
@interface LocationTableViewController ()

@end

@implementation LocationTableViewController
@synthesize arrLocation;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Địa điểm sử dụng"];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    
//    if (self)
//    {
//        
//    }
//    return self;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)configureLocationCell:(LocationCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell.btnCall addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [self configureLocationCell:cell forRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}
-(void)callAction
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0936459200"]];
}
@end
