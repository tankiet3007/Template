//
//  PaymentAndTransferViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/17/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodObject.h"
@interface PaymentAndTransferViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSMutableArray * arrShippingMethod;
@property (nonatomic, strong)NSMutableArray * arrPaymentMethod;
@property (nonatomic, strong)UITableView * tablePaymentInfo;
@end
