//
//  AppDelegate.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKApplicationDelegate.h>
#import <GooglePlus/GooglePlus.h>
@class SWRevealViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) UITabBarController *tabBarController;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)initNavigationbar:(UIViewController *)controller withTitle: (NSString *)strTitle;

@end

