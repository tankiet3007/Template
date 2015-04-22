//
//  ProductListViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/22/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableViewDeal;

@end
