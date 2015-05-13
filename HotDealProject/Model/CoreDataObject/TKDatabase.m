//
//  TKDatabase.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "TKDatabase.h"
#import "Provine.h"

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
    NSArray *arrProductItem = [ProductItem MR_findAll];
    for (ProductItem * item in arrProductItem) {
        if ([item.productID isEqualToString:pObject.strProductID]) {
            [self updateProduct:pObject];
            return;
        }
    }
    ProductItem *productItem = [ProductItem MR_createEntityInContext:__context];
//    NSNumber * numberID = [NSNumber numberWithInt:pObject.productID];
    NSNumber * numberCurrentQuantity = [NSNumber numberWithInt:pObject.iCurrentQuantity];
    NSNumber * numberMaxQuantity = [NSNumber numberWithInt:pObject.iMaxQuantity];
    NSNumber * numberStandarPrice = [NSNumber numberWithLong:pObject.lStandarPrice];
        NSNumber * numberDiscountPrice = [NSNumber numberWithLong:pObject.lDiscountPrice];
    productItem.dealID = pObject.strDealID;
    productItem.productID = pObject.strProductID;
    productItem.productImage = pObject.strProductImage;
    productItem.title = pObject.strTitle;
    productItem.standarPrice = numberStandarPrice;
    productItem.discountPrice = numberDiscountPrice;
    productItem.currentQuantity = numberCurrentQuantity;
    productItem.maxQuantity = numberMaxQuantity;
    [__context MR_saveToPersistentStoreAndWait];
    
}

-(void)updateProduct:(ProductObject *)pObject
{
    NSArray *arrProduct = [ProductItem MR_findByAttribute:@"productID" withValue:pObject.strProductID inContext:__context];
    if ([arrProduct count]==0) {
        return;
    }
    ProductItem *vResult = [arrProduct objectAtIndex:0];
    int iCurrent = [vResult.currentQuantity intValue];
    iCurrent += pObject.iCurrentQuantity;
    vResult.currentQuantity = [NSNumber numberWithInt:iCurrent];
    
    [__context MR_saveToPersistentStoreAndWait];
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
        pObject.iCurrentQuantity = [pItem.currentQuantity intValue];
        pObject.iMaxQuantity = [pItem.maxQuantity intValue];
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

-(void)addProvine:(NSString *)strName
{
    Provine *provineItem = [Provine MR_createEntityInContext:__context];
    provineItem.provineName = strName;
    [__context MR_saveToPersistentStoreAndWait];
    
}
-(void)removeProvineSelected:(NSString *)strName
{
    NSArray *arrProduct = [ProductItem MR_findByAttribute:@"provineName" withValue:strName inContext:__context];
    if ([arrProduct count]==0) {
        return;
    }
    ProductItem *vResult = [arrProduct objectAtIndex:0];
    [vResult MR_deleteEntityInContext:__context];
    
    [__context MR_saveToPersistentStoreAndWait];
}

-(NSMutableArray *)getAllProvineUserSelected
{
    NSMutableArray * arrProvine = [[NSMutableArray alloc]init];
    NSArray * arrProductStored = [Provine MR_findAll];
    for (Provine * pItem in arrProductStored) {
        NSString * strName = pItem.provineName;
        [arrProvine addObject:strName];
    }
    return arrProvine;
}

-(void)addUser:(NSString *)strEmail wFullname:(NSString *)strFullname wGender:(NSString *)strGender
{
    User * user = [User MR_createEntityInContext:__context];
    user.email = strEmail;
    user.gender = strGender;
    user.fullname = strFullname;
    [__context MR_saveToPersistentStoreAndWait];
}
-(User *)getUserInfo
{
    NSArray *arrUser = [User MR_findAll];
    if ([arrUser count]==0) {
        return nil;
    }
    User *vResult = [arrUser objectAtIndex:0];
    return vResult;
}
-(void)removeUser
{
    NSArray *arrUser = [User MR_findAll];
    if ([arrUser count]==0) {
        return;
    }
    User *vResult = [arrUser objectAtIndex:0];
    [vResult MR_deleteEntityInContext:__context];
    [__context MR_saveToPersistentStoreAndWait];
}
@end
