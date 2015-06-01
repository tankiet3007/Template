//
//  TKDatabase.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/23/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductObject.h"
#import "ProductItem.h"
#import "User.h"
#import "State.h"
#import "District.h"
#import "Ward.h"
@interface TKDatabase : NSObject
+ (TKDatabase*)sharedInstance;
#pragma mark product 
-(void)addProduct:(ProductObject *)pObject;
-(NSMutableArray *)getAllProductStored;
-(void)removeProduct:(NSString *)strProductID;
-(void)resetProduct;

-(void)addProvine:(NSString *)strName;
-(NSMutableArray *)getAllProvineUserSelected;
-(void)removeProvineSelected:(NSString *)strName;

-(void)addUser:(NSString *)user_id;
-(User *)getUserInfo;
-(void)removeUser;

-(NSArray *)getDictrictByStateID:(NSString *)stateID;
-(NSArray *)getWarByDistrictID:(NSString *)districtID;
-(Ward *)getWarByID:(NSString *)wardID;
-(State *)getStateByID:(NSString *)stateID;
-(District *)getDistrictByID:(NSString *)districtID;
@end
