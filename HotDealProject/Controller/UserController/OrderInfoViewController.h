//
//  PaymentDetailViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/7/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayItem.h"
@interface OrderInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tablePaymentDetail;
@property (nonatomic, strong) NSDictionary * pItem;

@end
