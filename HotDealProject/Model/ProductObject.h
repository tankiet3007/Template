//
//  ProductObject.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property (nonatomic, strong) NSString * strProductImage;
@property (nonatomic, strong) NSString * strTitle;
@property (nonatomic, assign) int iCurrentQuantity;
@property (nonatomic, assign) int iMaxQuantity;

@property (nonatomic, strong) NSString * strProductID;
@property (nonatomic, strong) NSString * strDealID;
@property (nonatomic,assign)long  lStandarPrice;
@property (nonatomic,assign)long  lDiscountPrice;
@end
