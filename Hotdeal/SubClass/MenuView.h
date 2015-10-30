//
//  MenuView.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 10/23/15.
//  Copyright © 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RATreeView.h"
#import "RADataObject.h"
#import "RACellTableViewCell.h"
#import "AccountTableViewCell.h"
#import "AppInfoTableViewCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MenuView : UIView<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) id expanded;
@property (strong, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSArray *listCategory;
-(void)initView;
-(void)reloadData;
@end
