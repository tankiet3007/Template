//
//  SildeViewController.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 7/28/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "SildeViewController.h"

@interface SildeViewController ()

@end

@implementation SildeViewController
{
    UILabel * titleCount;
    UIButton * closeBtn;
}
@synthesize imageSlideTop, arrImages;
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self hideTabBar:self.tabBarController];  
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
     imageSlideTop = [[ImageSlide alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageSlideTop.galleryImages = arrImages;
    imageSlideTop.isHiddenPageControl = YES;
    imageSlideTop.delegate = self;
    //    [imageSlideTop initScrollLocal2];
    [imageSlideTop initScrollFullscreen];
    [self.view addSubview:imageSlideTop];
    [self.tabBarController.tabBar setHidden:YES];
    
    titleCount = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 10, ScreenWidth, 60)];
    titleCount.text = F(@"1/%lu", (unsigned long)[arrImages count]);
    [titleCount setTextColor:[UIColor whiteColor]];
    titleCount.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:titleCount];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setFrame:CGRectMake(ScreenWidth - 60, 0, 60, 60)];
    [closeBtn addTarget:self action:@selector(closeA) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    
}
-(void)setCurrentImage:(long)index
{
    titleCount.text = F(@"%lu/%lu",index, (unsigned long)[arrImages count]);
}
-(void)closeA
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
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

@end
