//
//  CategoryHome.h
//  Hotdeal
//
//  Created by IOS Hotdeal on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryHome : NSObject {
}

@property(nonatomic)int categoryID;
@property(nonatomic)int parentID;
@property(nonatomic)int productCount;
@property(nonatomic, strong)NSString *productDetailsLayout;
@property(nonatomic, strong)NSString *nameCategory;
@property(nonatomic, strong)NSString *pathSortLink;
@property(nonatomic)int menuIndex;
@property(nonatomic, strong)NSMutableArray *listProduct;
@property(nonatomic)float startScroll;

- (id)initWithData:(NSDictionary *)data;
- (void)setupData:(NSDictionary *)data;

@end
