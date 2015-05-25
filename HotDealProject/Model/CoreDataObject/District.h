//
//  District.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface District : NSManagedObject

@property (nonatomic, retain) NSString * stateID;
@property (nonatomic, retain) NSString * districtID;
@property (nonatomic, retain) NSString * districtName;
@property (nonatomic, retain) NSString * districtLogictic;

@end
