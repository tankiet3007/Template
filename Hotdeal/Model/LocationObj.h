//
//  LocationObj.h
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationObj : NSObject
@property (nonatomic, strong) NSString * locationID;
@property (nonatomic, strong) NSString * locationName;
+ (void)saveCustomObject:(LocationObj *)object key:(NSString *)key;
+ (LocationObj *)loadCustomObjectWithKey:(NSString *)key;
@end
