//
//  TKDatabase.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "TKDatabase.h"
static NSManagedObjectContext * __context = nil;
@implementation TKDatabase
+ (TKDatabase*)sharedInstance
{
    // 1
    
    static TKDatabase *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
         __context = [NSManagedObjectContext MR_defaultContext];
        _sharedInstance = [[TKDatabase alloc] init];
    });
    return _sharedInstance;
}
#pragma mark product 
-(void)addProduct:(ProductObject *)pObject
{
    ProductItem *productItem = [ProductItem MR_createEntityInContext:__context];
//    NSNumber * numberID = [NSNumber numberWithInt:pObject.productID];
    NSNumber * numberCount = [NSNumber numberWithInt:pObject.iCount];
    NSNumber * numberStandarPrice = [NSNumber numberWithLong:pObject.lStandarPrice];
        NSNumber * numberDiscountPrice = [NSNumber numberWithLong:pObject.lDiscountPrice];
    productItem.dealID = pObject.strDealID;
    productItem.productID = pObject.strProductID;
    productItem.productImage = pObject.strProductImage;
    productItem.title = pObject.strTitle;
    productItem.standarPrice = numberStandarPrice;
    productItem.discountPrice = numberDiscountPrice;
    productItem.icount = numberCount;
    [__context MR_saveToPersistentStoreAndWait];
    NSArray *arrProductItem = [ProductItem MR_findAll];
    UA_log(@"%ld Item", [arrProductItem count]);
}
-(NSMutableArray *)getAllProductStored
{
    NSMutableArray * arrProduct = [[NSMutableArray alloc]init];
    NSArray * arrProductStored = [ProductItem MR_findAll];
    for (ProductItem * pItem in arrProductStored) {
        ProductObject * pObject = [[ProductObject alloc]init];
        pObject.strTitle = pItem.title;
        pObject.strProductImage = pItem.productImage;
        pObject.strProductImage = pItem.productID;
        pObject.iCount = [pItem.icount intValue];
        pObject.lStandarPrice = [pItem.standarPrice intValue];
        pObject.lDiscountPrice = [pItem.discountPrice intValue];
        pObject.strProductID = pItem.productID;
        pObject.strDealID = pItem.dealID;
        [arrProduct addObject:pObject];
    }
    return arrProduct;
}

-(void)removeProduct:(NSString *)strProductID
{
    NSArray *arrProduct = [ProductItem MR_findByAttribute:@"productID" withValue:strProductID inContext:__context];
    if ([arrProduct count]==0) {
        return;
    }
    ProductItem *vResult = [arrProduct objectAtIndex:0];
    [vResult MR_deleteEntityInContext:__context];
    
    [__context MR_saveToPersistentStoreAndWait];
}

-(void)resetProduct
{
    NSArray *arr = [ProductItem MR_findAll];
    [__context MR_deleteObjects:arr];
    [__context MR_saveToPersistentStoreAndWait];
}
@end
