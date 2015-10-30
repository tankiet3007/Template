//
//  LocationObj.m
//  Hotdeal
//
//  Created by Tran Tan Kiet on 10/27/15.
//  Copyright © 2015 IOS Hotdeal. All rights reserved.
//

#import "LocationObj.h"

@implementation LocationObj
@synthesize locationID,locationName;
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.locationID forKey:@"locationID"];
    [encoder encodeObject:self.locationName forKey:@"locationName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.locationID = [decoder decodeObjectForKey:@"locationID"];
        self.locationName = [decoder decodeObjectForKey:@"locationName"];
    }
    return self;
}

+ (void)saveCustomObject:(LocationObj *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (LocationObj *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    LocationObj *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
@end
