//
//  AccoutViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/20/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccoutViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITableView *tableAccount;

@end
