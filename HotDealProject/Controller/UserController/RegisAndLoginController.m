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
#import "MainViewController.h"
#import "TKDatabase.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
static NSString * const kClientId = @"752710685205-sojbki4m33heqv5ntti5i0if26p7838c.apps.googleusercontent.com";
//kGTLAuthScopePlusLogin
@interface RegisAndLoginController ()<GPPSignInDelegate>

@end

@implementation RegisAndLoginController
{
    SWRevealViewController *revealController;
    LoginCell *cell;
    UISegmentedControl *segmentedControl;
    UIView * viewHeader;
    BOOL isLoginFrame;
    UITextField* tfEmail;
    UITextField* tfEmailLogin;
    UITextField* tfPasswordLogin;
    UITextField* tfPassword;
    UITextField* tfConfirmPassword;
    UITextField* tfFullname;
    UITextField* tfPhone;
    UILabel* lblBirthday;
    UILabel* lblGender;
    UIButton* btnRegister;
    UIButton* btnLoginFacebook;
    UIButton* btnLoginGoogle;
    UIToolbar *toolbar;
    BOOL isBirthdayAction;
    MBProgressHUD *HUD;
    GPPSignIn *signIn;
}
@synthesize pickerView;
@synthesize pickerGender;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    isLoginFrame = TRUE;
    [self initHUD];
    [self setupSegment];
    isBirthdayAction = TRUE;
    [self initUITableView];
    [self setupPickerGender];
    [self makePicker];
    [self setupToolBar];
    [self glLogin];
    // Do any additional setup after loading the view.
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.tableView.scrollEnabled = NO;
    //self.tableView.userInteractionEnabled;
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
    [rBtest addTarget:self action:@selector(myMethod) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
}

-(void)myMethod{
    [self.view endEditing:YES];
    SWRevealViewController *reveal = self.revealViewController;
    [reveal revealToggleAnimated:YES];
}


#pragma mark tableview delegate + datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoginFrame == TRUE) {
        return  4;
    }
    else
    {
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isLoginFrame == TRUE) {
        if (section == 0) {
            return 2;
        }
        return 1;//3 login facebook, google +
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
        return 50;
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
        if (indexPath.section == 0) {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UITextField* tf = nil ;
            switch ( indexPath.row ) {
                case 0: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfEmailLogin = [self makeTextField:@"" placeholder:@"Địa chỉ email"];
                    //                    tf.textColor = [UIColor lightGrayColor];
                    [cellRe addSubview:tfEmailLogin];
                    break ;
                }
                case 1: {
                    cellRe.textLabel.text = @"" ;
                    tf = tfPasswordLogin = [self makeTextField:@"" placeholder:@"Mật khẩu"];
                    tfPasswordLogin.secureTextEntry = YES;
                    [cellRe addSubview:tfPasswordLogin];
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
            UIButton* button = nil ;
            
            button = btnLoginFacebook = [self makeButtonLogin];
            [cellRe addSubview:btnLoginFacebook];
            
            // Textfield dimensions
            button.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            return cellRe;
        }
        if (indexPath.section == 2)
        {
            
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton* button = nil ;
            
            button = btnLoginFacebook = [self makeButtonLoginFacebook];
            [cellRe addSubview:btnLoginFacebook];
            
            // Textfield dimensions
            button.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            return cellRe;
            
        }
        else
        {
            UITableViewCell *cellRe = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            
            // Make cell unselectable
            cellRe.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton* button = nil ;
            
            button = btnLoginGoogle = [self makeButtonLoginGoogle];
            [cellRe addSubview:btnLoginGoogle];
            
            // Textfield dimensions
            button.frame = CGRectMake(20, 0, ScreenWidth - 40, 45);
            //            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            cellRe.contentView.backgroundColor = [UIColor colorWithHex:@"#dcdcdc" alpha:1];
            return cellRe;
            
        }
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
                    if (tfEmail != nil) {
                        [cellRe addSubview:tfEmail];
                        break;
                    }
                    tf = tfEmail = [self makeTextField:@"" placeholder:@"Địa chỉ email"];
                    //                    tf.textColor = [UIColor lightGrayColor];
                    [cellRe addSubview:tfEmail];
                    break ;
                }
                case 1: {
                    cellRe.textLabel.text = @"" ;
                    if (tfPassword != nil) {
                        [cellRe addSubview:tfPassword];
                        tfPassword.secureTextEntry = YES;
                        break;
                    }
                    tf = tfPassword = [self makeTextField:@"" placeholder:@"Mật khẩu"];
                    [cellRe addSubview:tfPassword];
                    tfPassword.secureTextEntry = YES;
                    break ;
                }
                case 2: {
                    cellRe.textLabel.text = @"" ;
                    if (tfConfirmPassword != nil) {
                        [cellRe addSubview:tfConfirmPassword];
                        break;
                    }
                    tf = tfConfirmPassword = [self makeTextField:@"" placeholder:@"Nhập lại mật khẩu"];
                    tfConfirmPassword.secureTextEntry = YES;
                    [cellRe addSubview:tfConfirmPassword];
                    break ;
                }
                case 3: {
                    cellRe.textLabel.text = @"" ;
                    if (tfFullname != nil) {
                        [cellRe addSubview:tfFullname];
                        break;
                    }
                    tf = tfFullname = [self makeTextField:@"" placeholder:@"Họ tên"];
                    [cellRe addSubview:tfFullname];
                    break ;
                }
                case 4: {
                    cellRe.textLabel.text = @"" ;
                    if (tfPhone != nil) {
                        [cellRe addSubview:tfPhone];
                        break;
                    }
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
            
            UIImageView * imgArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrowDown"]];
            [imgArrow setFrame:CGRectMake(ScreenWidth - 60, 6, 15, 30)];
            [cellRe addSubview:imgArrow];
            
            
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

-(UIButton*) makeButtonLogin{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Đăng nhập" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)normalLogin
{
    NSString * email = tfEmailLogin.text;
    NSString * pass = tfPasswordLogin.text;
    NSString * auto_signin = @"1";
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    email, @"email",
                                    pass, @"password",
                                    auto_signin, @"auto_signin",
                                    nil];
    
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_SIGN_IN completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        BOOL response = [[dict objectForKey:@"response"]boolValue];
        if (response == TRUE) {
            NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
            [[TKDatabase sharedInstance]addUser:user_id];
            ALERT(LS(@"MessageBoxTitle"), @"Đăng nhâp thành công");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
            MainViewController * mainVC = [[MainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
        }
        else
        {
            NSString * response = [dict objectForKey:@"reason"];
            ALERT(LS(@"MessageBoxTitle"),response);
        }
    }];
    
}

-(void)fbLogin
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];
}

-(void)glLogin
{
    signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail=YES;
    signIn.shouldFetchGooglePlusUser = YES;
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        GTLPlusPerson *per = signIn.googlePlusUser;
        NSLog(@"Email= %@", signIn.authentication.userEmail);
        NSLog(@"GoogleID=%@", per.identifier);
        NSLog(@"Birthday=%@", per.birthday);
        NSLog(@"User Name=%@", [per.name.givenName stringByAppendingFormat:@" %@", per.name.familyName]);
        NSLog(@"Gender=%@", per.gender);
    }
}

- (void)googlePlusLogin:(id)sender {
    [[GPPSignIn sharedInstance]authenticate];
}

-(void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSDictionary* dictionary = (NSDictionary *)result;
                 
                 NSString * email = [dictionary objectForKey:@"email"];
                 NSString * gender = [dictionary objectForKey:@"gender"];
                 if ([gender isEqualToString:@"male"]) {
                     gender = @"1";
                 }
                 else
                 {
                     gender = @"2";
                 }
                 NSString * name = [dictionary objectForKey:@"name"];
                 NSString * link = [dictionary objectForKey:@"link"];
                 NSString * type = @"facebook";
                 NSString * bod = @"1332043063";
                 NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 email, @"email",
                                                 gender, @"gender",
                                                 name, @"name",
                                                 link, @"link",
                                                 type, @"type",
                                                 bod, @"bod",
                                                 nil];
                 //NSString * strDate = F(@"%.0f",floor([date timeIntervalSince1970] * 1000));
                 
                 UA_log(@"%@",jsonDictionary);
                 [HUD show:YES];
                 [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_CONNECT_SOCICAL completion:^(NSDictionary * dict, NSError *error) {
                     //        [self showMainView:dict wError:error];
                     [HUD hide:YES];
                     if (dict == nil) {
                         return;
                     }
                     BOOL response = [[dict objectForKey:@"response"]boolValue];
                     if (response == TRUE) {
                         NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
                         [[TKDatabase sharedInstance]addUser:user_id];
                         ALERT(LS(@"MessageBoxTitle"), @"Đăng nhâp thành công");
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
                         MainViewController * mainVC = [[MainViewController alloc]init];
                         [self.navigationController pushViewController:mainVC animated:YES];
                     }
                     else
                     {
                         NSString * response = [dict objectForKey:@"reason"];
                         ALERT(LS(@"MessageBoxTitle"),response);
                     }
                 }];
                 
                 
                 //                 [[TKDatabase sharedInstance]addUser:email wFullname:name wGender:gender];
                 //                 NSLog(@"Fetched User Information:%@", result);
                 //                 ALERT(@"Thông báo", @"Đăng nhập thành công");
                 //                 [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
                 //                 MainViewController * mainVC = [[MainViewController alloc]init];
                 //                 [self.navigationController pushViewController:mainVC animated:YES];
                 
                 
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}

//email = "lionlord19901@yahoo.com";
//"first_name" = "Ki\U1ec7t";
//gender = male;
//id = 842110102511021;
//"last_name" = "Tr\U1ea7n T\U1ea5n";
//link = "https://www.facebook.com/app_scoped_user_id/842110102511021/";
//locale = "en_US";
//name = "Tr\U1ea7n T\U1ea5n Ki\U1ec7t";
//timezone = 7;
//"updated_time" = "2015-05-12T06:25:56+0000";
//verified = 1;
-(UIButton*) makeButtonLoginFacebook{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Đăng nhập bằng Facebook" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(fbLogin) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(UIButton*) makeButtonLoginGoogle{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"Đăng nhập bằng Google" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(googlePlusLogin:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)registerClick
{
    if ([self checkInput] == FALSE) {
        return;
    }
    NSString * email = tfEmail.text;
    NSString * password = tfPassword.text;
    NSString * fullname = tfFullname.text;
    NSString * birthday = [lblBirthday.text trim];
    NSString * phone = [tfPhone.text trim];
    NSString * gender = [lblGender.text trim];
    if ([gender isEqualToString:@"Nam"]) {
        gender = @"1";
    }
    else
    {
        gender = @"2";
    }
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    email, @"email",
                                    password, @"password",
                                    fullname, @"fullname",
                                    birthday, @"birthday",
                                    phone, @"phone",
                                    gender, @"gender",
                                    nil];
    UA_log(@"%@",jsonDictionary);
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_SIGN_UP completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        BOOL response = [[dict objectForKey:@"response"]boolValue];
        if (response == TRUE) {
            NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
            [[TKDatabase sharedInstance]addUser:user_id];
            ALERT(LS(@"MessageBoxTitle"), @"Đăng ký thành công");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiUpdateLeftmenu" object:nil];
            MainViewController * mainVC = [[MainViewController alloc]init];
            [self.navigationController pushViewController:mainVC animated:YES];
        }
        else
        {
            NSString * response = [dict objectForKey:@"reason"];
            ALERT(LS(@"MessageBoxTitle"),response);
        }
    }];
    
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
    else
    {
        if (section == 0)
            return 60;
        if (section == 1) {
            return 44;
        }
        else
            return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isLoginFrame == FALSE) {
        if (section == 0) {
            return viewHeader;
        }
        return nil;
    }
    else
    {
        if (section == 0) {
            return viewHeader;
        }
        if (section == 1) {
            UIView * viewForgotpass = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth -20, 44)];
            UIButton * btnForgot = [UIButton buttonWithType:UIButtonTypeSystem];
            [btnForgot setFrame:CGRectMake(0, -5, 200, 35)];
            [btnForgot setTitle:@"Bạn quên mật khẩu ?" forState:UIControlStateNormal];
            [btnForgot addTarget:self action:@selector(forgotPassClick) forControlEvents:UIControlEventTouchUpInside];
            [viewForgotpass addSubview:btnForgot];
            return viewForgotpass;
        }
        else return nil;
        
    }
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
    viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
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
    tf.textColor = [UIColor blackColor];
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
        self.tableView.scrollEnabled = YES;
        
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
        self.tableView.scrollEnabled = YES;
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
    self.tableView.scrollEnabled = NO;
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
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
    pickerGender = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight -250, ScreenWidth, 220)];
    //    numRowsInPicker = 3;
    pickerGender.delegate = self;
    [pickerGender setBackgroundColor:[UIColor whiteColor]];
    pickerGender.showsSelectionIndicator = YES;
    pickerGender.hidden = YES;
    [self.view addSubview:pickerGender];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    self.tableView.scrollEnabled = NO;
    
    
}
-(void)showDropbox
{
    isBirthdayAction = NO;
    pickerGender.hidden = NO;
    toolbar.hidden = NO;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

- (BOOL)checkInput{
    if (([tfEmail.text length]<4) || ([tfEmail.text rangeOfString:@"@"].location == NSNotFound)||![self validateEmail:tfEmail.text]){
        ALERT(LS(@"MessageBoxTitle"), LS(@"EmailErrorNotify"));
        return NO;
    }
    else if ([tfPassword.text length]<4 || [tfPassword.text length]>16){
        ALERT(LS(@"MessageBoxTitle"), LS(@"CheckPasswordLength"));
        return NO;
    }else if ([tfPassword.text isEqualToString:tfConfirmPassword.text] == NO){
        ALERT(LS(@"MessageBoxTitle"), LS(@"CheckPasswordAndRetype"));
        return NO;
    }
    else{
        return YES;
    }
}

@end
