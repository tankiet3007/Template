//
//  RegisAndLoginController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/24/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "RegisAndLoginController.h"
#import "CellObject.h"
#import "SWRevealViewController.h"
#import "InvoiceCell.h"
#import "LoginCell.h"
#import "ForgotPasswordViewController.h"

@interface RegisAndLoginController ()

@end

@implementation RegisAndLoginController
{
    SWRevealViewController *revealController;
    LoginCell *cell;
    UISegmentedControl *segmentedControl;
    UIView * viewHeader;
    BOOL isLoginFrame;
    UITextField* tfEmail;
    UITextField* tfPassword;
    UITextField* tfConfirmPassword;
    UITextField* tfFullname;
    UITextField* tfPhone;
    UILabel* lblBirthday;
    UILabel* lblGender;
    UIButton* btnRegister;
    UIToolbar *toolbar;
    BOOL isBirthdayAction;
}
@synthesize pickerView;
@synthesize pickerGender;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    isLoginFrame = TRUE;
    
    [self setupSegment];
    isBirthdayAction = TRUE;
    [self initUITableView];
    [self setupPickerGender];
    [self makePicker];
    [self setupToolBar];
    // Do any additional setup after loading the view.
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self)
    {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initUITableView
{
    //    tableViewMain = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40) style:UITableViewStyleGrouped];
    //    [self.view addSubview:tableViewMain];
    
    
    //    [tableViewDays setDragDelegate:self refreshDatePermanentKey:@"HotNewsList"];
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    [tableViewMain setBounces:NO];
    //    tableViewMain.separatorColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 0.0;
    
    UISwipeGestureRecognizer *topToBottom=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    topToBottom.direction=UISwipeGestureRecognizerDirectionDown;
    
    [self.tableView addGestureRecognizer:topToBottom];
    self.tableView.scrollEnabled = NO;
    self.tableView.userInteractionEnabled = NO;
}

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (velocity.y > 0){
        NSLog(@"up");
    }
    if (velocity.y < 0){
        NSLog(@"down");
        [self closeKeyboard];
    }
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
    label.text = NSLocalizedString(@"Đăng nhập", @"");
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
#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoginFrame == TRUE) {
        return  1;
    }
    else
    {
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoginFrame == TRUE) {
        return 1;
    }
    else
    {
        if (section == 0) {
            return 5;
        }
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLoginFrame == TRUE) {
        return ScreenHeight-80;
    }
    else
    {
        return 50;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLoginFrame == TRUE) {
        cell = (LoginCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureCell:cell forRowAtIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        return cell;
    }
    else
    {
        if (indexPath.section == 0) {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UITextField* tf = nil ;
            switch ( indexPath.row ) {
                case 0: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfEmail = [self makeTextField:@"" placeholder:@"Địa chỉ email"];
                    tf.textColor = [UIColor lightGrayColor];
                    [cellRe addSubview:tfEmail];
                    break ;
                }
                case 1: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfPassword = [self makeTextField:@"" placeholder:@"Mật khẩu"];
                    [cellRe addSubview:tfPassword];
                    break ;
                }
                case 2: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfConfirmPassword = [self makeTextField:@"" placeholder:@"Nhập lại mật khẩu"];
                    [cellRe addSubview:tfConfirmPassword];
                    break ;
                }
                case 3: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfFullname = [self makeTextField:@"" placeholder:@"Họ tên"];
                    [cellRe addSubview:tfFullname];
                    break ;
                }
                case 4: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfPhone = [self makeTextField:@"" placeholder:@"Điện thoại di động"];
                    [cellRe addSubview:tfPhone];
                    break ;
                }
            }
            
            // Textfield dimensions
            tf.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            //        cell.contentView.backgroundColor = [UIColor clearColor];
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            // We want to handle textFieldDidEndEditing
            tf.delegate = self ;
            UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 38, ScreenWidth - 40, 2)];
            imgLine.image = [UIImage imageNamed:@"gach"];
            [cellRe.contentView addSubview:imgLine];
            
            return cellRe;
        }
        if (indexPath.section == 1)
        {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* lbl = nil ;
            switch ( indexPath.row ) {
                case 0: {
                    
                    cellRe.textLabel.text = @"" ;
                    lbl = lblBirthday = [self makeLabel:@"  Ngày sinh"];
                    [cellRe addSubview:lbl];
                    break ;
                }
            }
            
            // Textfield dimensions
            lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
            // if labelView is not set userInteractionEnabled, you must do so
            [lbl setUserInteractionEnabled:YES];
            [lbl addGestureRecognizer:gesture];
            
            return cellRe;
            
        }
        if (indexPath.section == 2)
        {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* lbl = nil ;
            switch ( indexPath.row ) {
                case 0: {
                    
                    //                    cell.textLabel.text = @"Ngày sinh" ;
                    lbl = lblGender = [self makeLabel:@"  Giới tính"];
                    [cellRe addSubview:lbl];
                    break ;
                }
            }
            
            // Textfield dimensions
            lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox)];
            // if labelView is not set userInteractionEnabled, you must do so
            [lbl setUserInteractionEnabled:YES];
            [lbl addGestureRecognizer:gesture];
            
            return cellRe;
            
        }
        else//btnRegister
        {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton* button = nil ;
            
            button = btnRegister = [self makeButtonRegister];
            [cellRe addSubview:btnRegister];
            
            // Textfield dimensions
            button.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
             cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            return cellRe;
            
        }
    }
    
}

-(UILabel*) makeLabel: (NSString*)text{
    UILabel *tf = [[UILabel alloc] init];
    tf.textColor = [UIColor colorWithWhite: 0.70 alpha:1];
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = text ;
    
    tf.userInteractionEnabled = YES;
    tf.font = [UIFont systemFontOfSize:13];
    return tf ;
}

-(UIButton*) makeButtonRegister{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Đăng ký" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)registerClick
{
    UA_log(@"register");
}

- (void)configureCell:(LoginCell *)lcell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = [UIColor grayColor];
    lcell.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    lcell.tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfEmail.delegate = self;
    lcell.tfPassword.delegate = self;
    
    lcell.tfEmail.borderStyle = UITextBorderStyleNone;
    lcell.tfPassword.borderStyle = UITextBorderStyleNone;
    
    lcell.tfPassword.textColor = [UIColor darkGrayColor];
    lcell.tfEmail.textColor = [UIColor darkGrayColor];
    lcell.tfEmail.returnKeyType = UIReturnKeyNext;
    lcell.tfPassword.returnKeyType = UIReturnKeyDone;
    lcell.tfPassword.secureTextEntry  = YES;
    [lcell.btnLogin addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
 
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    lcell.tfEmail.leftView = paddingView;
    lcell.tfEmail.leftViewMode = UITextFieldViewModeAlways;
    
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    lcell.tfPassword.leftView = paddingView;
    lcell.tfPassword.leftViewMode = UITextFieldViewModeAlways;
    
    [lcell.btnForgotPassword addTarget:self action:@selector(forgotPassClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)loginClick
{
    UA_log(@"%@ --- %@", cell.tfEmail.text, cell.tfPassword.text);
}
-(void)forgotPassClick
{
    ForgotPasswordViewController * forgotPass = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgotPass animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isLoginFrame == FALSE) {
        if (section == 0) {
            return 60;
        }
        return 0;
    }
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isLoginFrame == FALSE) {
        if (section == 0) {
            return viewHeader;
        }
        return nil;
    }
    return viewHeader;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(UIView *)setupSegment
{
    if (viewHeader != nil) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    if (segmentedControl != nil) {
        [segmentedControl removeFromSuperview];
        segmentedControl = nil;
    }
    NSArray *itemArray = [NSArray arrayWithObjects: @"Đăng nhập", @"Đăng ký", nil];
    CGRect myFrame = CGRectMake(60, 10, 200, 30);
    
    //create an intialize our segmented control
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    
    //set the size and placement
    segmentedControl.frame = myFrame;
    segmentedControl.tintColor = [UIColor darkGrayColor];
    [segmentedControl addTarget:self action:@selector(mySegmentControlAction) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    viewHeader.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    [viewHeader addSubview:segmentedControl];
    return viewHeader;
    
}

-(void)mySegmentControlAction
{
    UA_log(@"segment changed");
    if (segmentedControl.selectedSegmentIndex == 0) {
        cell.hidden = NO;
        isLoginFrame = TRUE;
            self.tableView.scrollEnabled = NO;
        [self.tableView reloadData];
    }
    else
    {
            self.tableView.scrollEnabled = YES;
        isLoginFrame = FALSE;
        cell.hidden = YES;
        [self.tableView reloadData];
    }
}
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextField *tf = [[UITextField alloc] init];
    tf.placeholder = placeholder ;
    tf.font = [UIFont systemFontOfSize:13];
    tf.text = text ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    tf.backgroundColor = [UIColor whiteColor];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    tf.leftView = paddingView;
    tf.leftViewMode = UITextFieldViewModeAlways;
    return tf ;
}
-(void)setupToolBar
{
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, pickerView.frame.origin.y - 44, pickerView.frame.size.width, 44)];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //    [barItems addObject:flexSpace];
    
    UIButton *button_done = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_done addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button_done setTitle:@"Đồng ý" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:button_done];
    button_done.frame = CGRectMake(0.0f,0.0f,70,44);
    //    [barItems addObject:doneBtn];
    
    UIButton *button_cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_cancel addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button_cancel setTitle:@"Hủy " forState:UIControlStateNormal];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithCustomView:button_cancel];
    button_cancel.frame = CGRectMake(0.0f,0.0f,70,44);
    //    [barItems addObject:cancelBtn];
    barItems = [NSMutableArray arrayWithObjects:cancelBtn, flexSpace, doneBtn, nil];
    
    toolbar.items = barItems;
    [self.view addSubview: toolbar];
    toolbar.hidden = YES;
}
-(void)doneButtonPressed:(id)sender{
    if (isBirthdayAction == TRUE) {
        NSDate *myDate = pickerView.date;
        NSDate *currentDate = [NSDate date];
        
        long year = currentDate.year -myDate.year ;
        if (year<15) {
            ALERT(LS(@"MessageBoxTitle"), @"Tuổi của bạn phải từ 15 trở lên");
            return;
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        
        NSString *prettyVersion = [dateFormat stringFromDate:myDate];
        
        lblBirthday.text =  F(@"  %@",prettyVersion);
        lblBirthday.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        pickerView.hidden = YES;
        toolbar.hidden = YES;
        
    }
    else
    {
        NSInteger  iIndex =  [pickerGender selectedRowInComponent:0];
        if (iIndex == 0) {
            lblGender.text = @"  Nam";
        }
        else
        {
            lblGender.text = @"  Nữ";
        }
        
        lblGender.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        pickerGender.hidden = YES;
        toolbar.hidden = YES;
    }
}



-(void)cancelButtonPressed:(id)sender{
    pickerGender.hidden = YES;
    pickerView.hidden = YES;
    toolbar.hidden = YES;
}

-(void)makePicker
{
    CGRect pickerFrame = CGRectMake(0,ScreenHeight - 162-60,0,0);
    
    pickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    pickerView.hidden = YES;
    [self.view addSubview:pickerView];
}

-(void)showPicker
{
    isBirthdayAction = TRUE;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.hidden = NO;
    toolbar.hidden = NO;
    
    NSDate *currentDate = [NSDate date];
    [pickerView setMaximumDate:currentDate];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return 2;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0 ) {
        return  @"Nam";
    }
    
    return  @"Nữ";
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = ScreenWidth- 20;
    
    return sectionWidth;
}

-(void)setupPickerGender
{
    pickerGender = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight -250, ScreenWidth, 200)];
    //    numRowsInPicker = 3;
    pickerGender.delegate = self;
    [pickerGender setBackgroundColor:[UIColor whiteColor]];
    pickerGender.showsSelectionIndicator = YES;
    pickerGender.hidden = YES;
    [self.view addSubview:pickerGender];
    
}
-(void)showDropbox
{
    isBirthdayAction = NO;
    pickerGender.hidden = NO;
    toolbar.hidden = NO;
}
@end
