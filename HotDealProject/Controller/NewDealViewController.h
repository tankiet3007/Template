//
//  NewDealViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDealViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableViewDeal;

@end
