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
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "YahooSDK.h"
@interface SignInViewController ()<GPPSignInDelegate,YahooSessionDelegate>
@property (strong, nonatomic) YahooSession *session;
@end
static NSString * const kClientId = @"752710685205-sojbki4m33heqv5ntti5i0if26p7838c.apps.googleusercontent.com";

@implementation SignInViewController
{
    MBProgressHUD *HUD;
    GPPSignIn *signIn;
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
    btnSignin.backgroundColor = [UIColor colorWithHex:@"#6AB917" alpha:1];
    
    [btnSignin setTitle:@"Đăng nhập" forState:UIControlStateNormal];
    btnSignin.titleLabel.textColor = [UIColor whiteColor];
    btnSignin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:btnSignin];
    
    UIButton * btnSignUp = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSignUp setFrame:CGRectMake(30 + ScreenWidth/2-25, 161, ScreenWidth/2-25, 44)];
    [btnSignUp addTarget:self action:@selector(normalLogin) forControlEvents:UIControlEventTouchUpInside];
    btnSignUp.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btnSignUp.backgroundColor = [UIColor colorWithHex:@"#6AB917" alpha:1];
    
    [btnSignUp setTitle:@"Đăng ký" forState:UIControlStateNormal];
    btnSignUp.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnSignUp];
    
    UIButton * btnFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFacebook setFrame:CGRectMake(20, 250, (ScreenWidth-60)/3, 44)];
    [btnFacebook addTarget:self action:@selector(fbLogin) forControlEvents:UIControlEventTouchUpInside];
    btnFacebook.backgroundColor = [UIColor colorWithHex:@"#3b5998" alpha:1];
    
    [btnFacebook setTitle:@"Facebook" forState:UIControlStateNormal];
    btnFacebook.titleLabel.textColor = [UIColor whiteColor];
    btnFacebook.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:btnFacebook];
    
    UIButton * btnGooglePlus = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnGooglePlus setFrame:CGRectMake(30 + (ScreenWidth-60)/3, 250, (ScreenWidth-60)/3, 44)];
    [btnGooglePlus addTarget:self action:@selector(googlePlusLogin:) forControlEvents:UIControlEventTouchUpInside];
    btnGooglePlus.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btnGooglePlus.backgroundColor = [UIColor colorWithHex:@"#d34836" alpha:1];
    
    [btnGooglePlus setTitle:@"Google+" forState:UIControlStateNormal];
    btnGooglePlus.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnGooglePlus];
    
    UIButton * btnYahoo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnYahoo setFrame:CGRectMake(40 + 2*(ScreenWidth-60)/3, 250, (ScreenWidth-60)/3, 44)];
    [btnYahoo addTarget:self action:@selector(yahooLogin) forControlEvents:UIControlEventTouchUpInside];
    btnYahoo.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    btnYahoo.backgroundColor = [UIColor colorWithHex:@"#7B0099" alpha:1];
    
    [btnYahoo setTitle:@"Yahoo" forState:UIControlStateNormal];
    btnYahoo.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:btnYahoo];
}
-(BOOL) isInternetReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
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
    if (![self isInternetReachable]) {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
        return;
    }
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

-(void)fbLogin
{
    if (![self isInternetReachable]) {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
        return;
    }
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
-(void)yahooLogin
{
    if (![self isInternetReachable]) {
        ALERT(LS(@"MessageBoxTitle"), LS(@"NetworkError"));
        return;
    }
    [self createYahooSession];
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
                 //                 NSString * bod = @"1332043063";
                 NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 email, @"email",
                                                 gender, @"gender",
                                                 name, @"name",
                                                 link, @"link",
                                                 type, @"type",
                                                 //                                                 bod, @"bod",
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
                 
                }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}

#pragma mark - YahooSessionDelegate

- (void)didReceiveAuthorization
{
    [self createYahooSession];
}

#pragma mark - YOSUserRequestDelegate

// Waiting to fetch response
- (void)requestDidFinishLoading:(YOSResponseData *)data
{
    
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSDictionary *json = data.responseJSONDict;
    
    // Profile fetched
    NSDictionary *userProfile = json[@"profile"];
    if (userProfile) {
        NSLog(@"User profile fetched");
//        [self.userProfileViewController loadUserProfile:userProfile];
    }
}

#pragma mark - Public methods

- (void)logout
{
    [self.session clearSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createYahooSession
{
    // Create session with consumer key, secret and application id
    // Set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
    // The default values here won't work
    self.session = [YahooSession sessionWithConsumerKey:@"dj0yJmk9R1N5VUpMb3ZNQm1RJmQ9WVdrOVUybGxTazFsTnpRbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mOA--"
                                      andConsumerSecret:@"081c033eabfed58ddc2afcdf04a96667e66dd355"
                                       andApplicationId:@"SieJMe74"
                                         andCallbackUrl:@"http://mickey.io"
                                            andDelegate:self];
    
    BOOL hasSession = [self.session resumeSession];
    NSLog(@"%i",hasSession);
    
    if(!hasSession) {
        // Not logged-in, send login and authorization pages to user
        [self.session sendUserToAuthorization];
    } else {
        // Logged-in, send requests
        NSLog(@"Session detected!");
//        [self sendUserContactsRequest];
        [self sendUserProfileRequest];
//        [self pushContactListToVC];
        // [self sendASyncYQLRequests];
        // [self sendSyncYQLRequests];
    }
}

- (void)sendUserProfileRequest
{
    // Initialize profile request
    YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
    
    // Fetch user profile
    [userRequest fetchProfileWithDelegate:self];
}

//- (void)sendUserContactsRequest
//{
//    // Initialize contact list request
//    YOSUserRequest *request = [YOSUserRequest requestWithSession:self.session];
//    
//    // Fetch the user's contact list
//    [request fetchContactsWithStart:0 andCount:300 withDelegate:self];
//}

- (void)sendASyncYQLRequests
{
    // Initialize YQL request
    YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];
    
    // Build YQL query string
    NSString *structuredYQLQuery = [NSString stringWithFormat:@"select * from social.profile where guid = me"];
    
    // Fetch YQL response
    [request query:structuredYQLQuery withDelegate:self];
}

//- (void)sendSyncYQLRequests
//{
//    YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];
//    
//    NSString *structuredLocationQuery = [NSString stringWithFormat:@"select * from geo.places where text=\"sfo\""];
//    
//    YOSResponseData *data = [request query:structuredLocationQuery];
//    NSDictionary *json = data.responseJSONDict;
//    NSDictionary *queryData = json[@"query"];
//    NSDictionary *results = queryData[@"results"];
//    
//    NSLog(@"%@", results);
//}
@end
