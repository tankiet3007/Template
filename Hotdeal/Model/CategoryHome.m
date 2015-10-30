//
//  CategoryHome.m
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "CategoryHome.h"
#import "ProductObj.h"

@implementation CategoryHome

- (id)initWithData:(NSDictionary *)data {
    self = [super init];
    if(self) {
        [self setupData:data];
    }
    return self;
}

- (void)setupData:(NSDictionary *)data {
    self.categoryID = [[data objectForKey:@"categoryId"] intValue];
    self.parentID = [[data objectForKey:@"parentId"] intValue];
    self.productCount = [[data objectForKey:@"productCount"] intValue];
    self.productDetailsLayout = [data objectForKey:@"productDetailsLayout"];
    self.nameCategory = SetStringFromDataServer([data objectForKey:@"name"]);
    self.pathSortLink = SetStringFromDataServer([data objectForKey:@"path"]);
    self.menuIndex = [[data objectForKey:@"menuPosition"] intValue];
    self.startScroll = 0.0;
    self.listProduct = [[NSMutableArray alloc] init];
    NSArray * subList = [data objectForKey:@"listProduct"];
    for (NSDictionary * subItem in subList) {
        ProductObj * obj = [[ProductObj alloc] initWithData:subItem];
        [_listProduct addObject:obj];
    }
}

@end
