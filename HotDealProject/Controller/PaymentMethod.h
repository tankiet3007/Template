//
//  PaymentMethod.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 6/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodObject.h"
@protocol PaymentMethodDelegate;
@interface PaymentMethod : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    id<PaymentMethodDelegate> delegate;
}
@property id<PaymentMethodDelegate>delegate;
@property (nonatomic, strong) UITableView * tablePayment;
@end
@protocol PaymentMethodDelegate <NSObject>
-(void)updatePaymentMethod:(MethodObject *)methodObject;
@end