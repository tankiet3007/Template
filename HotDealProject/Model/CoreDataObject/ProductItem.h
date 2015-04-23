//
//  ProductItem.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProductItem : NSManagedObject

@property (nonatomic, retain) NSString * dealID;
@property (nonatomic, retain) NSNumber * discountPrice;
@property (nonatomic, retain) NSNumber * currentQuantity;
@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSString * productImage;
@property (nonatomic, retain) NSNumber * standarPrice;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * maxQuantity;

@end
