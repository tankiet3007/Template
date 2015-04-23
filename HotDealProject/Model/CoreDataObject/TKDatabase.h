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
@interface TKDatabase : NSObject
+ (TKDatabase*)sharedInstance;
#pragma mark product 
-(void)addProduct:(ProductObject *)pObject;
-(NSMutableArray *)getAllProductStored;
-(void)removeProduct:(NSString *)strProductID;
-(void)resetProduct;
@end
