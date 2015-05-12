//
//  WebViewController.h
//  FelixV1
//
//  Created by MAC on 11/13/14.
//  Copyright (c) 2014 Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WebViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) NSString* sTitle;

@property (nonatomic, strong) NSString * strContent;
@property (nonatomic, assign) int iOption;
@end
