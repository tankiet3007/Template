//
//  ShoppingCartController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ShoppingCartController.h"
#import "DealCell.h"
#import "SVPullToRefresh.h"
#import "HotNewDetailViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "ProductInfoStoredCell.h"
#import "ProductObject.h"
#import "TKDatabase.h"
#import "BBBadgeBarButtonItem.h"
#import "HotNewDetailViewController.h"
#import "InvoiceCell.h"
#import "PaymentViewController.h"
@interface ShoppingCartController ()

@end

@implementation ShoppingCartController
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
//@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    //    arrSelectedItem = [[NSMutableArray alloc]init];
    iTagedButton = -1;
    iSelectedQuantity = -1;
    [self setupLoginBtn];
    [self initUITableView];
    [self setupPickerview];
    [self setupToolbar];
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Giỏ hàng"];
    
    
    [self initData];
    
    // Do any additional setup after loading the view.
}


-(void)backbtn_click:(id)sender
{
    [self.delegate updateTotal];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initData
{
    if ([arrProduct count] != 0 && arrProduct != nil) {
        return;
    }
    arrProduct = [[NSMutableArray alloc]init];
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
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
    tableViewProduct.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    
    return [arrProduct count] + 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [arrProduct count]) {
        InvoiceCell *cell = (InvoiceCell *)[tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvoiceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSString * strStardarPrice = F(@"%d", [self calculateCash]);
        strStardarPrice = [strStardarPrice formatStringToDecimal];
//        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
//        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTotalOfBill.text  = strStardarPrice;
        
         cell.lblCash.text  = strStardarPrice;
        return cell;
        
    }
    else
    {
        ProductInfoStoredCell *cell = (ProductInfoStoredCell *)[tableView dequeueReusableCellWithIdentifier:@"ProductInfoStoredCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProductInfoStoredCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ProductObject * item = [arrProduct objectAtIndex:indexPath.row];
        cell.btnChoice.tag = indexPath.row;
        NSString * strQuantity = F(@"%lu",(unsigned long)item.iCurrentQuantity );
        [cell.btnChoice setTitle:strQuantity forState:UIControlStateNormal];
        [cell.btnChoice addTarget:self action:@selector(showDropbox:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblDescription.text = item.strTitle;
        
        [cell.btnDestroy addTarget:self action:@selector(destroyItem:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDestroy.tag = indexPath.row  + 999;
        NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
        strDiscountPrice = [strDiscountPrice formatStringToDecimal];
        strDiscountPrice = F(@"%@đ", strDiscountPrice);
        cell.lblDiscountPrice.text = strDiscountPrice;
        return cell;
    }
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotNewDetailViewController * hotDetail = [[HotNewDetailViewController alloc]init];
    [self.navigationController pushViewController:hotDetail animated:YES];
}

-(UIButton *)setupLoginBtn
{
    btnChoiceProducts = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, 40)];
    [btnChoiceProducts setBackgroundColor:[UIColor greenColor]];
    [btnChoiceProducts setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnChoiceProducts setTitle:@"THANH TOÁN" forState:UIControlStateNormal];
    [btnChoiceProducts addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    return btnChoiceProducts;
}
-(void)loginClick
{
    PaymentViewController * paymentVC = [[PaymentViewController alloc]init];
    [self.navigationController pushViewController:paymentVC animated:YES];
//    UA_log(@"clicked");
//    for (ProductObject * item  in arrProduct) {
//        UA_log(@"%d",item.iCurrentQuantity);
//        if (item.iCurrentQuantity != 0) {
//            [[TKDatabase sharedInstance]addProduct:item];
//        }
//    }
//    //    [self.delegate updateTotalSeletedItem:arrProduct];
//    [self.delegate updateTotal];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showDropbox:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    UA_log(@"%ld",btnSelected.tag);
    iTagedButton = btnSelected.tag;
    myPickerView.hidden = NO;
    toolBar.hidden = NO;
    tableViewProduct.userInteractionEnabled = NO;
    [myPickerView reloadComponent:0];
}

-(void)destroyItem:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    UA_log(@"%ld",btnSelected.tag);
    int iIndexRow = (int)btnSelected.tag - 999;
    
    ProductObject * productObj = [arrProduct objectAtIndex:iIndexRow];
    [arrProduct removeObject:productObj];
    [[TKDatabase sharedInstance]removeProduct:productObj.strProductID];
    if ([arrProduct count] == 0) {
        tableViewProduct.hidden = YES;
        UIView * viewEmpty = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
        UILabel * lblEmpty = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 300, 20)];
        lblEmpty.font = [UIFont boldSystemFontOfSize:14];
        lblEmpty.text = @"Không có sản phẩm nào trong giỏ hàng";
        viewEmpty.layer.cornerRadius = 5;
        viewEmpty.layer.masksToBounds = YES;
        [viewEmpty addSubview:lblEmpty];
        viewEmpty.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:viewEmpty];
    }
    [tableViewProduct reloadData];
}

-(void)setupToolbar
{
    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,ScreenHeight -250 - 44,320,44)];
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
    numRowsInPicker = 3;
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
-(int)calculateCash
{
    int i = 0;
    for (ProductObject * iObject in arrProduct) {
        i += iObject.lDiscountPrice * iObject.iCurrentQuantity;
    }
    return i;
}
@end
