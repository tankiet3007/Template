//
//  PaymentTemplate.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 8/28/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PaymentTemplateDelegate;
@interface PaymentTemplate : UIView<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tablePaymentInfo;
@property (strong, nonatomic) NSMutableArray * arrInfo;
-(void)initUITableView;
-(void)reloadData;

@property id<PaymentTemplateDelegate>delegate;
@end
@protocol PaymentTemplateDelegate <NSObject>
-(void)checkDone;
@end
