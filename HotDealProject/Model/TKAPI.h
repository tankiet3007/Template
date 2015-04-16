//
//  TKAPI.h
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/16/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKAPI : NSObject
+ (TKAPI*)sharedInstance;
- (void)postRequestAF:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion;
+ (NSString *)postRequest:(NSDictionary *)params withURL:(NSString *)url;
@end
