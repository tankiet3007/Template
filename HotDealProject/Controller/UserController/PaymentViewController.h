//
//  PaymentViewController.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentMethod.h"
#import "ShippingMethod.h"
#import "MethodObject.h"
@interface PaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, PaymentMethodDelegate, ShippingMethodDelegate>
@property (nonatomic, strong) UITableView * tablePayment;
@property (nonatomic, strong) NSMutableArray * arrProduct;
@end
