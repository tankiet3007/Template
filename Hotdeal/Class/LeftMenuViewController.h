//
//  LeftMenuViewController.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/26/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "RADataObject.h"
#import "RACellTableViewCell.h"
#import "AccountTableViewCell.h"
#import "AppInfoTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface LeftMenuViewController : UIViewController<RATreeViewDelegate, RATreeViewDataSource>
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *listCategory;
@property (strong, nonatomic) NSIndexPath *indexPathSelected;
@property (strong, nonatomic) UITableView *tableTreeView;

-(void)initView;
-(void)reloadData;
@end
