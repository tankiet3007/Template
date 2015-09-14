//
//  CartViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "CartViewController.h"
#import "InvoiceCell.h"
#import "PaymentViewController.h"
#import "IQActionSheetPickerView.h"
#import "AppDelegate.h"
#import "ProductInfoStoredCell.h"
#import "TKDatabase.h"
#import "BBBadgeBarButtonItem.h"
#import "InvoiceCell.h"
#import "CartDealCell.h"
#import "CartTravelCell.h"
@interface CartViewController ()<IQActionSheetPickerViewDelegate>

@end

@implementation CartViewController
{
    UIButton * btnCash;
    MBProgressHUD *HUD;
}
@synthesize tableViewProduct;
@synthesize arrProduct;
//@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initHUD];
    [self initUITableView];
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Giỏ hàng"];
    [self initData];
    
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

-(void)backbtn_click:(id)sender
{
//    [self.delegate updateTotal];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    if ([arrProduct count] != 0 && arrProduct != nil) {
        return;
    }
    arrProduct = [[NSMutableArray alloc]init];
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    
    if ([arrProduct count] == 0) {
        tableViewProduct.hidden = YES;
        UIView * viewEmpty = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        UILabel * lblEmpty = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, ScreenWidth - 20, 20)];
        lblEmpty.font = [UIFont boldSystemFontOfSize:14];
        lblEmpty.text = @"Không có sản phẩm nào trong giỏ hàng";
        viewEmpty.layer.cornerRadius = 5;
        viewEmpty.layer.masksToBounds = YES;
        [viewEmpty addSubview:lblEmpty];
        viewEmpty.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:viewEmpty];
    }
}

-(void)initUITableView
{
    tableViewProduct = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 115) style:UITableViewStylePlain];
    [self.view addSubview:tableViewProduct];
    tableViewProduct.backgroundColor = [UIColor whiteColor];
    tableViewProduct.dataSource = self;
    tableViewProduct.delegate = self;
    tableViewProduct.separatorColor = [UIColor clearColor];
    tableViewProduct.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableViewProduct.showsVerticalScrollIndicator = NO;
    tableViewProduct.sectionHeaderHeight = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([arrProduct count] == 0) {
        return 0;
    }
    return [arrProduct count] + 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [arrProduct count]) {
        ProductObject * pItem = [arrProduct objectAtIndex:indexPath.row];
        UA_log(@"type ---- %@", pItem.strType);
    }
    
    if (indexPath.row == [arrProduct count]+1) {
        return 180;
    }
    if (indexPath.row == [arrProduct count]) {
        return 230;
    }
    return 150;
}

- (void)configureCell:(InvoiceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * strStardarPrice = F(@"%d", [self calculateCash]);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblQuantityProduct.text  = strStardarPrice;
    cell.lblCash.text  = strStardarPrice;
    [cell.btnCheckout addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureTravelCell:(CartTravelCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath wItem:(ProductObject *)item
{
    cell.tfQuantity.tag = indexPath.row * 100;
    cell.btnPlus.tag = indexPath.row * 100+1;
    cell.btnMinus.tag = indexPath.row * 100+2;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    cell.lblTitle.text = item.strTitle;
    cell.tfQuantity.delegate = self;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    float calculatePercent = (1-(float)((float)item.lDiscountPrice/(float)item.lStandarPrice)) *100;
    cell.lblPercentage.text = F(@"%.0f%%", calculatePercent);
    
    cell.starRating.backgroundColor = [UIColor clearColor];
    //        cell.starRating.rating =  item.iRate ;
    cell.starRating.rating = 4;
    cell.starRating.userInteractionEnabled = NO;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strStardarPrice length], 1)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.lblStandarPrice.attributedText = attributedString2;
    [cell.lblStandarPrice sizeToFit];
    //        cell.lblNumOfBook.text = F(@"%d",23595);
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    //        strDiscountPrice = F(@"%@đ", strDiscountPrice);
    attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strDiscountPrice) attributes:nil];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strDiscountPrice length], 1)];
    
    cell.lblDiscountPrice.attributedText = attributedString2;
    cell.lblTitle.text = item.strTitle;
    
    [cell.btnDestroy addTarget:self action:@selector(destroyItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDestroy.tag = indexPath.row  + 999;
    
    [cell.btnFromDate addTarget:self action:@selector(datePickerViewFrom:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnFromDate.tag = indexPath.row*50;
    
    [cell.btnTodate addTarget:self action:@selector(datePickerViewTo:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnTodate.tag = indexPath.row*50 + 1;
}


- (void)configureNormalCell:(CartDealCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath wItem:(ProductObject *)item
{
    int iSetTag = (indexPath.row +1) * 100;
    cell.tfQuantity.tag = iSetTag;
    cell.btnMinus.tag = iSetTag+1;
    cell.btnPlus.tag = iSetTag+2;
    [cell.btnMinus addTarget:self action:@selector(minusQuantity:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusQuantity:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    cell.lblTitle.text = item.strTitle;
    cell.tfQuantity.delegate = self;
    cell.tfQuantity.text = F(@"%d",item.iCurrentQuantity);
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.row % 3 == 0) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/714/151493-BUFFET-NHAT-SLIDE-_(1).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 1) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/755/166986-mat-lanh-ngay-he-cung-moon-galeto-crem-slide_(4).jpg"] placeholderImage:nil];
    }
    if (indexPath.row % 3 == 2) {
        [cell.imgLogo sd_setImageWithURL:[NSURL URLWithString:@"http://images.hotdeals.vn/images/detailed/754/79692_slide__(3).jpg"] placeholderImage:nil];
    }
    float calculatePercent = (1-(float)((float)item.lDiscountPrice/(float)item.lStandarPrice)) *100;
    cell.lblPercentage.text = F(@"%.0f%%", calculatePercent);
    
    cell.starRating.backgroundColor = [UIColor clearColor];
    //        cell.starRating.rating =  item.iRate ;
    cell.starRating.rating = 4;
    cell.starRating.userInteractionEnabled = NO;
    NSString * strStardarPrice = F(@"%ld", item.lStandarPrice);
    strStardarPrice = [strStardarPrice formatStringToDecimal];
    NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strStardarPrice) attributes:attributes];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strStardarPrice length], 1)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.lblStandarPrice.attributedText = attributedString2;
    [cell.lblStandarPrice sizeToFit];
    //        cell.lblNumOfBook.text = F(@"%d",23595);
    
    NSString * strDiscountPrice = F(@"%ld", item.lDiscountPrice);
    strDiscountPrice = [strDiscountPrice formatStringToDecimal];
    //        strDiscountPrice = F(@"%@đ", strDiscountPrice);
    attributedString2 = [[NSMutableAttributedString alloc] initWithString:F(@"%@đ",strDiscountPrice) attributes:nil];
    [attributedString2 setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:10]
                                       , NSBaselineOffsetAttributeName : @5} range:NSMakeRange([strDiscountPrice length], 1)];
    
    cell.lblDiscountPrice.attributedText = attributedString2;
    cell.lblTitle.text = item.strTitle;
    
    [cell.btnDestroy addTarget:self action:@selector(destroyItem:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDestroy.tag = indexPath.row  + 999;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [arrProduct count]+1) {
        InvoiceCell *cell = (InvoiceCell *)[tableView dequeueReusableCellWithIdentifier:@"InvoiceCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InvoiceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
        
    }
    if (indexPath.row == [arrProduct count]) {
        CartTravelCell *cell = (CartTravelCell *)[tableView dequeueReusableCellWithIdentifier:@"CartTravelCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartTravelCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        ProductObject * item = [arrProduct objectAtIndex:indexPath.row - 1];
        [self configureTravelCell:cell forRowAtIndexPath:indexPath wItem:item];
        return cell;
        
    }
    else
    {
        static NSString *simpleTableIdentifier = @"CartDealCell";
        ProductObject * item = [arrProduct objectAtIndex:indexPath.row];
        CartDealCell *cell = (CartDealCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CartDealCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [self configureNormalCell:cell forRowAtIndexPath:indexPath wItem:item];
        return cell;
    }
}

#pragma mark Logictic
-(int)calculateCash
{
    int i = 0;
    for (ProductObject * iObject in arrProduct) {
        i += iObject.lDiscountPrice * iObject.iCurrentQuantity;
    }
    return i;
}

-(void)destroyItem:(id)sender
{
    UIButton * btnSelected = (UIButton *)sender;
    UA_log(@"%ld",btnSelected.tag);
    int iIndexRow = (int)btnSelected.tag - 999;
    
    ProductObject * productObj = [arrProduct objectAtIndex:iIndexRow];
    [arrProduct removeObject:productObj];
    [[TKDatabase sharedInstance]removeProduct:productObj.strProductID];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notiDealCount" object:nil];
    if ([arrProduct count] == 0) {
        tableViewProduct.hidden = YES;
        UIView * viewEmpty = [[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth - 20, 30)];
        UILabel * lblEmpty = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, ScreenWidth - 20, 20)];
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

-(void)checkout
{
    NSMutableArray * arrProducts = [[NSMutableArray alloc]init];
    for (ProductObject * item in arrProduct) {
        NSDictionary * dictItem = [NSDictionary dictionaryWithObjectsAndKeys:item.strProductID,@"product_id",[NSNumber numberWithInt:item.iCurrentQuantity],@"quantity", nil];
        [arrProducts addObject:dictItem];
    }
    PaymentViewController * paymentVC = [[PaymentViewController alloc]init];
    paymentVC.arrProduct = arrProducts;
    [self.navigationController pushViewController:paymentVC animated:YES];
}

-(void)minusQuantity:(UIButton *)sender
{
    int iTag = sender.tag;
    int iRowAtIndex = (iTag - 1)/100 -1;
//    update object ...
    ProductObject * pObject = [arrProduct objectAtIndex:iRowAtIndex];
    CartDealCell *cell = (CartDealCell *)sender.superview.superview;
    int iNum = [cell.tfQuantity.text intValue];
    if (iNum == 0) {
        return;
    }
    iNum = iNum - 1;
    cell.tfQuantity.text = F(@"%d", iNum);
    UA_log(@"btn minus at index: %d", iRowAtIndex);
    pObject.iCurrentQuantity = iNum;
    [arrProduct removeObjectAtIndex:iRowAtIndex];
    [arrProduct insertObject:pObject atIndex:iRowAtIndex];
    
    NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:0];
    [self.tableViewProduct beginUpdates];
    [self.tableViewProduct reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableViewProduct endUpdates];
    
}

-(void)plusQuantity:(UIButton *)sender
{
    int iTag = sender.tag;
    int iRowAtIndex = (iTag - 2)/100 -1;
    //    update object ...
    ProductObject * pObject = [arrProduct objectAtIndex:iRowAtIndex];
    
//    [ProductList insertObject:prod atIndex:i];
    CartDealCell *cell = (CartDealCell *)sender.superview.superview;
    int iNum = [cell.tfQuantity.text intValue];
    iNum = iNum + 1;
    pObject.iCurrentQuantity = iNum;
    [arrProduct removeObjectAtIndex:iRowAtIndex];
    [arrProduct insertObject:pObject atIndex:iRowAtIndex];
//    cell.tfQuantity.text = F(@"%d", iNum);
    [tableViewProduct reloadData];
    UA_log(@"btn minus at index: %d", iRowAtIndex);
    NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:0];
    [self.tableViewProduct beginUpdates];
    [self.tableViewProduct reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableViewProduct endUpdates];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    [self.tableViewProduct scrollToRowAtIndexPath:[self.tableViewProduct indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark picker
- (void)datePickerViewFrom:(UIButton *)sender
{
    [self.view endEditing:YES];
    UA_log(@"%d", sender.tag);
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Ngày nhận phòng" delegate:self];
    [picker setTag:sender.tag];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}
- (void)datePickerViewTo:(UIButton *)sender
{
    [self.view endEditing:YES];
        UA_log(@"%d", sender.tag);
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Ngày trả phòng" delegate:self];
    [picker setTag:sender.tag];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    int iTag = pickerView.tag;
    if (iTag %50 == 0) {//from date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSString *prettyVersion = [dateFormat stringFromDate:date];//-> update arr
        
        int iRowAtIndex = iTag/50;
        NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:0];
//        [self.tableViewProduct beginUpdates];
        CartTravelCell *cell = (CartTravelCell*)[self.tableViewProduct cellForRowAtIndexPath:sibling];
        [cell.btnFromDate setTitle:F(@"%@",prettyVersion) forState:UIControlStateNormal];
//        [self.tableViewProduct reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableViewProduct endUpdates];
    }
    if (iTag %50 == 1) {//to date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        NSString *prettyVersion = [dateFormat stringFromDate:date];//-> update arr
        
        int iRowAtIndex = (iTag - 1)/50;
        NSIndexPath *sibling = [NSIndexPath indexPathForRow:iRowAtIndex inSection:0];
        CartTravelCell *cell = (CartTravelCell*)[self.tableViewProduct cellForRowAtIndexPath:sibling];
        [cell.btnTodate setTitle:F(@"%@",prettyVersion) forState:UIControlStateNormal];
        
//        [self.tableViewProduct beginUpdates];
//        [self.tableViewProduct reloadRowsAtIndexPaths:@[sibling] withRowAnimation:UITableViewRowAnimationNone];
//        [self.tableViewProduct endUpdates];
    }
}

@end
