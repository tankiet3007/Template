//
//  UserAmountViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/7/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "UserAmountViewController.h"
#import "AppDelegate.h"
@interface UserAmountViewController ()

@end

@implementation UserAmountViewController
@synthesize lblUserAmount,lblUserRecieve,lblUserUsed,vContain;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    vContain.layer.borderWidth = 0.5;
    vContain.layer.borderColor =[UIColor lightGrayColor].CGColor;
    [self initData];
    [self initNavigationbar];
    // Do any additional setup after loading the view from its nib.
}

-(void)initData
{
    NSString * strUserAmount = F(@"%d", 2000000);
    strUserAmount = [strUserAmount formatStringToDecimal];
    lblUserAmount.text = F(@"%@đ",strUserAmount);
    
    NSString * strUserRecieve = F(@"%d", 1000000);
    strUserRecieve = [strUserRecieve formatStringToDecimal];
    lblUserRecieve.text = F(@"%@đ",strUserRecieve);

    
    NSString * strUserUsed = F(@"%d", 2000000);
    strUserUsed = [strUserUsed formatStringToDecimal];
    lblUserUsed.text = F(@"%@đ",strUserUsed);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backbtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initNavigationbar
{
    AppDelegate * appdelegate = ApplicationDelegate;
    [appdelegate initNavigationbar:self withTitle:@"Email khuyến mãi"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)useAction:(id)sender {
}
@end