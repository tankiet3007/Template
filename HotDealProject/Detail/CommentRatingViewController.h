//
//  CommentRatingViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentRatingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView * tableViewComment;
@end