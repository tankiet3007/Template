//
//  ShippingMethod.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 6/4/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodObject.h"
@protocol ShippingMethodDelegate;
@interface ShippingMethod : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    id<ShippingMethodDelegate> delegate;
}
@property id<ShippingMethodDelegate>delegate;
@property (nonatomic, strong) UITableView * tablePayment;
@end
@protocol ShippingMethodDelegate <NSObject>
-(void)updateShippingMethod:(MethodObject *)methodObject;

@end
