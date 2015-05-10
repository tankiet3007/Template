//
//  SearchViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/19/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
@property(nonatomic,strong)UITableView * tableViewSearch;
@property (strong, nonatomic) UISearchBar *searchBars;
@property (strong, nonatomic) NSString *searchText;
@end
