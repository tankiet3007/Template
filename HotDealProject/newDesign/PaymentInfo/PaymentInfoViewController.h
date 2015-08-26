//
//  PaymentInfoViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/17/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray * arrPaymentInfo;
@property (nonatomic, strong)UITableView * tablePaymentInfo;
@end
