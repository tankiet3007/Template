//
//  CategoryViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+DragLoad.h"
@interface CategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITableViewDragLoadDelegate>
@property (nonatomic,strong) UITableView * tableviewCategory;
@end
