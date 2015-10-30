//
//  SearchViewController.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/29/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView * tableviewSearch;
@property (nonatomic, strong) NSMutableArray * historySearchList;
@property (nonatomic, strong) UITextField * tfSearch;
@property (nonatomic, assign) BOOL isShowHistory;
@end
