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
@interface PaymentViewController ()
@property (nonatomic, strong) AutoSizeTableViewCell *prototypeCell;
@end

@implementation PaymentViewController
{
    UITextView* tvDescription;
    UIButton* btnPayment;
}
@synthesize tablePayment;
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }
}
-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thanh toán"];
}

#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  4;
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

- (void)configureCell:(AutoSizeTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"Địa chỉ giao hàng";
        cell.desLabel.text = @"Trần Tấn Kiệt\nĐTDĐ:0936459200\nYoco Building\n41, Nguyễn Thị Minh Khai, Phường Bến Nghé, Quận 1, TP Hồ Chí Minh\n\n";
    }
    if (indexPath.section == 1) {
        cell.titleLabel.text = @"Hình thức thanh toán";
        cell.desLabel.text = @"Bằng tiền mặt khi nhận hàng\n\n";//thay đổi
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
    UIView * viewBG = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, rect.size.height + 15)];
    [cell.contentView insertSubview:viewBG atIndex:0];
    viewBG.layer.borderWidth = 0.5;
    viewBG.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextView* tv = nil ;
        
        cellRe.textLabel.text = @"" ;
        tv = tvDescription = [self makeTextView:@"" placeholder:@"Ghi chú khi nhận hàng (nếu có)"];
        tv.textColor = [UIColor lightGrayColor];
        tv.frame = CGRectMake(10, 5, 300, 55);
                cellRe.contentView.backgroundColor = [UIColor clearColor];
//        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];

        [cellRe addSubview:tvDescription];
        return cellRe;
    }
    if (indexPath.section == 3) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton* button = nil ;
        
        button = btnPayment = [self makeButtonPayment];
        [cellRe addSubview:btnPayment];
        
        // Textfield dimensions
        button.frame = CGRectMake(10, 20, 300, 35);
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
    ALERT(@"Thong bao", @"Dat hang thanh cong");
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
