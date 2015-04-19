//
//  MenuItem.h
//  TVAnimationsGestures
//
//  Created by Tran Tan Kiet on 4/12/15.
//  Copyright (c) 2015 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * logo;
@property (nonatomic, strong) NSArray * subItem;
@end
