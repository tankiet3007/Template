//
//  LocationPageViewController.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "LocationTableViewCell.h"
#import "SWRevealViewController.h"
@interface LocationPageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableViewMain;
@property (nonatomic,assign)BOOL isFromLeftMenu;
@end