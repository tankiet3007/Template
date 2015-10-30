//
//  AppDelegate.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UINavigationController *navigationController;
@property (nonatomic)int distanTimeServer;
@property (nonatomic, strong)NSArray *listCategory;

+ (AppDelegate *)sharedDelegate;
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
+ (void)dismissGlobalHUD;
- (NSString *) getSignAPI:(int)time withAPIName:(NSString *)apiName;
-(NSArray *)getListCat;
-(void)initNavigationbarWithImage:(UIViewController *)controller;
-(void)initNavigationbar:(UIViewController *)controller withTitle: (NSString *)strTitle;
@end

