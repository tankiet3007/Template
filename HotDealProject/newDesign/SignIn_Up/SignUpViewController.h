//
//  SignUpViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/19/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingTableView.h"
@interface SignUpViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)  TPKeyboardAvoidingTableView *tableView;

@end
