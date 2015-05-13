//
//  ChangePasswordViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BBBadgeBarButtonItem.h"
#import "TKDatabase.h"
#import "AppDelegate.h"
@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
{
    BBBadgeBarButtonItem *barButton;
    NSArray * arrProduct;
    MBProgressHUD *HUD;
}
@synthesize tfConfirmPassword,tfNewPassword,tfOldPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    [self initNavigationbar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:tfOldPassword] )
    {
        [tfNewPassword becomeFirstResponder];
        return YES;
    }
    if ([textField isEqual:tfNewPassword] )
    {
        [tfConfirmPassword becomeFirstResponder];
        return YES;
    }
    else
        return [textField resignFirstResponder];
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateTotal
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        int iCurrent = item.iCurrentQuantity;
        iBadge += iCurrent;
    }
    barButton.badgeValue = F(@"%d",iBadge);
}
-(void)shoppingCart
{
    arrProduct = [[TKDatabase sharedInstance]getAllProductStored];
    if ([arrProduct count] == 0) {
        return;
    }
    ShoppingCartController * shopping = [[ShoppingCartController alloc]init];
    shopping.delegate = self;
    [self.navigationController pushViewController:shopping animated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Đổi mật khẩu"];
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // Add your action to your button
    [customButton addTarget:self action:@selector(shoppingCart) forControlEvents:UIControlEventTouchUpInside];
    // Customize your button as you want, with an image if you have a pictogram to display for example
    [customButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
    
    // Then create and add our custom BBBadgeBarButtonItem
    barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:customButton];
    // Set a value for the badge
    
    barButton.badgeOriginX = 25;
    barButton.badgeOriginY = -5;
    
    int iBadge = 0;
    for (ProductObject * item  in arrProduct) {
        iBadge += item.iCurrentQuantity;
    }
    barButton.badgeValue = F(@"%d",iBadge);
    
    //    barButton.badgeValue = F(@"%ld",[arrProduct count]);
    self.navigationItem.rightBarButtonItem = barButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    //    HUD.labelText = LS(@"LoadingData");
    [HUD hide:YES];
}

- (IBAction)changePassClick:(id)sender {
//    UA_log(@"%@\n%@\n%@", tfOldPassword.text,tfNewPassword.text, tfConfirmPassword.text);
    if (![tfConfirmPassword.text isEqualToString:tfNewPassword.text]) {
        ALERT(LS(@"MessageBoxTitle"), LS(@"CheckPasswordAndRetype"));
        return;
    }
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    tfOldPassword.text, @"old_password",
                                     tfNewPassword.text, @"new_password",
                                    nil];
    
    
    [HUD show:YES];
    [[TKAPI sharedInstance]postRequestAF:jsonDictionary withURL:URL_CHANGE_PASSWORD completion:^(NSDictionary * dict, NSError *error) {
        //        [self showMainView:dict wError:error];
        [HUD hide:YES];
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
