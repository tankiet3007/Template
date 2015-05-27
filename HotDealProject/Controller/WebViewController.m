//
//  WebViewController.m
//  FelixV1
//
//  Created by MAC on 11/13/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
@interface WebViewController ()

@end
@implementation WebViewController

@synthesize webView,url;
@synthesize sTitle, strContent;
- (void)viewDidLoad {
    [super viewDidLoad];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self initNavigationbar:sTitle];
    
    if (url != nil) {
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    else
    {
        NSString *htmlString =
        [NSString stringWithFormat:@"<font face='GothamRounded-Bold' size='6'>%@", strContent];
        [webView loadHTMLString:htmlString baseURL:nil];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backbtn_click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)webView:(UIWebView *)webView2
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webViews
{

    NSString *pageTitle = [webViews stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (pageTitle != nil && ![pageTitle isEqualToString:@""]) {
        [self initNavigationbar:pageTitle];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [HUD hide:YES];
    // Show error alert
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not load page", nil)
//                                                    message:error.localizedDescription
//                                                   delegate:self
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//    [alert show];
}

-(void)initNavigationbar:(NSString *)pageTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = pageTitle;
    [label sizeToFit];
    
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:self action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    self.navigationItem.leftBarButtonItem = barItem;
}


-(void)playVideoWithLink:(NSString *)urlLink
{
    NSString *str_url = [urlLink trim];
    if (str_url == 0 || [str_url isEqualToString:@""]) {
        ALERT(LS(@"MessageBoxTitle"), @"Dữ liệu chương trình sẽ được cập nhật trong thời gian sớm nhất");
        return;
    }
    NSURL *urlP = [NSURL URLWithString:
                  str_url];
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:urlP] ;
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    // Set the modal transition style of your choice
    playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Present the movie player view controller
    [self.navigationController presentMoviePlayerViewControllerAnimated:playerVC];
    
    // Start playback
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer play];
    
}


- (void) movieFinishedCallback:(NSNotification*)notification {
    
    [[UIDevice currentDevice] setValue:
     [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                forKey:@"orientation"];
    
    MPMoviePlayerController *moviePlayer = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    [self dismissViewControllerAnimated:NO completion:^{
        
        [[UIDevice currentDevice] setValue:
         [NSNumber numberWithInteger: UIInterfaceOrientationPortrait]
                                    forKey:@"orientation"];
        
    }];
}

@end
