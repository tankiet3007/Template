//
//  AppDelegate.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/23/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HomePageViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SWRevealViewController.h"
#import "LeftMenuViewController.h"
#import "LocationPageViewController.h"
#import "MVYSideMenuController.h"
@interface AppDelegate ()<SWRevealViewControllerDelegate>
@property (strong, nonatomic)UIViewController *masterViewController;
@property (strong, nonatomic)LeftMenuViewController *rearViewController;
@property (strong, nonatomic) SWRevealViewController *viewController;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
//    .responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self getConfigAPI];
    [self getListCategory];
    [self getListLocation];
//    HomePageViewController *aVC = [[HomePageViewController alloc]init];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:aVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = self.navigationController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if ((0)) {
    [self initSlideMenu2];
    }
    else
    {
        [self initLocationPage2];
    }
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)initLocationPage2
{
    _masterViewController = [[LocationPageViewController alloc]init];
    //
    _rearViewController = [[LeftMenuViewController alloc] init];

   
    
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
//    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:_rearViewController];
    
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:_rearViewController
                                                                                    contentViewController:contentNavigationController
                                                                                                  options:options];
//    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
//                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//    mainRevealController.delegate = self;
    
//    self.viewController = mainRevealController;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.window.rootViewController = sideMenuController;
}
-(void)initSlideMenu2
{
    _masterViewController = [[HomePageViewController alloc]init];
    _rearViewController = [[LeftMenuViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
    //    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:_rearViewController];
    
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:_rearViewController
                                                                                    contentViewController:contentNavigationController
                                                                                                  options:options];
    //    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
    //                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    //    mainRevealController.delegate = self;
    
    //    self.viewController = mainRevealController;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.window.rootViewController = sideMenuController;
}
-(void)initLocationPage
{
    _masterViewController = [[LocationPageViewController alloc]init];
    //
    _rearViewController = [[LeftMenuViewController alloc] init];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:_rearViewController];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    mainRevealController.delegate = self;
    
    self.viewController = mainRevealController;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.window.rootViewController = self.viewController;
}
-(void)initSlideMenu
{
    _masterViewController = [[HomePageViewController alloc]init];
    _rearViewController = [[LeftMenuViewController alloc] init];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:_masterViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:_rearViewController];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    mainRevealController.delegate = self;
    self.viewController = mainRevealController;
    self.window.rootViewController = self.viewController;
}
-(void)initNavigationbar:(UIViewController *)controller withTitle: (NSString *)strTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = kBoldsyStemFonSizeRevert(20);
//    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    controller.navigationItem.titleView = label;
    label.text = strTitle;
    [label sizeToFit];
    
    UIImage *image = [UIImage imageNamed:@"bt_back"];
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back addTarget:controller action:@selector(backbtn_click) forControlEvents:UIControlEventTouchUpInside];
    [back setBackgroundImage:image forState:UIControlStateNormal];
    //    [rBtest setBackgroundImage:image forState:UIControlStateHighlighted];
    [back setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    controller.navigationItem.leftBarButtonItem = barItem;
    
}

-(void)initNavigationbarWithImage:(UIViewController *)controller
{
    //    revealController = [self revealViewController];
    //    [revealController panGestureRecognizer];
    //    [revealController tapGestureRecognizer];
    controller.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"logo_hotdealvn.png"]];
    UIImage *image = [UIImage imageNamed:@"bt_menu"];
    UIButton * menu = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [menu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    //openLeftMenu
    [menu addTarget:controller action:@selector(openLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    [menu setBackgroundImage:image forState:UIControlStateNormal];
    [menu setFrame:CGRectMake(0, 0, 30, 30)];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menu];
    controller.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    UIButton *customButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [customButton addTarget:controller action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"tab_search_a"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    UIButton *customButton2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [customButton2 addTarget:controller action:@selector(cart) forControlEvents:UIControlEventTouchUpInside];
    [customButton2 setImage:[UIImage imageNamed:@"icon_cart"] forState:UIControlStateNormal];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc]initWithCustomView:customButton2];
    
    NSArray *myButtonArray = [[NSArray alloc] initWithObjects:rightButton1,rightButton2,nil];
    [controller.navigationItem setRightBarButtonItems:myButtonArray];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
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
}

#pragma mark - Methods

+ (AppDelegate *)sharedDelegate {
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (NSString *) getSignAPI:(int)time withAPIName:(NSString *)apiName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *signString = [NSString stringWithFormat:@"%@%@%@%d%@", apiName, @"ios",kKeyPrivateAPI,time,majorVersion];
    NSString *signAPI = [signString MD5Hash];
    
    //md5($apiName + device + privateKey + ts + ver)
    
    return signAPI;
}

#pragma mark - API

- (void)getConfigAPI {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"apiVersion"];
    [param setObject:kBOGetInfoApp forKey:@"api"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSDictionary *dataGet = [json objectForKey:@"data"];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            if(dataGet) {
                int timeDevice = [[NSDate date] timeIntervalSince1970];
                int timeServer = [[dataGet objectForKey:@""] intValue];
                if(timeServer > 0) {
                    self.distanTimeServer = timeServer - timeDevice;
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self getListCategory];
//                });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

-(void)getListCategory {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + _distanTimeServer;
    NSString *signAPI = [self getSignAPI:currentDate withAPIName:kBOGetListCategory];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetListCategory forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        int status = [[json objectForKey:@"error"] intValue];
        if(status == 0) {
            NSArray *dataGet = [[json objectForKey:@"data"] objectForKey:@"listCategory"];
#if DEBUG
            NSLog(@"%s, dataGet = %@",__PRETTY_FUNCTION__, dataGet);
#endif
            if(dataGet && [dataGet count] > 0) {
                self.listCategory = dataGet;
                NotifPost(@"reloadCategory");
                [self saveKeyListToCache:_listCategory];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

-(void)getListLocation {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    int currentDate = [[NSDate date] timeIntervalSince1970] + _distanTimeServer;
    NSString *signAPI = [self getSignAPI:currentDate withAPIName:kBOGetLocationList];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:majorVersion forKey:@"appVersion"];
    [param setObject:@"ios" forKey:@"device"];
    [param setObject:kBOGetListCategory forKey:@"api"];
    [param setObject:signAPI forKey:@"sig"];
    [param setObject:[NSNumber numberWithInt:currentDate] forKey:@"ts"];
    
    [[AFAppDotNetAPIClient sharedClient] GET:@"rest" parameters:param success:^(NSURLSessionDataTask * task, id json) {
        UA_log(@"%@", json);
        [self writeJsonToFile:json];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

- (void)writeJsonToFile:(id) json
{
    //applications Documents dirctory path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (json)
    {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"location.json"];
        [json writeToFile:filePath atomically:YES];
    }
}
#pragma mark - Cache Data
-(NSArray *)getListCat
{
    if(self.listCategory == nil) {
        [self loadKeyListFromCache];
        if ([self.listCategory count] == 0) {
            [self getListCategory];
        }
        return self.listCategory;
    }
    else
        return self.listCategory;
}
- (void)loadKeyListFromCache {
    if(self.listCategory) {
        self.listCategory = nil;
    }
    NSString *file = [kDocumentDirectory stringByAppendingPathComponent:kListCategoryFromCache];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        self.listCategory = [[NSArray alloc]initWithContentsOfFile:file];//arrayWithContentsOfFile:file] copy];
    } else {
        self.listCategory = [[NSArray alloc] init];//[NSMutableDictionary dictionary];;
    }
}

- (void)saveKeyListToCache:(NSArray *)categoryArray {
    if (categoryArray && [categoryArray count] > 0) {
        
        if (![categoryArray writeToFile:[kDocumentDirectory stringByAppendingPathComponent:kListCategoryFromCache] atomically:YES]) {
#if DEBUG
            //NSLog(@"%s, cannot save forms to cache",__PRETTY_FUNCTION__);
#endif
        }
    }
}
+ (MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideAllHUDsForView:window animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.labelText = title;
    return hud;
}

+ (void)dismissGlobalHUD {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [MBProgressHUD hideHUDForView:window animated:YES];
}
@end
