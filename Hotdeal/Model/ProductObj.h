//
//  ProductObj.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObj : NSObject

@property(nonatomic)int productId;
@property(nonatomic, strong)NSString *nameProduct;
@property(nonatomic)int listPrice;
@property(nonatomic)int priceProduct;
@property(nonatomic)int stateID;
@property(nonatomic)int maxQty;
@property(nonatomic)int minQty;
@property(nonatomic)int createLocation;
@property(nonatomic, strong)NSString *isShowroom;
@property(nonatomic, strong)NSString *evoucherSelected;
@property(nonatomic)int mainCategory;
@property(nonatomic)int rateValue;
@property(nonatomic)int rateTotal;
@property(nonatomic)int discountValue;
@property(nonatomic, strong)NSString *typeTemplate;
@property(nonatomic, strong)NSString *imageDeal;

@property(nonatomic, strong)NSString *descriptionDeal;
@property(nonatomic, strong)NSString *introduceDeal;
@property(nonatomic, strong)NSString *conditionsDeal;
@property(nonatomic, strong)NSArray *imageSlide;


- (id)initWithData:(NSDictionary *)data;
- (void)setupData:(NSDictionary *)data;
- (void)updateDataForDetail:(NSDictionary *)data;

@end
