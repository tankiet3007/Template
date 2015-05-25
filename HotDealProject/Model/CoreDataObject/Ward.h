//
//  Ward.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/25/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ward : NSManagedObject

@property (nonatomic, retain) NSString * wardID;
@property (nonatomic, retain) NSString * wardName;
@property (nonatomic, retain) NSString * dicstreetID;

@end
