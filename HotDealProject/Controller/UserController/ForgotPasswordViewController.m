//
//  ForgotPasswordViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/3/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
{
     MBProgressHUD *HUD;
}
@synthesize tfEmail;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"QUÊN MẬT KHẨU"];
    [self initHUD];
    // Do any additional setup after loading the view from its nib.
}
- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}
-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendEmailToConfirm:(id)sender {
    NSString * email = tfEmail.text;
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    email, @"email",
                                    nil];
    
    
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_FORGOT_PASSWORD completion:^(NSDictionary * dict, NSError *error) {
        [HUD hide:YES];
        if (dict == nil) {
            return;
        }
        BOOL response = [[dict objectForKey:@"response"]boolValue];
        if (response == TRUE) {
//            NSString* user_id = F(@"%@",[dict objectForKey:@"user_id"]);
//            [[TKDatabase sharedInstance]addUser:user_id];
            ALERT(LS(@"MessageBoxTitle"), @"Đăng nhâp thành công");
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
@end
