//
//  PromotionViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "PromotionViewController.h"
#import "AppDelegate.h"
@interface PromotionViewController ()

@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"ƯU ĐÃI"];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
