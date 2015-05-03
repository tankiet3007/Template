//
//  HelpViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/3/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (IBAction)callHelpCenter:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableHelp;

@end
