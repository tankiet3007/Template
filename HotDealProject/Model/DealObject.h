//
//  DealObject.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/17/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealObject : NSObject
@property (nonatomic,strong)NSString * strBrandImage;
@property (nonatomic,strong)NSString * strTitle;
@property (nonatomic,strong)NSString * strDescription;
@property (nonatomic,assign)int buy_number;
@property (nonatomic,assign)int product_id;

@property (nonatomic ,assign) BOOL isNew;
@property (nonatomic,assign)long  lStandarPrice;
@property (nonatomic,assign)long  lDiscountPrice;
@property (nonatomic,assign)double  iRate;
@property (nonatomic, assign) int iKind;//1:voucher 2:product 3:travel
@property (nonatomic,strong)NSString * strType;//P or H
@end
