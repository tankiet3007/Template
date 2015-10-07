//
//  SignUpViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/19/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginCell.h"
#import "InfomationCell.h"
#import "AppDelegate.h"
#import "IQActionSheetPickerView.h"
#import "TKDatabase.h"
@interface SignUpViewController ()<IQActionSheetPickerViewDelegate>

@end

@implementation SignUpViewController
{
    MBProgressHUD *HUD;
    UIButton * buttonDate;
    UIButton * buttonGender;
    UIButton * buttonState;
    UIButton * buttonDistrict;
    UIButton * buttonWard;
    UIButton * buttonDone;
    
    UITextField * tfEmail;
    UITextField * tfPassword;
    UITextField * tfConfirmPassword;
    UITextField * tfFullname;
    UITextField * tfAddress;
    UITextField * tfStreet;
    UITextField * tfStair;
    UITextField * tfPhone;
    NSString * strDateOfBirth;
    NSString * strGender;
    
    NSArray * arrState;
    NSArray * arrDistrict;
    NSArray * arrWard;
    
    State * stateSelected;
    District * districtSelected;
    Ward * wardSelected;
}
@synthesize tableView;
-(void)initUITableView
{
    tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-120) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.sectionHeaderHeight = 0.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar:@"Đăng ký"];
    [self initUITableView];
    arrState = [NSMutableArray new];
    arrState = [[TKAPI sharedInstance]getAllState];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initNavigationbar:(NSString *)strTitle
{
//    AppDelegate * appdelegate = ApplicationDelegate;
//    [appdelegate initNavigationbar:self withTitle:strTitle];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.font = [UIFont fontWithName:@"Roboto-Bold" size:20];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = strTitle;
    [label sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark configureCell
- (void)configureCell:(LoginCell *)lcell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = [UIColor blackColor];
    if (tfEmail == nil) {
        lcell.tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
        lcell.tfEmail.delegate = self;
        lcell.tfEmail.textColor = [UIColor blackColor];
        lcell.tfEmail.returnKeyType = UIReturnKeyNext;
        tfEmail = lcell.tfEmail;
    }
    if (tfPassword == nil) {
        lcell.tfPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: color}];
        lcell.tfPassword.delegate = self;
        lcell.tfPassword.textColor = [UIColor blackColor];
        lcell.tfPassword.returnKeyType = UIReturnKeyDone;
        lcell.tfPassword.secureTextEntry  = YES;
        tfPassword = lcell.tfPassword;
    }
    if (tfConfirmPassword == nil) {
        lcell.tfConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Nhập lại mật khẩu" attributes:@{NSForegroundColorAttributeName: color}];
        lcell.tfConfirmPassword.delegate = self;
        lcell.tfConfirmPassword.textColor= [UIColor blackColor];
        lcell.tfConfirmPassword.returnKeyType = UIReturnKeyDone;
        lcell.tfConfirmPassword.secureTextEntry  = YES;
        tfConfirmPassword = lcell.tfConfirmPassword;
    }
    if (buttonDate == nil) {
        buttonDate = lcell.btnDateOfBirth;
        [buttonDate addTarget:self action:@selector(datePickerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }//buttonGender
    if (buttonGender == nil) {
        buttonGender = lcell.btnGender;
        [buttonGender addTarget:self action:@selector(genderPicker:) forControlEvents:UIControlEventTouchUpInside];
    }
    //    lcell.contentView.backgroundColor = [UIColor colorWithHex:@"#F6F6F6" alpha:1];
    
}


- (void)configureCellInfo:(InfomationCell *)lcell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *color = [UIColor blackColor];
    //    lcell.contentView.backgroundColor = [UIColor colorWithHex:@"#F6F6F6" alpha:1];
    lcell.tfFullname.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Họ tên" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfAddress.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Số nhà/Ngõ ngách" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfStreet.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Đường" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfStair.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Lầu" attributes:@{NSForegroundColorAttributeName: color}];
    lcell.tfPhone.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Số điện thoại" attributes:@{NSForegroundColorAttributeName: color}];
    
    lcell.tfFullname.delegate = self;
    lcell.tfAddress.delegate = self;
    lcell.tfStreet.delegate = self;
    lcell.tfStair.delegate = self;
    lcell.tfPhone.delegate = self;
    
    lcell.tfFullname.textColor = [UIColor blackColor];
    lcell.tfAddress.textColor = [UIColor blackColor];
    lcell.tfStreet.textColor= [UIColor blackColor];
    lcell.tfStair.textColor = [UIColor blackColor];
    lcell.tfPhone.textColor= [UIColor blackColor];
    
    lcell.tfFullname.returnKeyType = UIReturnKeyDone;
    lcell.tfAddress.returnKeyType = UIReturnKeyDone;
    lcell.tfStreet.returnKeyType = UIReturnKeyDone;
    lcell.tfStair.returnKeyType = UIReturnKeyDone;
    lcell.tfPhone.returnKeyType = UIReturnKeyDone;
    
    if (buttonState == nil) {
        buttonState = lcell.btnState;
        [buttonState addTarget:self action:@selector(statePicker:) forControlEvents:UIControlEventTouchUpInside];
    }//buttonGender
    if (buttonDistrict == nil) {
        buttonDistrict = lcell.btnDistrict;
        [buttonDistrict addTarget:self action:@selector(districtPicker:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (buttonWard == nil) {
        buttonWard = lcell.btnWard;
        [buttonWard addTarget:self action:@selector(wardPicker:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (buttonDone == nil) {
        buttonDone = lcell.btnSignUp;
        [buttonDone addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    }
    if (tfFullname == nil) {
        tfFullname = lcell.tfFullname;
        tfFullname.delegate = self;
    }
    if (tfAddress == nil) {
        tfAddress = lcell.tfAddress;
        tfAddress.delegate = self;
    }
    if (tfPhone == nil) {
        tfPhone = lcell.tfPhone;
        tfPhone.delegate = self;
    }
    if (tfStreet == nil) {
        tfStreet = lcell.tfStreet;
        tfStreet.delegate = self;
    }
    if (tfStair == nil) {
        tfStair = lcell.tfStair;
        tfStair.delegate = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LoginCell *cell = (LoginCell *)[tableViews dequeueReusableCellWithIdentifier:@"LoginCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoginCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [self configureCell:cell forRowAtIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else
    {
        InfomationCell *cell = (InfomationCell *)[tableViews dequeueReusableCellWithIdentifier:@"InfomationCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfomationCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [self configureCellInfo:cell forRowAtIndexPath:indexPath];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 278;
    }
    return 460;
}
#pragma mark picker
- (void)datePickerViewClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Ngày sinh" delegate:self];
    [picker setTag:1];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
}
- (void)genderPicker:(UIButton *)sender
{
    [self.view endEditing:YES];
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Giới tính" delegate:self];
    [picker setTag:2];
    [picker setTitlesForComponenets:@[@[@"Nam", @"Nữ"]]];
    [picker show];
}

- (void)statePicker:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSMutableArray * arrStateObj = [NSMutableArray new];
    for (State * item in arrState) {
        [arrStateObj addObject:item.stateName];
    }
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Thành phố" delegate:self];
    [picker setTag:3];
    [picker setTitlesForComponenets:@[arrStateObj]];
    [picker show];
}

- (void)districtPicker:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSMutableArray * arrDistrictObj = [NSMutableArray new];
    for (District * item in arrDistrict) {
        [arrDistrictObj addObject:item.districtName];
    }
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Quận/Huyện" delegate:self];
    [picker setTag:4];
    [picker setTitlesForComponenets:@[@[@"Nam", @"Nữ"]]];
    [picker show];
}

- (void)wardPicker:(UIButton *)sender
{
    [self.view endEditing:YES];
    NSMutableArray * arrWardObj = [NSMutableArray new];
    for (Ward * item in arrWard) {
        [arrWardObj addObject:item.wardName];
    }
    
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"Phường xã" delegate:self];
    [picker setTag:5];
    [picker setTitlesForComponenets:@[@[@"Nam", @"Nữ"]]];
    [picker show];
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    switch (pickerView.tag)
    {
        case 1:
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterNoStyle];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy"];
            NSString *prettyVersion = [dateFormat stringFromDate:date];
            [buttonDate setTitle:F(@"  %@",prettyVersion) forState:UIControlStateNormal];
            strDateOfBirth = prettyVersion;
        }
            break;
        default:
            break;
    }
}
-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles atIndex:(NSInteger)row
{
    switch (pickerView.tag)
    {
        case 2:
        {
            [buttonGender setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal];
            strGender = [titles componentsJoinedByString:@" - "];
            break;
        }
        case 3:
        {
            stateSelected = [arrState objectAtIndex:row];
            arrDistrict = [[TKDatabase sharedInstance]getDictrictByStateID:stateSelected.stateID];
            [buttonState setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal]; break;
        }
        case 4:
        {
            districtSelected = [arrDistrict objectAtIndex:row];
            arrWard = [[TKDatabase sharedInstance]getWarByDistrictID:districtSelected.stateID];
            [buttonDistrict setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal];
            break;
        }
        case 5:
        {
            wardSelected = [arrWard objectAtIndex:row];
            [buttonWard setTitle:[titles componentsJoinedByString:@" - "] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
#pragma mark Sigup
-(void)signUp
{
    UA_log(@"%@ - %@ - %@ - %@ - %@ ",tfEmail.text, tfPassword.text, tfConfirmPassword.text, strDateOfBirth, strGender );
}
@end
