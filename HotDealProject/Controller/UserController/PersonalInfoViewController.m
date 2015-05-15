//
//  PersonalInfoViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "AppDelegate.h"
#import "TKDatabase.h"
@interface PersonalInfoViewController ()

@end
typedef enum {
    ProvinceCb,
    DistrictCb,
    PhuongXaCb,
    GenderCb
}ComboboxType;
@implementation PersonalInfoViewController
{
    UITextField* tfEmail;
    UITextField* tfFullname;
    UITextField* tfPhone;
    UILabel* lblBirthday;
    UILabel* lblGender;
    UIButton* btnSave;
    UIToolbar *toolbar;
    BOOL isBirthdayAction;
    
    UITextField* tfSoNha;
    UITextField* tfToaNha;
    UITextField* tfDuong;
    UILabel* lblTP;
    UILabel* lblQuanHuyen;
    UILabel* lblPhuongXa;
    ComboboxType cbType;
    MBProgressHUD *HUD;
    
    NSString * strEmail;
    NSString * strFullname;
    NSString * strBirthday;
    NSString * strSonha;
    NSString * strToaNha;
    NSString * strDuong;
    int  idTP;
    int  idQuanHuyen;
    int  idPhuongXa;
}
@synthesize pickerView;
@synthesize pickerGender;
//@synthesize tableViewInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    cbType = ProvinceCb;
    isBirthdayAction = TRUE;
    [self initHUD];
    [self initUITableView];
    [self setupPickerGender];
    [self makePicker];
    [self setupToolBar];
    // Do any additional setup after loading the view from its nib.
}

-(void)getUserInfo
{
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    user.user_id, @"user_id",
                                    nil];
    
    [HUD show:YES];
    [[TKAPI sharedInstance]getRequestAF:jsonDictionary withURL:URL_GET_USERINFO completion:^(NSDictionary * dict, NSError *error) {
        UA_log(@"%@",dict);
        [HUD hide:YES];
    }];
    
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self)
    {
        
    }
    return self;
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
    //    self.tableView.scrollEnabled = NO;
    //self.tableView.userInteractionEnabled;
}

-(void)closeKeyboard
{
    [self.view endEditing:YES];
}- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thông tin cá nhân"];
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
-(UIButton*) makeButtonSave{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"LƯU CHỈNH SỬA" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)saveClick
{
    UA_log(@"Save Click");
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
        pickerGender.hidden = YES;
        
    }
    else
    {
        switch (cbType) {
            case GenderCb:
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
                pickerView.hidden = YES;
                break;
            }
            case ProvinceCb:
            {
                lblTP.text = @"  ProvinceCb";
                pickerGender.hidden = YES;
                toolbar.hidden = YES;
                pickerView.hidden = YES;
                lblGender.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                break;
            }
            case DistrictCb:
            {
                lblQuanHuyen.text = @"  DistrictCb";
                pickerGender.hidden = YES;
                toolbar.hidden = YES;
                pickerView.hidden = YES;
                lblGender.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                break;
            }
            case PhuongXaCb:
            {
                lblPhuongXa.text = @"  PhuongXaCb";
                pickerGender.hidden = YES;
                toolbar.hidden = YES;
                pickerView.hidden = YES;
                lblGender.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                break;
            }
            default:
                break;
        }
        
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
    pickerGender.hidden = YES;
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


-(void)showDropbox1
{
    isBirthdayAction = NO;
    pickerGender.hidden = NO;
    toolbar.hidden = NO;
    cbType = GenderCb;
}
-(void)showDropbox3
{
    //    UA_log(@"");
    [self showDropbox1];
    cbType = ProvinceCb;
}
-(void)showDropbox4
{
    //    UA_log(@"");
    [self showDropbox1];
    cbType = DistrictCb;
}
-(void)showDropbox5
{
    //        UA_log(@"");
    [self showDropbox1];
    cbType = PhuongXaCb;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField* tf = nil ;
        UILabel* lbl = nil ;
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
                tf = tfFullname = [self makeTextField:@"" placeholder:@"Họ tên"];
                [cellRe addSubview:tfFullname];
                break ;
            }
            case 2: {
                cellRe.textLabel.text = @"" ;
                tf = tfPhone = [self makeTextField:@"" placeholder:@"Điện thoại di động"];
                [cellRe addSubview:tfPhone];
                break ;
            }
            case 3: {
                
                cellRe.textLabel.text = @"" ;
                lbl = lblBirthday = [self makeLabel:@"  Ngày sinh"];
                [cellRe addSubview:lbl];
                UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                [cellRe addSubview:imgArrow];
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
                // if labelView is not set userInteractionEnabled, you must do so
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                break ;
            }
            case 4: {
                
                //                    cell.textLabel.text = @"Ngày sinh" ;
                lbl = lblGender = [self makeLabel:@"  Giới tính"];
                [cellRe addSubview:lbl];
                UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                [cellRe addSubview:imgArrow];
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox1)];
                // if labelView is not set userInteractionEnabled, you must do so
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                break ;
            }
        }
        
        // Textfield dimensions
        tf.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        //        cell.contentView.backgroundColor = [UIColor clearColor];
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
        UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 38, ScreenWidth - 40, 2)];
        imgLine.image = [UIImage imageNamed:@"gach"];
        [cellRe.contentView addSubview:imgLine];
        
        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        
        //        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
        //        // if labelView is not set userInteractionEnabled, you must do so
        //        [lbl setUserInteractionEnabled:YES];
        //        [lbl addGestureRecognizer:gesture];
        return cellRe;
    }
    //    if (indexPath.section == 1)
    //    {
    //        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //
    //        // Make cell unselectable
    //        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
    //        UILabel* lbl = nil ;
    //        switch ( indexPath.row ) {
    //            case 0: {
    //
    //                cellRe.textLabel.text = @"" ;
    //                lbl = lblBirthday = [self makeLabel:@"  Ngày sinh"];
    //                [cellRe addSubview:lbl];
    //                break ;
    //            }
    //        }
    //
    //        // Textfield dimensions
    //        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
    //        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    //
    //        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
    //        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
    //        [cellRe addSubview:imgArrow];
    //        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicker)];
    //        // if labelView is not set userInteractionEnabled, you must do so
    //        [lbl setUserInteractionEnabled:YES];
    //        [lbl addGestureRecognizer:gesture];
    //
    //        return cellRe;
    //
    //    }
    //    if (indexPath.section == 2)
    //    {
    //        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    //
    //        // Make cell unselectable
    //        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
    //        UILabel* lbl = nil ;
    //        switch ( indexPath.row ) {
    //            case 0: {
    //
    //                //                    cell.textLabel.text = @"Ngày sinh" ;
    //                lbl = lblGender = [self makeLabel:@"  Giới tính"];
    //                [cellRe addSubview:lbl];
    //                break ;
    //            }
    //        }
    //
    //        // Textfield dimensions
    //        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
    //        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    //
    //        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox)];
    //        // if labelView is not set userInteractionEnabled, you must do so
    //        [lbl setUserInteractionEnabled:YES];
    //        [lbl addGestureRecognizer:gesture];
    //        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
    //        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
    //        [cellRe addSubview:imgArrow];
    //
    //        return cellRe;
    //
    //    }
    if (indexPath.section == 1) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField* tf = nil ;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                cellRe.textLabel.text = @"" ;
                tf = tfSoNha = [self makeTextField:@"" placeholder:@"Số nhà"];
                tf.textColor = [UIColor lightGrayColor];
                [cellRe addSubview:tfSoNha];
                break ;
            }
            case 1: {
                cellRe.textLabel.text = @"" ;
                tf = tfToaNha = [self makeTextField:@"" placeholder:@"Toà nhà (lầu)"];
                [cellRe addSubview:tfToaNha];
                break ;
            }
            case 2: {
                cellRe.textLabel.text = @"" ;
                tf = tfDuong = [self makeTextField:@"" placeholder:@"Tên đường"];
                [cellRe addSubview:tfDuong];
                break ;
            }
            case 3:
            {
                
                cellRe.textLabel.text = @"" ;
                lbl = lblTP = [self makeLabel:@"  Tỉnh / Thành phố"];
                [cellRe addSubview:lbl];
                // Textfield dimensions
                UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                [cellRe addSubview:imgArrow];
                
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox3)];
                // if labelView is not set userInteractionEnabled, you must do so
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                break ;
            }
                
            case   4:
            {
                
                cellRe.textLabel.text = @"" ;
                lbl = lblQuanHuyen = [self makeLabel:@"  Quận / Huyện"];
                [cellRe addSubview:lbl];
                // Textfield dimensions
                UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                [cellRe addSubview:imgArrow];
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox4)];
                // if labelView is not set userInteractionEnabled, you must do so
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                break ;
            }
                
            case  5: {
                
                cellRe.textLabel.text = @"" ;
                lbl = lblPhuongXa = [self makeLabel:@"  Phường / Xã"];
                [cellRe addSubview:lbl];
                // Textfield dimensions
                UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                [cellRe addSubview:imgArrow];
                
                UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox5)];
                // if labelView is not set userInteractionEnabled, you must do so
                [lbl setUserInteractionEnabled:YES];
                [lbl addGestureRecognizer:gesture];
                break ;
            }
                
        }
        
        // Textfield dimensions
        tf.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        //        cell.contentView.backgroundColor = [UIColor clearColor];
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        // We want to handle textFieldDidEndEditing
        tf.delegate = self ;
        UIImageView * imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 38, ScreenWidth - 40, 2)];
        imgLine.image = [UIImage imageNamed:@"gach"];
        [cellRe.contentView addSubview:imgLine];
        
        
        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        
        
        
        
        return cellRe;
        
    }
    else//btnRegister
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton* button = nil ;
        
        button = btnSave = [self makeButtonSave];
        [cellRe addSubview:btnSave];
        
        // Textfield dimensions
        button.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        return cellRe;
        
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 5;
    }
    if (section == 1) {
        return 6;
    }
    return 1;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
@end
