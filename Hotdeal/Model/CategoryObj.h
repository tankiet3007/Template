//
//  CategoryObj.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/26/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObj : NSObject
@property (nonatomic, assign)int categoryId;
@property (nonatomic, assign)int  parentId;
@property (nonatomic, assign)int productCount;
@property (nonatomic, strong)NSString * productDetailsLayout;
@property (nonatomic, strong)NSString * name;
@property (nonatomic, strong)NSString * path;
@property (nonatomic, strong)NSString * isGlobalShipping;
@property (nonatomic, strong)NSArray  * listSubCategory;

+(NSMutableArray *)parseCategoryToArrayObj:(NSArray*)categoryList;
@end
