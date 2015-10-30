//
//  CategoryObj.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/26/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "CategoryObj.h"

@implementation CategoryObj
@synthesize categoryId, parentId, productCount, productDetailsLayout, name, path, isGlobalShipping, listSubCategory;
+(NSMutableArray *)parseCategoryToArrayObj:(NSArray*)categoryList
{
    NSMutableArray * resultList = [[NSMutableArray alloc]init];
    for (NSDictionary * item in categoryList) {
        CategoryObj * obj = [CategoryObj new];
        obj.categoryId = [[item objectForKey:@"categoryId"]intValue];
        obj.parentId = [[item objectForKey:@"parentId"]intValue];
        obj.productCount = [[item objectForKey:@"productCount"]intValue];
        obj.productDetailsLayout = [item objectForKey:@"productDetailsLayout"];
        obj.name = [item objectForKey:@"name"];
        obj.path = [item objectForKey:@"path"];
        obj.isGlobalShipping = [item objectForKey:@"isGlobalShipping"];
        NSArray * subList = [item objectForKey:@"listSubCategory"];
        NSMutableArray * subCategoryList = [NSMutableArray new];
        for (NSDictionary * subItem in subList) {
            CategoryObj * obj = [CategoryObj new];
            obj.categoryId = [[subItem objectForKey:@"categoryId"]intValue];
            obj.parentId = [[subItem objectForKey:@"parentId"]intValue];
            obj.productCount = [[subItem objectForKey:@"productCount"]intValue];
            obj.productDetailsLayout = [subItem objectForKey:@"productDetailsLayout"];
            obj.name = [subItem objectForKey:@"name"];
            obj.path = [subItem objectForKey:@"path"];
            obj.isGlobalShipping = [subItem objectForKey:@"isGlobalShipping"];
            [subCategoryList addObject:obj];
        }
        obj.listSubCategory = subCategoryList;
        [resultList addObject:obj];
    }
    return  resultList;
}

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if(self) {
        
    }
    return self;
}

@end
