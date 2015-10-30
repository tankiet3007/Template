//
//  ProductObj.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "ProductObj.h"

@implementation ProductObj

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if(self) {
        [self setupData:data];
    }
    return self;
}

- (void)setupData:(NSDictionary *)data {
    self.productId = [[data objectForKey:@"productId"] intValue];
    self.nameProduct = SetStringFromDataServer([data objectForKey:@"name"]);
    self.listPrice = [[data objectForKey:@"listPrice"] intValue];
    self.priceProduct = [[data objectForKey:@"price"] intValue];
    self.stateID = [[data objectForKey:@"stateId"] intValue];
    self.maxQty = [[data objectForKey:@"maxQty"] intValue];
    self.minQty = [[data objectForKey:@"minQty"] intValue];
    self.createLocation = [[data objectForKey:@"createLocation"] intValue];
    self.isShowroom = SetStringFromDataServer([data objectForKey:@"isShowroom"]);
    self.evoucherSelected = SetStringFromDataServer([data objectForKey:@"evoucherSelected"]);
    self.mainCategory = [[data objectForKey:@"mainCategory"] intValue];
    self.rateValue = [[data objectForKey:@"rateVal"] intValue];
    self.rateTotal = [[data objectForKey:@"rateTotal"] intValue];
    self.discountValue = [[data objectForKey:@"discountValue"] intValue];
    self.typeTemplate = SetStringFromDataServer([data objectForKey:@"template"]);
    self.imageDeal = SetStringFromDataServer([data objectForKey:@"image"]);
}

- (void)updateDataForDetail:(NSDictionary *)data {
    self.nameProduct = SetStringFromDataServer([data objectForKey:@"name"]);
    self.listPrice = [[data objectForKey:@"listPrice"] intValue];
    self.priceProduct = [[data objectForKey:@"price"] intValue];
    self.maxQty = [[data objectForKey:@"maxQty"] intValue];
    self.minQty = [[data objectForKey:@"minQty"] intValue];
    self.rateValue = [[data objectForKey:@"rateVal"] intValue];
    self.rateTotal = [[data objectForKey:@"rateTotal"] intValue];
    self.discountValue = [[data objectForKey:@"discountValue"] intValue];
    self.descriptionDeal = SetStringFromDataServer([data objectForKey:@"description"]);
    self.introduceDeal = SetStringFromDataServer([data objectForKey:@"introduce"]);
    self.conditionsDeal = SetStringFromDataServer([data objectForKey:@"conditions"]);
    self.imageSlide = [[NSArray alloc]initWithArray:[data objectForKey:@"imageSlides"]];
}

@end
