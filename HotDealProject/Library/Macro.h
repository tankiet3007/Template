//
//  Macro.h
//  HeoBay
//
//  Created by Tran Tan Kiet on 4/27/14.
//  Copyright (c) 2014 kiettran. All rights reserved.
//
#ifndef HeoBay_Macro_h
#define HeoBay_Macro_h
#define FLAG_EMPTY_PARAMETER 0
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS ([UIScreen mainScreen].scale > 2.9)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y

#define URLIFY(urlString) [NSURL URLWithString:urlString]
#define F(string, args...) [NSString stringWithFormat:string, args]
#define ALERT(title, msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:LS(@"MessageBoxOK") otherButtonTitles:nil] show]

#define ALERT_DELEGATE(title, msg,self) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:LS(@"MessageBoxCancel") otherButtonTitles:LS(@"MessageBoxOK"),nil] show]

#define UA_invalidateTimer(t) [t invalidate]
#define UA_isIPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UA_isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define UA_rgba(r,g,b,a)				[UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UA_rgb(r,g,b)					UA_rgba(r, g, b, 1.0f)

#define UA_log( s, ... ) NSLog( @"<%@:%d, Func: %s> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,__FUNCTION__,  [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define LOG_SELECTOR()  NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

#define GSTATE [M2GlobalState state]


#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define NavBar                              self.navigationController.navigationBar
#define TabBar                              self.tabBarController.tabBar
#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define DATE_COMPONENTS                     NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth
#define TIME_COMPONENTS                     NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
static int pageView = 0;
//xx
#define LS(str) NSLocalizedString(str, nil)
#define LS1(str) [TSLanguageManager localizedString:(str)]
//Saving tabbar 320 x 49 navigationbar 320x44
//
//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//
//// saving an NSString
//[prefs setObject:@"TextToSave" forKey:@"keyToLookupString"];
//
//// saving an NSInteger
//[prefs setInteger:42 forKey:@"integerKey"];
//
//// saving a Double
//[prefs setDouble:3.1415 forKey:@"doubleKey"];
//
//// saving a Float
//[prefs setFloat:1.2345678 forKey:@"floatKey"];
//
//// This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
//[prefs synchronize];
//
//Retrieving
//
//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//
//// getting an NSString
//NSString *myString = [prefs stringForKey:@"keyToLookupString"];
//
//// getting an NSInteger
//NSInteger myInt = [prefs integerForKey:@"integerKey"];
//
//// getting an Float
//float myFloat = [prefs floatForKey:@"floatKey"];

#endif
