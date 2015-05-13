//
//  User.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 5/13/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fullname;
@property (nonatomic, retain) NSString * gender;

@end
