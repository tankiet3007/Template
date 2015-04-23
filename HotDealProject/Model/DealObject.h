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
@property (nonatomic,assign)int iCount;
//@property (nonatomic,assign)int iCountSelected;
@property (nonatomic,assign)long  lStandarPrice;
@property (nonatomic,assign)long  lDiscountPrice;
@end
