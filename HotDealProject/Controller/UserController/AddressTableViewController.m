//
//  AddressTableViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/11/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AddressTableViewController.h"
#import "AppDelegate.h"
@interface AddressTableViewController ()

@end

@implementation AddressTableViewController
{
    UITextField* tfFullname;
    UITextField* tfAddess;
    UITextField* tfStreetName;
    UITextField* tfBuilding;
    UITextField* tfPhone;
    UILabel* lblProvince;
    UILabel* lblDistrict;
    UILabel* lblPhuongXa;
    UILabel* strAddressType;
    UIToolbar *toolbar;
    UIButton* btnRegister;

}
@synthesize pickerViewMain;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationBar];
    [self initUITableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initNavigationBar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Địa chỉ giao hàng"];
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
    return 6;
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
                tf = tfFullname = [self makeTextField:@"" placeholder:@"Địa chỉ email"];
                tf.textColor = [UIColor lightGrayColor];
                [cellRe addSubview:tfFullname];
                break ;
            }
            case 1: {
                cellRe.textLabel.text = @"" ;
                tf = tfPhone = [self makeTextField:@"" placeholder:@"Số điện thoại"];
                [cellRe addSubview:tfPhone];
                break ;
            }
            case 2: {
                cellRe.textLabel.text = @"" ;
                tf = tfAddess = [self makeTextField:@"" placeholder:@"Số nhà"];
                [cellRe addSubview:tfAddess];
                break ;
            }
            case 3: {
                cellRe.textLabel.text = @"" ;
                tf = tfStreetName = [self makeTextField:@"" placeholder:@"Tên đường / phố"];
                [cellRe addSubview:tfStreetName];
                break ;
            }
            case 4: {
                cellRe.textLabel.text = @"" ;
                tf = tfBuilding = [self makeTextField:@"" placeholder:@"Tòa nhà (không bắt buôc)"];
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
                
                //                    cell.textLabel.text = @"Ngày sinh" ;
                lbl = lblProvince = [self makeLabel:@"  Quận / Huyện"];
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
        
        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
        [cellRe addSubview:imgArrow];

        return cellRe;
        
    }
    if (indexPath.section == 3)
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                
                //                    cell.textLabel.text = @"Ngày sinh" ;
                lbl = lblProvince = [self makeLabel:@"  Phường / Xã"];
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
        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
        [cellRe addSubview:imgArrow];

        
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
                
                //                    cell.textLabel.text = @"Ngày sinh" ;
                lbl = lblProvince = [self makeLabel:@"  Tỉnh / Thành phố"];
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
        
        UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
        [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
        [cellRe addSubview:imgArrow];

        
        return cellRe;
        
    }
    if (indexPath.section == 4)
    {
        UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        // Make cell unselectable
        cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* lbl = nil ;
        switch ( indexPath.row ) {
            case 0: {
                
                //                    cell.textLabel.text = @"Ngày sinh" ;
                lbl = lblProvince = [self makeLabel:@"  Loại địa chỉ"];
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
//    NSInteger  iIndex =  [pickerGender selectedRowInComponent:0];
//    if (iIndex == 0) {
//        lblGender.text = @"  Nam";
//    }
//    else
//    {
//        lblGender.text = @"  Nữ";
//    }
//    
//    lblGender.textColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
//    pickerGender.hidden = YES;
    toolbar.hidden = YES;
}



-(void)cancelButtonPressed:(id)sender{
    pickerViewMain.hidden = YES;
    toolbar.hidden = YES;
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

-(void)setupPickerCommon
{
    pickerViewMain = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight -250, ScreenWidth, 200)];
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

-(void)showDropbox
{
    pickerViewMain.hidden = NO;
    toolbar.hidden = NO;
}
-(UIButton*) makeButtonRegister{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"GIAO HÀNG ĐẾN ĐỊA CHỈ NÀY" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end