//
//  PaymentViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PaymentViewController.h"
#import "TKDatabase.h"
#import "AppDelegate.h"
#import "AutoSizeTableViewCell.h"
#import "BookSuccessViewController.h"

@interface PaymentViewController ()
@property (nonatomic, strong) AutoSizeTableViewCell *prototypeCell;
@end

@implementation PaymentViewController
{
    UITextView* tvDescription;
    UIButton* btnPayment;
     MBProgressHUD *HUD;
    __block NSDictionary * dictRespone;
    NSString * strAddressL;
    NSString * strPaymentMethod;
    NSString * strShippingMethod;
    MethodObject * paymentMethod;
    MethodObject * shippingMethod;
}
@synthesize tablePayment;
@synthesize arrProduct;
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initHUD];
    [self initNavigationbar];
    [self initUITableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}

-(void)initUITableView
{
    tablePayment = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 66 - 40) style:UITableViewStylePlain];
    [self.view addSubview:tablePayment];
    tablePayment.backgroundColor = [UIColor whiteColor];
    tablePayment.dataSource = self;
    tablePayment.delegate = self;
    tablePayment.separatorColor = [UIColor clearColor];
    tablePayment.showsVerticalScrollIndicator = NO;
    tablePayment.sectionHeaderHeight = 0.0;
    tablePayment.scrollEnabled = NO;
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thanh toán"];
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 60;
    }
    if (indexPath.section == 3) {
        return 60;
    }
    else
    {
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    // (7)
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    //    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    // (8)
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    // (9)
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(void)initData
{
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSString * strParam = F(@"user_id=%@",user.user_id);
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequest:strParam withURL:URL_GET_USERINFO completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        dictRespone = dict;
        NSDictionary * dictAddress = [dict objectForKey:@"address"];
        NSDictionary * dictWard = [dictAddress objectForKey:@"s_ward"];
        NSDictionary * dictDictrict = [dictAddress objectForKey:@"s_district"];
        NSDictionary * dictState = [dictAddress objectForKey:@"s_state"];
        NSString * floorOptional = F(@"Lầu: %@",[dictAddress objectForKey:@"s_address_note"]);
        if ([dict objectForKey:@"fullname"] == nil || ![[dict objectForKey:@"fullname"] isEqualToString:@""]) {
            strAddressL = @"";
        }
        else if ([dict objectForKey:@"phone"] == nil || ![[dict objectForKey:@"phone"] isEqualToString:@""]) {
            strAddressL = @"";
        }
        else
            if ([dictState objectForKey:@"name"] == nil || ![[dictState objectForKey:@"name"] isEqualToString:@""]) {
                strAddressL = @"";
            }
            else
                if ([dictState objectForKey:@"name"] == nil || ![[dictState objectForKey:@"name"] isEqualToString:@""]) {
                    strAddressL = @"";
                }
                else
                {
                    strAddressL = F(@"%@\n%@\n%d %@ %@ %@ %@", [dict objectForKey:@"fullname"],[dict objectForKey:@"phone"],[[dictAddress objectForKey:@"s_address"]intValue],[dictWard objectForKey:@"name"],[dictDictrict objectForKey:@"name"],[dictState objectForKey:@"name"], floorOptional);
                }
        UA_log(@"%@", dict);
    }];

}
- (void)configureCell:(AutoSizeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"Địa chỉ giao hàng";
        if ([strAddressL isEqualToString:@""] || strAddressL == nil) {
            cell.desLabel.text = @"\n\n";
        }
        else
            cell.desLabel.text = F(@"%@\n\n",strAddressL);
    }
    if (indexPath.section == 1) {
        cell.titleLabel.text = @"Hình thức thanh toán";
//        cell.desLabel.text = @"Bằng tiền mặt khi nhận hàng\n\n";//thay đổi
        strPaymentMethod = paymentMethod.strMethodName;
        if ([strPaymentMethod isEqualToString:@""] || strPaymentMethod == nil) {
            cell.desLabel.text = @"\n\n";
        }
        else
            cell.desLabel.text = F(@"%@\n\n",strPaymentMethod);
    }
    if (indexPath.section == 2) {
        cell.titleLabel.text = @"Hình thức giao hàng";
//        cell.desLabel.text = @"Bằng tiền mặt khi nhận hàng\n\n";//thay đổi
        strShippingMethod = shippingMethod.strMethodName;
        if ([strShippingMethod isEqualToString:@""] || strShippingMethod == nil) {
            cell.desLabel.text = @"\n\n";
        }
        else
            cell.desLabel.text = F(@"%@\n\n",strShippingMethod);
    }
    
//    if (indexPath.section == 2) {
//        cell.titleLabel.text = @"Địa chỉ nhận hàng";
//        cell.desLabel.text = @"Trần Tấn Kiệt\nĐTDĐ:0936459200\nYoco Building\n41, Nguyễn Thị Minh Khai, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh\n\n";
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel * lblTemp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 260, 0)];
    lblTemp.lineBreakMode = NSLineBreakByWordWrapping;
    lblTemp.numberOfLines = 0;
    lblTemp.text = cell.desLabel.text;
    if ([cell.desLabel.text isEqualToString:@""]) {
        lblTemp.text = @"\n";
    }
    lblTemp.font = [UIFont systemFontOfSize:12];
    [lblTemp sizeToFit];
    CGRect rect = lblTemp.frame;
    //    fHeightOfDescription = rect.size.height;
    
    //    UA_log(@"height desLabel : %f", rect.size.height );
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, rect.size.height + 15)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextView* tv = nil ;
        
        cellRe.textLabel.text = @"" ;
        tv = tvDescription = [self makeTextView:@"" placeholder:@"Ghi chú khi nhận hàng (nếu có)"];
        tv.textColor = [UIColor lightGrayColor];
        tv.frame = CGRectMake(10, 5, ScreenWidth - 20, 55);
                cellRe.contentView.backgroundColor = [UIColor clearColor];
//        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];

        [cellRe addSubview:tvDescription];
        return cellRe;
    }
    if (indexPath.section == 4) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton* button = nil ;
        
        button = btnPayment = [self makeButtonPayment];
        [cellRe addSubview:btnPayment];
        
        // Textfield dimensions
        button.frame = CGRectMake(10, 20, ScreenWidth - 20, 35);
                    cellRe.contentView.backgroundColor = [UIColor clearColor];
//        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        return cellRe;
    }
    else
    {
        AutoSizeTableViewCell *cell = (AutoSizeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AutoSizeTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureCell:cell forRowAtIndexPath:indexPath];
        
        return cell;
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Ghi chú khi nhận hàng (nếu có)"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Ghi chú khi nhận hàng (nếu có)";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(UITextView*) makeTextView: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextView *tv = [[UITextView alloc] init];
    tv.font = [UIFont systemFontOfSize:13];
    tv.layer.borderWidth = 0.5f;
    tv.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tv.text = placeholder ;
    tv.autocorrectionType = UITextAutocorrectionTypeNo ;
    tv.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tv.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tv.backgroundColor = [UIColor whiteColor];
    tv.delegate = self;
    tv.textColor = [UIColor lightGrayColor]; //optional
    return tv ;
}

-(UIButton*) makeButtonPayment{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"ĐẶT HÀNG" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(paymentClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)paymentClick
{
    if ([arrProduct count] == 0|| paymentMethod == nil|| shippingMethod == nil) {
        return;
    }
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSDictionary * dictParameter = [NSDictionary dictionaryWithObjectsAndKeys:user.user_id,@"user_id",paymentMethod.strMethodID,@"payment_method",shippingMethod.strMethodID, @"shipping_method",arrProduct, @"products", nil];
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:dictParameter withURL:URL_GET_USERINFO completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
    }];
    BookSuccessViewController * bookVC = [[BookSuccessViewController alloc]init];
    [self.navigationController pushViewController:bookVC animated:YES];
//    ALERT(@"Thong bao", @"Dat hang thanh cong");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        PaymentMethod * pMethod = [[PaymentMethod alloc]init];
        pMethod.delegate = self;
        [self.navigationController pushViewController:pMethod animated:YES];
    }
    if (indexPath.section == 2) {
        ShippingMethod * pMethod = [[ShippingMethod alloc]init];
         pMethod.delegate = self;
        [self.navigationController pushViewController:pMethod animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)updatePaymentMethod:(MethodObject *)methodObject
{
    paymentMethod = methodObject;
    [tablePayment reloadData];
}
-(void)updateShippingMethod:(MethodObject *)methodObject
{
    shippingMethod = methodObject;
        [tablePayment reloadData];
}
@end
