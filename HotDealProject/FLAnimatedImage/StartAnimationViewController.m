    //
//  StartAnimationViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/20/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import "StartAnimationViewController.h"
#import "Appdelegate.h"
@interface StartAnimationViewController ()
{
    NSTimer * myTimer;
    MBProgressHUD * HUD;
}
@end

@implementation StartAnimationViewController
@synthesize progressView;
-(void)viewDidLoad {
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    int width = 200;
    progressView.frame = CGRectMake((320-width)/2, (480-10)/2 + 20, width, 10);
    progressView.tintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats: YES];
    [self initHUD];
}

- (void)initHUD {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
//    [HUD hide:YES];
    [HUD show:YES];
}

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=3)
    {
        self.progressView.progress = (float)count/3.0f;
    } else
    {
        [myTimer invalidate];
        [HUD hide:YES];
        [self doneUpdatingProductions];
    } 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneUpdatingProductions {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate doneLoading];
}

@end
