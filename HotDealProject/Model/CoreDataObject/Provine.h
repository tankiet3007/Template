//
//  Provine.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/6/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Provine : NSManagedObject

@property (nonatomic, retain) NSString * provineID;
@property (nonatomic, retain) NSString * provineName;
@property (nonatomic, retain) NSString * provineType;

@end
