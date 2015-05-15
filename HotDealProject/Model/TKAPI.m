//
//  TKAPI.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/16/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "TKAPI.h"

@implementation TKAPI
+ (TKAPI*)sharedInstance
{
    // 1
    static TKAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TKAPI alloc] init];
    });
    return _sharedInstance;
}
+ (NSString *)postRequest:(NSDictionary *)params withURL:(NSString *)url
{
    NSMutableURLRequest *theRequest=[NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:
                                                     url]
                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:30];
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   
    // should check for and handle errors here but we aren't
    [theRequest setHTTPBody:jsonData];
    NSURLResponse *response = nil;
    
    NSData *result = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
    NSString * strData = [[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding];
    UA_log(@"data: %@",strData);
    return strData;
}
- (void)postRequestAF:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager setSecurityPolicy:policy];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
 
    [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSString *strResponeData = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSLog(@"responseObject: %@", strResponeData);
//        NSDictionary* dictionary = (NSDictionary*)responseObject;

        NSDictionary* dictionary = [NSJSONSerialization
                            JSONObjectWithData:responseObject
                            options:kNilOptions
                            error:nil];
        
        if ([dictionary isKindOfClass:[NSDictionary class]] == YES)
        {
            completion(dictionary, nil);
        }
        else
        {
            completion(dictionary, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
        completion(nil, error);
    }];}

- (void)getRequestAF:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager setSecurityPolicy:policy];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [operationManager GET:url
      parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSString *strResponeData = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSLog(@"responseObject: %@", strResponeData);
          //        NSDictionary* dictionary = (NSDictionary*)responseObject;
          
          NSDictionary* dictionary = [NSJSONSerialization
                                      JSONObjectWithData:responseObject
                                      options:kNilOptions
                                      error:nil];
          
          if ([dictionary isKindOfClass:[NSDictionary class]] == YES)
          {
              completion(dictionary, nil);
          }
          else
          {
              completion(dictionary, nil);
          }

         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // handle failure
             completion(nil, error);
         }];
}
@end
