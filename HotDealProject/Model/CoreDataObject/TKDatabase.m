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
        pObject.iCurrentQuantity = [pItem.currentQuantity intValue];
        pObject.iMaxQuantity = [pItem.maxQuantity intValue];
        pObject.lStandarPrice = [pItem.standarPrice intValue];
        pObject.lDiscountPrice = [pItem.discountPrice intValue];
        pObject.strProductID = pItem.productID;
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

-(void)addUser:(NSString *)user_id
{
    User * user = [User MR_createEntityInContext:__context];
    user.user_id = user_id;
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

-(void)updateState:(NSString *)stateID wStateName:(NSString *)stateName wStateLogictic:(NSString *)stateLogictic
{
    NSArray *arrState = [State MR_findByAttribute:@"stateID" withValue:stateID inContext:__context];
    if ([arrState count]==0) {
        return;
    }
    State *vResult = [arrState objectAtIndex:0];
    vResult.stateID = stateID;
    vResult.stateName = stateName;
    vResult.stateLogictic = stateLogictic;
    [__context MR_saveToPersistentStoreAndWait];
}


-(void)addState:(NSString *)stateID wStateName:(NSString *)stateName wStateLogictic:(NSString *)stateLogictic
{
//    NSArray *arrProductItem = [State MR_findAll];
//    for (State * item in arrProductItem) {
//        if ([item.stateID isEqualToString:stateID]) {
//            [self updateState:stateID wStateName:stateName wStateLogictic:stateLogictic];
//            return;
//        }
//    }
    
    State  * state = [State MR_createEntityInContext:__context];
    state.stateID = stateID;
    state.stateName = stateName;
    state.stateLogictic = stateLogictic;
        [__context MR_saveToPersistentStoreAndWait];
}
-(void)addDistrict:(NSString *)districtID wDistrictName:(NSString *)districtName wDistrictLogictic:(NSString *)districtLogictic wStateID:(NSString *)stateID
{
    
//    NSArray *arrProductItem = [District MR_findAll];
//    for (District * item in arrProductItem) {
//        if ([item.districtID isEqualToString:districtID]) {
//            [self updateDictrict:districtID wDistrictName:districtName wDistrictLogictic:districtLogictic wStateID:stateID];
//            return;
//        }
//    }

    
    District * district = [District MR_createEntityInContext:__context];
    district.districtID = districtID;
    district.districtName = districtName;
    district.districtLogictic = districtLogictic;
    district.stateID = stateID;
        [__context MR_saveToPersistentStoreAndWait];
}

-(void)updateDictrict:(NSString *)districtID wDistrictName:(NSString *)districtName wDistrictLogictic:(NSString *)districtLogictic wStateID:(NSString *)stateID
{
    NSArray *arrState = [District MR_findByAttribute:@"districtID" withValue:districtID inContext:__context];
    if ([arrState count]==0) {
        return;
    }
    District *vResult = [arrState objectAtIndex:0];
    vResult.districtID = districtID;
    vResult.districtName = districtName;
    vResult.districtLogictic = districtLogictic;
    vResult.stateID = stateID;
        [__context MR_saveToPersistentStoreAndWait];
}


-(void)addWard:(NSString *)wardID wWardName:(NSString *)wardName wDistrictID:(NSString *)districtID
{
//    NSArray *arrWard = [Ward MR_findAll];
//    for (Ward * item in arrWard) {
//        if ([item.wardID isEqualToString:wardID]) {
//            [self updateWar:wardID wWardName:wardName wDistrictID:districtID];
//            return;
//        }
//    }
    
    Ward * ward = [Ward MR_createEntityInContext:__context];
    ward.wardID = wardID;
    ward.wardName = wardName;
    ward.dicstreetID = districtID;
        [__context MR_saveToPersistentStoreAndWait];
}

-(void)updateWar:(NSString *)wardID wWardName:(NSString *)wardName wDistrictID:(NSString *)districtID
{
    NSArray *arrWar = [Ward MR_findByAttribute:@"wardID" withValue:wardID inContext:__context];
    if ([arrWar count]==0) {
        return;
    }
    Ward *vResult = [arrWar objectAtIndex:0];
    vResult.wardID = wardID;
    vResult.wardName = wardName;
    vResult.dicstreetID = districtID;
        [__context MR_saveToPersistentStoreAndWait];
}


-(NSArray *)getAllState
{
    NSArray * arrState = [State MR_findAllSortedBy:@"stateName" ascending:YES];
    UA_log(@"%lu", (unsigned long)[arrState count]);
    return arrState;
}
-(NSArray *)getAllDistrict
{
    NSArray * arrDictrict = [District MR_findAllSortedBy:@"districtName" ascending:YES];
    UA_log(@"%lu", (unsigned long)[arrDictrict count]);
    return arrDictrict;
}
-(NSArray *)getAllWard
{
    NSArray * arrWard = [Ward MR_findAll];
    UA_log(@"%lu", (unsigned long)[arrWard count]);
    return arrWard;
}
-(NSArray *)getDictrictByStateID:(NSString *)stateID
{
//    NSArray *arrDictrict = [District MR_findByAttribute:@"stateID" withValue:stateID inContext:__context];
    NSArray * arrDistrict = [District MR_findByAttribute:@"stateID" withValue:stateID andOrderBy:@"districtName" ascending:YES inContext:__context];
    for (District * item in arrDistrict) {
        UA_log(@"%@ \n", item.districtName);
    }
    return arrDistrict;
}
-(NSArray *)getWarByDistrictID:(NSString *)districtID
{
    
//    NSArray *arrWar = [Ward MR_findByAttribute:@"dicstreetID" withValue:districtID inContext:__context];
    NSArray * arrWar = [Ward MR_findByAttribute:@"dicstreetID" withValue:districtID andOrderBy:@"wardName" ascending:YES inContext:__context];
    
    for (Ward * item in arrWar) {
        UA_log(@"%@ \n", item.wardName);
    }
    return arrWar;
}

-(Ward *)getWarByID:(NSString *)wardID
{
    NSArray *arrWard = [Ward MR_findByAttribute:@"wardID" withValue:wardID inContext:__context];
    if ([arrWard count]==0) {
        return nil;
    }
    Ward *vResult = [arrWard objectAtIndex:0];
    return vResult;
}
-(State *)getStateByID:(NSString *)stateID
{
    NSArray *arrState = [State MR_findByAttribute:@"stateID" withValue:stateID inContext:__context];
    if ([arrState count]==0) {
        return nil;
    }
    State *vResult = [arrState objectAtIndex:0];
    return vResult;
}

-(District *)getDistrictByID:(NSString *)districtID
{
    NSArray *arrDistrict = [District MR_findByAttribute:@"districtID" withValue:districtID inContext:__context];
    if ([arrDistrict count]==0) {
        return nil;
    }
    District *vResult = [arrDistrict objectAtIndex:0];
    return vResult;

}
@end
