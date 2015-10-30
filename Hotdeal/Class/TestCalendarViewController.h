//
//  TestCalendarViewController.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/30/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "NSDate+FSExtension.h"
@interface TestCalendarViewController : UIViewController<FSCalendarDataSource,FSCalendarDelegate>
@end
