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
@synthesize tfEmail;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"QUÊN MẬT KHẨU"];
    
    // Do any additional setup after loading the view from its nib.
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
}
@end