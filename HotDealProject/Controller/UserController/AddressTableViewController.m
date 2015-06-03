//
//  AddressTableViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AddressTableViewController.h"
#import "AppDelegate.h"
#import "TKDatabase.h"
@interface AddressTableViewController ()

@end
typedef enum {
    ProvinceCb,
    DistrictCb,
    WardCb,
    AddressTypeCb
}ComboboxType;
@implementation AddressTableViewController
{
    UITextField* tfFullname;
    UITextField* tfAddess;
    UITextField* tfStreetName;
    UITextField* tfBuilding;
    UITextField* tfPhone;
    UILabel* lblProvince;
    UILabel* lblDistrict;
    UILabel* lblWard;
    UILabel* strAddressType;
    UIToolbar *toolbar;
    UIButton* btnRegister;
    NSArray * arrProvince;
    NSArray * arrDistrict;
    NSArray * arrWard;
    ComboboxType cbType;
    NSDictionary * dictAddressSelected;
    
    State * stateSelected;
    District * districtSelected;
    Ward * wardSelected;
    
    NSString * sStateID;
    NSString * sDistrictID;
    
    MBProgressHUD *HUD;

}
@synthesize pickerViewMain;
@synthesize dictResponse;
@synthesize iIndexAddress;
@synthesize isModify;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationBar];
    [self initHUD];
    NSArray * arrProfile = [dictResponse objectForKey:@"profiles"];
    dictAddressSelected = [arrProfile objectAtIndex:iIndexAddress];
    cbType = ProvinceCb;
    [self initData];
    [self initUITableView];
    [self setupPickerCommon];
    [self setupToolBar];
    
    NSDictionary * dictProvince = [dictAddressSelected objectForKey:@"s_state"];
    sStateID = [dictProvince objectForKey:@"state_id"];
    NSDictionary * dictDistrict = [dictAddressSelected objectForKey:@"s_district"];
    sDistrictID = [dictDistrict objectForKey:@"district_id"];
    NSDictionary * dictWard = [dictAddressSelected objectForKey:@"s_ward"];
    stateSelected = [State new];
    districtSelected = [District new];
    wardSelected = [Ward new];
    stateSelected.stateID = sStateID;
    districtSelected.districtID = sDistrictID;
    wardSelected.wardID = [dictWard objectForKey:@"ward_id"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)initData
{
    //    arrProvince = [NSArray arrayWithObjects:@"TP.HCM",@"Hà Nội",@"Đà Nẵng",@"Vũng Tàu", nil];
    arrProvince = [[TKAPI sharedInstance]getAllState];
    arrDistrict = [NSArray arrayWithObjects:@"Quận 1",@"Quận 2",@"Quận 3",@"Quận 4",@"Quận 5",@"Quận 6",@"Quận 7", nil];
    arrWard = [NSArray arrayWithObjects:@"Nhà riêng",@"Cơ quan", nil];
}
-(void)initNavigationBar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:_strTitle];
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField* tf = nil ;
        switch ( indexPath.row ) {
            case 0: {
                cellRe.textLabel.text = @"" ;
                tf = tfFullname = [self makeTextField:[dictResponse objectForKey:@"fullname"] placeholder:@"Họ tên"];
                //                tf.textColor = [UIColor lightGrayColor];
                [cellRe addSubview:tfFullname];
                break ;
            }
            case 1: {
                cellRe.textLabel.text = @"" ;
                tf = tfPhone = [self makeTextField:[dictResponse objectForKey:@"phone"] placeholder:@"Số điện thoại"];
                [cellRe addSubview:tfPhone];
                break ;
            }
            case 2: {
                cellRe.textLabel.text = @"" ;
                tf = tfAddess = [self makeTextField:[dictAddressSelected objectForKey:@"s_address"] placeholder:@"Số nhà"];
                [cellRe addSubview:tfAddess];
                break ;
            }
            case 3: {
                cellRe.textLabel.text = @"" ;
                tf = tfStreetName = [self makeTextField:[dictAddressSelected objectForKey:@"s_address_2"] placeholder:@"Tên đường / phố"];
                [cellRe addSubview:tfStreetName];
                break ;
            }
            case 4: {
                cellRe.textLabel.text = @"" ;
                NSString * strBuilding = [dictAddressSelected objectForKey:@"s_address_note"];
                tf = tfBuilding = [self makeTextField:strBuilding placeholder:@"Tòa nhà,lẩu (không bắt buôc)"];
                [cellRe addSubview:tfBuilding];
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
    if (indexPath.section == 2)
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                
                NSDictionary * dictDictrict = [dictAddressSelected objectForKey:@"s_district"];
                if ([dictDictrict objectForKey:@"name"] != nil && ![[dictDictrict objectForKey:@"name"] isEqualToString:@""]) {
                    arrDistrict = [[TKDatabase sharedInstance]getDictrictByStateID:sStateID];
                    lbl = lblDistrict = [self makeLabel:F(@"   %@",[dictDictrict objectForKey:@"name"])];
                    lbl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                    
                    // Textfield dimensions
                    lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
                    cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
                    
                    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox2)];
                    // if labelView is not set userInteractionEnabled, you must do so
                    [lbl setUserInteractionEnabled:YES];
                    [lbl addGestureRecognizer:gesture];
                    
                    UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                    [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                    [cellRe addSubview:imgArrow];
                    [cellRe addSubview:lbl];
                    return cellRe;
                    
                }
                else
                {
                    lbl = lblDistrict = [self makeLabel:@"  Quận / Huyện"];
                    lblDistrict.userInteractionEnabled = NO;
                    
                    // Textfield dimensions
                    lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
                    cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
                    [cellRe addSubview:lbl];
                    UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                    [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                    [cellRe addSubview:imgArrow];
                    
                    return cellRe;
                }
                
                break ;
            }
        }
        
       
        
    }
    if (indexPath.section == 3)
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                NSDictionary * dictWar = [dictAddressSelected objectForKey:@"s_ward"];
                if ([dictWar objectForKey:@"name"] != nil && ![[dictWar objectForKey:@"name"] isEqualToString:@""]) {
                    
//                    NSString * warID = [dictWar objectForKey:@""];
                    arrWard = [[TKDatabase sharedInstance]getWarByDistrictID:sDistrictID];
                    
                    lbl = lblWard = [self makeLabel:F(@"   %@",[dictWar objectForKey:@"name"])];
                    lbl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                    
                    // Textfield dimensions
                    lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
                    cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
                    [cellRe addSubview:lbl];
                    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox3)];
                    // if labelView is not set userInteractionEnabled, you must do so
                    [lbl setUserInteractionEnabled:YES];
                    [lbl addGestureRecognizer:gesture];
                    UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                    [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                    [cellRe addSubview:imgArrow];
                    
                    return cellRe;
                }
                else
                {
                    lbl = lblWard = [self makeLabel:@"  Phường / Xã"];
                    lblWard.userInteractionEnabled = NO;
                    
                    lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
                    cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
                    [cellRe addSubview:lbl];
                    UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
                    [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
                    [cellRe addSubview:imgArrow];
                       return cellRe;
                }
               
                break ;
            }
        }
        
        
    }
    if (indexPath.section == 1)
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                NSDictionary * dictProvince = [dictAddressSelected objectForKey:@"s_state"];
                if ([dictProvince objectForKey:@"name"] != nil && ![[dictProvince objectForKey:@"name"] isEqualToString:@""]) {
                    lbl = lblProvince = [self makeLabel:F(@"   %@",[dictProvince objectForKey:@"name"])];
                    lbl.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
                }
                else
                {
                    lbl = lblProvince = [self makeLabel:@"  Tỉnh / Thành phố"];
                }
                [cellRe addSubview:lbl];
                break ;
            }
        }
        
        // Textfield dimensions
        lbl.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox1)];
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
        
        button = btnRegister = [self makeButtonRegister];
        [cellRe addSubview:btnRegister];
        
        // Textfield dimensions
        button.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
        //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
        return cellRe;
        
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
    toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, pickerViewMain.frame.origin.y - 44, pickerViewMain.frame.size.width, 44)];
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
    switch (cbType) {
        case ProvinceCb:
        {
            NSInteger  iIndex =  [pickerViewMain selectedRowInComponent:0];
            State * state = [arrProvince objectAtIndex:iIndex];
            arrDistrict = [[TKDatabase sharedInstance]getDictrictByStateID:state.stateID];
            stateSelected = state;
            lblProvince.text = F(@"  %@",state.stateName);
            lblDistrict.userInteractionEnabled = YES;
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox2)];
            // if labelView is not set userInteractionEnabled, you must do so
            [lblDistrict setUserInteractionEnabled:YES];
            [lblDistrict addGestureRecognizer:gesture];
            
            pickerViewMain.hidden = YES;
            toolbar.hidden = YES;
            lblProvince.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
//            [self.tableView reloadData];
            break;
        }
        case DistrictCb:
        {
            
            NSInteger  iIndex =  [pickerViewMain selectedRowInComponent:0];
            District * district = [arrDistrict objectAtIndex:iIndex];
            arrWard = [[TKDatabase sharedInstance]getWarByDistrictID:district.districtID];
            districtSelected = district;
            lblDistrict.text = F(@"  %@",district.districtName);
            toolbar.hidden = YES;
            pickerViewMain.hidden = YES;
            lblWard.userInteractionEnabled = YES;
            lblDistrict.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropbox3)];
            // if labelView is not set userInteractionEnabled, you must do so
            [lblWard setUserInteractionEnabled:YES];
            [lblWard addGestureRecognizer:gesture];
            
            break;
        }
        case WardCb:
        {
            NSInteger  iIndex =  [pickerViewMain selectedRowInComponent:0];
            Ward * ward = [arrWard objectAtIndex:iIndex];
            wardSelected = ward;
            lblWard.text = F(@"  %@",ward.wardName);
            toolbar.hidden = YES;
            pickerViewMain.hidden = YES;
            lblWard.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            break;
        }
        default:
            break;
    }
    
    //    pickerViewMain.hidden = YES;
    //    toolbar.hidden = YES;
    //    self.tableView.scrollEnabled = YES;
}



-(void)cancelButtonPressed:(id)sender{
    pickerViewMain.hidden = YES;
    toolbar.hidden = YES;
    self.tableView.scrollEnabled = YES;
}

-(void)makePicker
{
    //    CGRect pickerFrame = CGRectMake(0,ScreenHeight - 162-60,0,0);
    //
    //    pickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    //    pickerView.hidden = YES;
    //    [self.view addSubview:pickerView];
}

-(void)showPicker
{
    //    isBirthdayAction = TRUE;
    //    pickerView.backgroundColor = [UIColor whiteColor];
    //    pickerView.datePickerMode = UIDatePickerModeDate;
    //    pickerView.hidden = NO;
    //    toolbar.hidden = NO;
    //
    //    NSDate *currentDate = [NSDate date];
    //    [pickerView setMaximumDate:currentDate];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (cbType == DistrictCb) {
        return  [arrDistrict count];
        
    }
    if (cbType == ProvinceCb) {
        return [arrProvince count];
    }
    else
    {
        return [arrWard count];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (cbType == DistrictCb) {
        District * district = [arrDistrict objectAtIndex:row];
        return district.districtName;
    }
    if (cbType == ProvinceCb) {
        State * state = [arrProvince objectAtIndex:row];
        return state.stateName;
    }
    else
    {
        Ward * ward = [arrWard objectAtIndex:row];
        return ward.wardName;
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = ScreenWidth- 20;
    
    return sectionWidth;
}

-(void)setupPickerCommon
{
    pickerViewMain = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight -250, ScreenWidth, 220)];
    //    numRowsInPicker = 3;
    pickerViewMain.delegate = self;
    [pickerViewMain setBackgroundColor:[UIColor whiteColor]];
    pickerViewMain.showsSelectionIndicator = YES;
    pickerViewMain.hidden = YES;
    [self.view addSubview:pickerViewMain];
    
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
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    [tableViewMain setBounces:NO];
    //    tableViewMain.separatorColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.sectionHeaderHeight = 0.0;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)showDropbox1
{
        [self.view endEditing:YES];
    pickerViewMain.hidden = NO;
    toolbar.hidden = NO;
    cbType = ProvinceCb;
    [pickerViewMain reloadAllComponents];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.tableView.scrollEnabled = NO;
}
-(void)showDropbox2
{
    pickerViewMain.hidden = NO;
    toolbar.hidden = NO;
    cbType = DistrictCb;
    [pickerViewMain reloadAllComponents];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.tableView.scrollEnabled = NO;
}

-(void)showDropbox3
{
    cbType = WardCb;
    pickerViewMain.hidden = NO;
    toolbar.hidden = NO;
    [pickerViewMain reloadAllComponents];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.tableView.scrollEnabled = NO;
}

-(void)showDropbox4
{
    cbType = AddressTypeCb;
    pickerViewMain.hidden = NO;
    toolbar.hidden = NO;
    [pickerViewMain reloadAllComponents];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.tableView.scrollEnabled = NO;
}

-(UIButton*) makeButtonRegister{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"GIAO HÀNG ĐẾN ĐỊA CHỈ NÀY" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)doneClick
{
//    UA_log(@"GIAO HÀNG ĐẾN ĐỊA CHỈ NÀY");
    if (isModify == TRUE) {
        NSString * profile_id = [dictAddressSelected objectForKey:@"profile_id"];
        User * user = [[TKDatabase sharedInstance]getUserInfo];
        NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        user.user_id,@"user_id",
                                        tfFullname.text, @"s_firstname",
                                        tfAddess.text, @"s_address",
                                        tfStreetName.text,@"s_address_2",
                                        tfBuilding.text, @"s_address_note",
                                        stateSelected.stateID, @"s_state",
                                        districtSelected.districtID,@"s_district",
                                        wardSelected.wardID, @"s_ward",
                                        tfPhone.text, @"s_phone",
                                        profile_id,@"profile_id",
                                        nil];
        
        
        [HUD show:YES];
        [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_UPDATE_PROFILE completion:^(NSDictionary * dict, NSError *error) {
            [HUD hide:YES];
            if (dict == nil) {
                return;
            }
            BOOL response = [[dict objectForKey:@"response"]boolValue];
            if (response == TRUE) {
                //            NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
                //            [[TKDatabase sharedInstance]addUser:user_id];
                ALERT(LS(@"MessageBoxTitle"), @"Cập nhật địa chỉ giao hàng thành công");
                [self.delegate updateTableAddress:@""];
                [self.navigationController popViewControllerAnimated:YES];
                //            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
                //            MainViewController * mainVC = [[MainViewController alloc]init];
                //            [self.navigationController pushViewController:mainVC animated:YES];
            }
            else
            {
                NSString * response = [dict objectForKey:@"reason"];
                ALERT(LS(@"MessageBoxTitle"),response);
            }
        }];
    }
    else
    {
    User * user = [[TKDatabase sharedInstance]getUserInfo];
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    user.user_id,@"user_id",
                                    tfFullname.text, @"s_firstname",
                                    tfAddess.text, @"s_address",
                                    tfStreetName.text,@"s_address_2",
                                    tfBuilding.text, @"s_address_note",
                                    stateSelected.stateID, @"s_state",
                                    districtSelected.districtID,@"s_district",
                                    wardSelected.wardID, @"s_ward",
                                    tfPhone.text, @"s_phone",
                                    nil];
    
    
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_ADD_PROFILE completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        BOOL response = [[dict objectForKey:@"response"]boolValue];
        if (response == TRUE) {
            //            NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
            //            [[TKDatabase sharedInstance]addUser:user_id];
            ALERT(LS(@"MessageBoxTitle"), @"Thêm địa chỉ giao hàng thành công");
            [self.delegate updateTableAddress:@""];
            [self.navigationController popViewControllerAnimated:YES];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
            //            MainViewController * mainVC = [[MainViewController alloc]init];
            //            [self.navigationController pushViewController:mainVC animated:YES];
        }
        else
        {
            NSString * response = [dict objectForKey:@"reason"];
            ALERT(LS(@"MessageBoxTitle"),response);
        }
    }];
    }
}
@end
