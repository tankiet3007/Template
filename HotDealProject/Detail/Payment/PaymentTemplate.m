//
//  PaymentTemplate.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/28/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PaymentTemplate.h"
#import "PaymentInfoCell.h"
#import "PaymentInfoObject.h"
@implementation PaymentTemplate
@synthesize arrInfo, tablePaymentInfo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)initUITableView
{
    tablePaymentInfo = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-50) style:UITableViewStylePlain];
    [self addSubview:tablePaymentInfo];
    tablePaymentInfo.backgroundColor = [UIColor whiteColor];
    tablePaymentInfo.dataSource = self;
    tablePaymentInfo.delegate = self;
    tablePaymentInfo.separatorColor = [UIColor clearColor];
    tablePaymentInfo.showsVerticalScrollIndicator = NO;
    tablePaymentInfo.sectionHeaderHeight = 0.0;
    
    UIButton * btnDone = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnDone setFrame:CGRectMake(0, HEIGHT(self) - 50, WIDTH(self), 50)];
    [btnDone setBackgroundColor:[UIColor colorWithHex:@"#0cba06" alpha:1]];
    [btnDone setTitle:@"THANH TOÁN" forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnDone addTarget:self action:@selector(paymentDone) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDone];
}
-(void)paymentDone
{
    //    PaymentSuccessViewController * pS = [[PaymentSuccessViewController alloc]init];
    //    [self.navigationController pushViewController:pS animated:YES];
    [self.delegate checkDone];
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(void)reloadData
{
    [tablePaymentInfo reloadData];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 60)];
    vHeader.backgroundColor = [UIColor whiteColor];
    UILabel * lblHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(tableView), 34)];
    lblHeaderTitle.text = @"THÔNG TIN GIAO HÀNG";
    lblHeaderTitle.textColor = [UIColor darkGrayColor];
    lblHeaderTitle.font = [UIFont boldSystemFontOfSize:18];
    lblHeaderTitle.textAlignment = NSTextAlignmentCenter;
    [vHeader addSubview:lblHeaderTitle];
    
    UIView * underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 45, ScreenWidth - 20, 1)];
    underLine.backgroundColor = [UIColor lightGrayColor];
    [vHeader addSubview:underLine];
    return vHeader;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PaymentInfoCell";
    
    PaymentInfoCell *cell = (PaymentInfoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PaymentInfoObject * pObject = [arrInfo objectAtIndex:indexPath.row];
    cell.lblName.text = pObject.strName;
    cell.lblDescription.text = pObject.strDescription;
    return cell;
}
@end
