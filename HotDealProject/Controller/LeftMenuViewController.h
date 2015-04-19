//
//  LeftMenuViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/9/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APLSectionHeaderView.h"
@interface LeftMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,SectionHeaderViewDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSMutableArray * arrMenu;
@property (nonatomic, strong) UITableView * tableView;
@property (strong, nonatomic) UISearchBar *searchBars;
@end
