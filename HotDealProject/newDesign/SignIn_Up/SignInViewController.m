//
//  SignInViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/18/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "SignInViewController.h"
#import "MainViewController.h"
#import "TKDatabase.h"
#import "AppDelegate.h"
@interface SignInViewController ()

@end

@implementation SignInViewController
{
    MBProgressHUD *HUD;
}
@synthesize tfEmail,tfPassword;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self initNavigationbar:@"Đăng nhập"];
    [self initTextField];
    [self initButton];
}

-(void)initNavigationbar:(NSString *)strTitle
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:strTitle];
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
    if (textField == tfEmail) {
        [tfPassword becomeFirstResponder];
        return YES;
    }
    
    [self normalLogin];
    [textField resignFirstResponder];
    return YES;
}

-(void)initTextField
{
    UIColor *color = [UIColor blackColor];
    self.tfEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email đăng nhập..." attributes:@{NSForegroundColorAttributeName: color}];
    self.tfPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mật khẩu" attributes:@{NSForegroundColorAttributeName: color}];
    self.tfEmail.delegate = self;
    self.tfPassword.delegate = self;
    
    self.tfEmail.borderStyle = UITextBorderStyleNone;
    self.tfPassword.borderStyle = UITextBorderStyleNone;
    
    self.tfEmail.returnKeyType = UIReturnKeyNext;
    self.tfPassword.returnKeyType = UIReturnKeyDone;
    self.tfPassword.secureTextEntry  = YES;
}

-(void)initButton
{
    UIButton * btnSignin = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSignin setFrame:CGRectMake(20, 161, ScreenWidth/2-25, 44)];
    [btnSignin addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    btnSignin.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
    
    [btnSignin setTitle:@"Đăng nhập" forState:UIControlStateNormal];
    btnSignin.titleLabel.textColor = [UIColor whiteColor];
    btnSignin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:btnSignin];
    
    UIButton * btnSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSignUp setFrame:CGRectMake(30 + ScreenWidth/2-25, 161, ScreenWidth/2-25, 44)];
    [btnSignUp addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btnSignUp.backgroundColor = [UIColor colorWithHex:@"#0cba06" alpha:1];
    
    [btnSignUp setTitle:@"Đăng ký" forState:UIControlStateNormal];
    btnSignUp.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnSignUp];
    
    UIButton * btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFacebook setFrame:CGRectMake(20, 250, ScreenWidth/2-25, 44)];
    [btnFacebook addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    btnFacebook.backgroundColor = [UIColor colorWithHex:@"#3b5998" alpha:1];
    
    [btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    btnFacebook.titleLabel.textColor = [UIColor whiteColor];
    btnFacebook.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:btnFacebook];
    
    UIButton * btnGooglePlus = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnGooglePlus setFrame:CGRectMake(30 + ScreenWidth/2-25, 250, ScreenWidth/2-25, 44)];
    [btnGooglePlus addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    btnGooglePlus.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btnGooglePlus.backgroundColor = [UIColor colorWithHex:@"#d34836" alpha:1];
    
    [btnGooglePlus setTitle:@"Google+" forState:UIControlStateNormal];
    btnGooglePlus.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnGooglePlus];
    
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

#pragma mark Login Action
-(void)normalLogin
{
    NSString * email = tfEmail.text;
    NSString * pass = tfPassword.text;
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


@end
