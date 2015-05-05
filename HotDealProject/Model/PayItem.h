//
//  PayItem.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/5/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayItem : NSObject
@property (nonatomic,strong)NSString * strID;
@property (nonatomic,strong)NSString * strBookDate;
@property (nonatomic,strong)NSString * strStatus;
@property (nonatomic,assign)long lTotalPrice;
@end
