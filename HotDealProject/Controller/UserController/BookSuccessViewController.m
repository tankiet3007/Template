//
//  BookSuccessViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/5/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "BookSuccessViewController.h"
#import "AppDelegate.h"
@interface BookSuccessViewController ()

@end

@implementation BookSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initNavigationbar];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Thanh toán"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
