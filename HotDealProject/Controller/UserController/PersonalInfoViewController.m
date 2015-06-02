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
     MBProgressHUD *HUD;
}
@synthesize pickerView;
@synthesize pickerGender;
@synthesize tableViewInfo;
@synthesize dictResponse;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    isBirthdayAction = TRUE;
    [self initUITableView];
    [self setupPickerGender];
    [self makePicker];
    [self setupToolBar];
    [self initHUD];
    // Do any additional setup after loading the view from its nib.
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD hide:YES];
}

-(void)initUITableView
{
    tableViewInfo = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40) style:UITableViewStyleGrouped];
    [self.view addSubview:tableViewInfo];
    
    tableViewInfo.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    tableViewInfo.dataSource = self;
    tableViewInfo.delegate = self;
    //    [tableViewMain setBounces:NO];
    //    tableViewMain.separatorColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    tableViewInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewInfo.showsVerticalScrollIndicator = NO;
    tableViewInfo.sectionHeaderHeight = 0.0;
    
    UISwipeGestureRecognizer *topToBottom=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    topToBottom.direction=UISwipeGestureRecognizerDirectionDown;
    
    [tableViewInfo addGestureRecognizer:topToBottom];
}
-(void)closeKeyboard
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
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
    NSString * email = tfEmail.text;
    NSString * fullname = tfFullname.text;
    NSString * phone = tfPhone.text;
    NSString * birthday = [lblBirthday.text trim];
    NSString * gender = [lblGender.text trim];//1 nam 2 nu
    if ([gender isEqualToString:@"Nam"]) {
        gender = @"1";
    }
    else
    {
        gender = @"2";
    }
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSDictionary * address = [dictResponse objectForKey:@"address"];
    NSDictionary * dictFinal = [NSDictionary dictionaryWithObjectsAndKeys:user.user_id,@"user_id",gender, @"gender",email,@"email", fullname, @"fullname",phone, @"phone", birthday,@"birthday",address, @"address", nil];
    UA_log(@"%@", dictFinal);
    
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:dictFinal withURL:URL_UPDATE_USER completion:^(NSDictionary *dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        BOOL response = [[dict objectForKey:@"response"]boolValue];
        if (response == TRUE) {
             ALERT(LS(@"MessageBoxTitle"), @"Thay đổi thông tin thành công");
            [self.delegate updateInfo];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSString * response = [dict objectForKey:@"reason"];
            ALERT(LS(@"MessageBoxTitle"),response);
        }
    }];

}
-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
    UITextField *tf = [[UITextField alloc] init];
    text = [text trim];
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
        [self.view endEditing:YES];
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
    [self.view endEditing:YES];
    isBirthdayAction = NO;
    pickerGender.hidden = NO;
    toolbar.hidden = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField* tf = nil ;
        switch ( indexPath.row ) {
            case 0: {
                cellRe.textLabel.text = @"" ;
                tf = tfEmail = [self makeTextField:[dictResponse objectForKey:@"email"] placeholder:@"Địa chỉ email"];
                //                tf.textColor = [UIColor lightGrayColor];
                [cellRe addSubview:tfEmail];
                break ;
            }
            case 1: {
                cellRe.textLabel.text = @"" ;
                tf = tfFullname = [self makeTextField:[dictResponse objectForKey:@"fullname"] placeholder:@"Họ tên"];
                [cellRe addSubview:tfFullname];
                break ;
            }
            case 2: {
                cellRe.textLabel.text = @"" ;
                tf = tfPhone = [self makeTextField:[dictResponse objectForKey:@"phone"] placeholder:@"Điện thoại di động"];
                [cellRe addSubview:tfPhone];
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
                NSString * strBirthday = [dictResponse objectForKey:@"birthday"];
                if (strBirthday != nil && ![strBirthday isEqualToString:@""]) {
                    lbl = lblBirthday = [self makeLabel:F(@"  %@",strBirthday)];
                    lbl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                }
                else
                {
                    lbl = lblBirthday = [self makeLabel:@"  Ngày sinh"];
                }
                [cellRe addSubview:lbl];
                break ;
            }
        }
        
        // Textfield dimensions
        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        
        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
        [cellRe addSubview:imgArrow];
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
                
                NSString * strGender = [dictResponse objectForKey:@"gender"];
                if ([strGender intValue] == 1) {
                    strGender = @"Nam";
                }
                if ([strGender intValue] == 2) {
                    strGender = @"Nữ";
                }
                if (strGender != nil && ![strGender isEqualToString:@""]) {
                    lbl = lblGender = [self makeLabel:F(@"  %@",strGender)];
                    lbl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                }
                else
                {
                    lbl = lblGender = [self makeLabel:@"  Giới tính"];
                }
                [cellRe addSubview:lbl];
                break ;
            }
        }
        
        // Textfield dimensions
        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 39);
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox)];
        // if labelView is not set userInteractionEnabled, you must do so
        [lbl setUserInteractionEnabled:YES];
        [lbl addGestureRecognizer:gesture];
        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
        [cellRe addSubview:imgArrow];
        
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
        return 3;
    }
    return 1;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   return [textField resignFirstResponder];
}

@end
