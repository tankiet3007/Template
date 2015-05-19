//
//  AppDelegate.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "AppDelegate.h"
#import "StartupViewController.h"
#import "MainViewController.h"
#import "LeftMenuViewController.h"
#import "SWRevealViewController.h"
#import <MediaPlayer/MediaPlayer.h>
static NSString * const kRecipesStoreName = @"HotDealProject.sqlite";//HotDealProject.sqlite
@interface AppDelegate ()<SWRevealViewControllerDelegate>

@property (strong, nonatomic)UIViewController *masterViewController;

@end

@implementation AppDelegate
{
    LeftMenuViewController *rearViewController;
}


- (NSUInteger)application:(UIApplication*)application
supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    if ([[window.rootViewController presentedViewController] isKindOfClass:        [MPMoviePlayerViewController class]])
    {
        return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupDB];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (/* DISABLES CODE */ (1)) {
        _masterViewController = [[StartupViewController alloc]init];
        //
        rearViewController = [[LeftMenuViewController alloc] init];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                        initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:@"#bd0d18" alpha:1]];
        mainRevealController.delegate = self;
        
        self.viewController = mainRevealController;
        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
        
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
        [self checkNetwork];
        return YES;
    }
    else
    {
        _masterViewController = [[MainViewController alloc]init];
        rearViewController = [[LeftMenuViewController alloc] init];
        
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
        
        SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                        initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
        mainRevealController.delegate = self;
        self.viewController = mainRevealController;
        self.window.rootViewController = self.viewController;
        [self.window makeKeyAndVisible];
        [self checkNetwork];
        return YES;
    }
}

-(void)checkNetwork
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSLog(@"Reachability changed: %@", AFStringFromNetworkReachabilityStatus(status));
        
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                // -- Reachable -- //
                NSLog(@"Reachable");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                // -- Not reachable -- //
                NSLog(@"Not Reachable");
                break;
        }
        
    }];
}
-(void)initNavigationbar:(UIViewController *)controller withTitle: (NSString *)strTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    controller.navigationItem.titleView = label;
    label.text = strTitle;
    [label sizeToFit];
    
    
    UIImage *image = [UIImage imageNamed:@"back_n"];
    UIButton * rBtest = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtest addTarget:controller action:@selector(backbtn_click:) forControlEvents:UIControlEventTouchUpInside];
    [rBtest setBackgroundImage:image forState:UIControlStateNormal];
    image = [UIImage imageNamed:@"back_n"];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [rBtest setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:rBtest];
    controller.navigationItem.leftBarButtonItem = barItem;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation] || [GPPURLHandler handleURL:url
                                                                                        sourceApplication:sourceApplication
                                                                                               annotation:annotation];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Home.HotDealProject" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HotDealProject" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HotDealProject.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void)setupDB
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
}

- (NSString *)dbStore
{
    return kRecipesStoreName;
}

- (void)cleanAndResetupDB
{
    [MagicalRecord cleanUp];
    [self setupDB];
}
@end
