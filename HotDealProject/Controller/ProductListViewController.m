//
//  ProductListViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/22/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ProductListViewController.h"
#import "DealCell.h"
//#import "DealObject.h"
#import "SVPullToRefresh.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ShortDealInfoCell.h"
#import "ProductObject.h"
#import "TKDatabase.h"
@interface ProductListViewController ()

@end
@implementation ProductListViewController
{
    SWRevealViewController *revealController;
//    NSMutableArray * arrProduct;
    UIView * viewHeader;
    UIButton * btnChoiceProducts;
    UIPickerView *myPickerView ;
    NSUInteger numRowsInPicker;
    NSUInteger iTagedButton;
     NSUInteger iSelectedQuantity;
    UIToolbar *toolBar;
//    NSMutableArray * arrSelectedItem;
}
@synthesize tableViewProduct;
@synthesize arrProduct;
@synthesize delegate;
@synthesize dictDealDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    arrSelectedItem = [[NSMutableArray alloc]init];
    iTagedButton = -1;
    iSelectedQuantity = -1;
    [self setupDoneBtn];
    [self initUITableView];
    [self setupPickerview];
    [self setupToolbar];
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Chọn số lượng"];
    

    [self initData2];
    
    // Do any additional setup after loading the view.
}


-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData2
{
    if ([arrProduct count] != 0 && arrProduct != nil) {
        return;
    }
    
    arrProduct = [dictDealDetail objectForKey:@"child_products"];
    if ([arrProduct count] == 0) {
        arrProduct = [[NSMutableArray alloc]init];
        ProductObject * item = [[ProductObject alloc]init];
        item.strProductID = F(@"%@",[dictDealDetail objectForKey:@"product_id"]);
        item.strTitle = [dictDealDetail objectForKey:@"title"];
        item.iCurrentQuantity = 0;
        item.iMaxQuantity = 5;
        item.lDiscountPrice = [[dictDealDetail objectForKey:@"price"]intValue];
        item.lStandarPrice = [[dictDealDetail objectForKey:@"list_price"]intValue];
        [arrProduct addObject:item];
    }
}
-(void)initData
{
    if ([arrProduct count] != 0 && arrProduct != nil) {
        return;
    }
    arrProduct = [[NSMutableArray alloc]init];
    
    ProductObject * item = [[ProductObject alloc]init];
     item.strProductID = @"1";
    item.strTitle = @"Buffet nướng và các món hè phố hơn 40 món tại Nhà hàng Con gà trống";
    item.iCurrentQuantity = 0;
    item.iMaxQuantity = 1;
    item.lDiscountPrice = 100000;
    item.lStandarPrice = 400000;
    [arrProduct addObject:item];
    
    item = [[ProductObject alloc]init];
    item.strTitle = @"Buffet ốc và các món hè phố hơn 40 món tại Nhà hàng Cầu Vồng";
    item.strProductID = @"2";
    item.iCurrentQuantity = 0;
    item.iMaxQuantity = 2;
    item.lDiscountPrice = 200000;
    item.lStandarPrice = 1000000;
    [arrProduct addObject:item];
    
    item = [[ProductObject alloc]init];
    item.strTitle = @"Bánh kem BreadTalk thương hiệu bánh nổi tiếng đến từ Singapore";
    item.iCurrentQuantity = 0;
    item.strProductID = @"3";
    item.iMaxQuantity = 3;
    item.lDiscountPrice = 30000;
    item.lStandarPrice = 200000;
    [arrProduct addObject:item];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUITableView
{
    tableViewProduct = [[UITableView alloc]initWithFrame:CGRectMake(0, -30, ScreenWidth, ScreenHeight - 40) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewProduct];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    tableViewProduct.backgroundColor = [UIColor whiteColor];
    tableViewProduct.dataSource = self;
    tableViewProduct.delegate = self;
    tableViewProduct.separatorColor = [UIColor clearColor];
    tableViewProduct.showsVerticalScrollIndicator = NO;
    tableViewProduct.sectionHeaderHeight = 0.0;
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrProduct count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShortDealInfoCell *cell = (ShortDealInfoCell *)[tableView dequeueReusableCellWithIdentifier:@"ShortDealInfoCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShortDealInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }    //    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    ProductObject * item = [arrProduct objectAtIndex:indexPath.row];
//    for (ProductObject  *obj in arrTotalItemSelected) {
//        if (obj.productID == item.productID) {
//            NSString * strQuantity = F(@"%lu",(unsigned long)obj.iCount );
//            [cell.btnChoice setTitle:strQuantity forState:UIControlStateNormal];
//        }
//    }
    cell.btnChoice.tag = indexPath.row;
    NSString * strQuantity = F(@"%lu",(unsigned long)item.iCurrentQuantity );
    [cell.btnChoice setTitle:strQuantity forState:UIControlStateNormal];
    [cell.btnChoice addTarget:self action:@selector(showDropbox:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblDescription.text = item.strTitle;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblStandarPrice.attributedText = attributedString;
    [cell.lblStandarPrice sizeToFit];
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    strDiscountPrice = F(@"%@đ", strDiscountPrice);
    cell.lblDiscountPrice.text = strDiscountPrice;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    return viewHeader;
    UIView * viewFooter = [[UIView alloc]initWithFrame:btnChoiceProducts.frame];
    [viewFooter addSubview:btnChoiceProducts];
    return viewFooter;
}
-(UIButton *)setupDoneBtn
{
    btnChoiceProducts = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 40)];
    [btnChoiceProducts setBackgroundColor:[UIColor greenColor]];
    [btnChoiceProducts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChoiceProducts setTitle:@"CHỌN" forState:UIControlStateNormal];
    [btnChoiceProducts addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    return btnChoiceProducts;
}
-(void)doneClick
{
    UA_log(@"clicked");
    for (ProductObject * item  in arrProduct) {
        UA_log(@"%d",item.iMaxQuantity);
        if (item.iCurrentQuantity != 0) {
            [[TKDatabase sharedInstance]addProduct:item];
        }
    }
//    [self.delegate updateTotalSeletedItem:arrProduct];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDealCount" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showDropbox:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    UA_log(@"%ld",btnSelected.tag);
    ProductObject * item = [arrProduct objectAtIndex:btnSelected.tag];
    numRowsInPicker = item.iMaxQuantity + 1;
    
    iTagedButton = btnSelected.tag;
    myPickerView.hidden = NO;
    toolBar.hidden = NO;
    tableViewProduct.userInteractionEnabled = NO;
    [myPickerView reloadComponent:0];
}
-(void)setupToolbar
{
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,ScreenHeight -250 - 44,ScreenWidth,44)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    
    UIButton *button_done = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_done addTarget:self action:@selector(selectQuantity) forControlEvents:UIControlEventTouchUpInside];
    [button_done setTitle:@"Chọn" forState:UIControlStateNormal];
    button_done.frame = CGRectMake(0.0f,0.0f,70,44);
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithCustomView:button_done];
    
//            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:button_done];
    
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_cancel addTarget:self action:@selector(cancelQuantity) forControlEvents:UIControlEventTouchUpInside];
    [button_cancel setTitle:@"Hủy" forState:UIControlStateNormal];
    button_cancel.frame = CGRectMake(0.0f,0.0f,70,44);
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithCustomView:button_cancel];
    
    toolBar.items = @[barButtonCancel,flexibleItem,barButtonDone];
    button_done.tintColor=[UIColor whiteColor];
    button_cancel.tintColor=[UIColor whiteColor];
    toolBar.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:toolBar];
    toolBar.hidden = YES;
}
-(void)setupPickerview
{
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight -250, ScreenWidth, 200)];
//    numRowsInPicker = 3;
    myPickerView.delegate = self;
    [myPickerView setBackgroundColor:[UIColor whiteColor]];
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.hidden = YES;
    [self.view addSubview:myPickerView];
}

-(void)cancelQuantity
{
    myPickerView.hidden = YES;
    toolBar.hidden = YES;
    tableViewProduct.userInteractionEnabled = YES;
//    UA_log(@"%ld",[myPickerView selectedRowInComponent:0]);
}
-(void)selectQuantity
{
//    UA_log(@"%ld",[myPickerView selectedRowInComponent:0]);
//    iTagedButton
    ProductObject * productObj = [arrProduct objectAtIndex:iTagedButton];

    myPickerView.hidden = YES;
    toolBar.hidden = YES;
    tableViewProduct.userInteractionEnabled = YES;
    iSelectedQuantity = [myPickerView selectedRowInComponent:0];
    productObj.iCurrentQuantity =  (int)iSelectedQuantity ;
//    [arrSelectedItem addObject:productObj];

    [arrProduct replaceObjectAtIndex:iTagedButton withObject:productObj];
    [tableViewProduct reloadData];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
//    UA_log(@"%ld",row);
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return numRowsInPicker;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%ld",(long)row];
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

@end
