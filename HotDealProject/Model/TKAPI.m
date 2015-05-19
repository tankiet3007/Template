//
//  TKAPI.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/16/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "TKAPI.h"
#define TIMEOUT 10
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
    [operationManager.requestSerializer setTimeoutInterval:TIMEOUT];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSString *strResponeData = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //         NSLog(@"responseObject: %@", strResponeData);
        //        NSDictionary* dictionary = (NSDictionary*)responseObject;
        if (responseObject == nil) {
            completion(nil, nil);
            return;
        }
        else
        {
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
        [operationManager.requestSerializer setTimeoutInterval:TIMEOUT];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [operationManager GET:url
               parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (responseObject == nil) {
                       completion(nil, nil);
                       return;
                   }
                   else
                   {
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
                   
               }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      // handle failure
                      completion(nil, error);
                  }];
}

- (void)getRequestAFarr:(NSDictionary *)params withURL:(NSString *)url completion:(void(^)(NSArray*, NSError*))completion
{
    AFSecurityPolicy *policy = [[AFSecurityPolicy alloc] init];
    [policy setAllowInvalidCertificates:YES];
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    [operationManager setSecurityPolicy:policy];
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [operationManager.requestSerializer setTimeoutInterval:TIMEOUT];
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [operationManager GET:url
               parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   if (responseObject == nil) {
                       completion(nil, nil);
                       return;
                   }
                   else
                   {
                       NSArray* arr = [NSJSONSerialization
                                       JSONObjectWithData:responseObject
                                       options:kNilOptions
                                       error:nil];
                       
                       if ([arr isKindOfClass:[NSArray class]] == YES)
                       {
                           completion(arr, nil);
                       }
                       else
                       {
                           completion(arr, nil);
                       }
                   }
               }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      // handle failure
                      completion(nil, error);
                  }];
}


- (void)getRequest:(NSString *)params withURL:(NSString *)url completion:(void(^)(NSDictionary*, NSError*))completion
{
    dispatch_queue_t queue = dispatch_queue_create("com.get", 0);
    dispatch_async(queue, ^{
        NSString *paramString = F(@"%@?%@", url, params);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:paramString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        
        [request setHTTPMethod: @"GET"];
        
        NSError *requestError;
        NSURLResponse *urlResponse = nil;
        
        
        NSData *response1 = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
        if (response1 == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, nil);
            });
        }
        else
        {
            NSDictionary* dictionary = [NSJSONSerialization
                                        JSONObjectWithData:response1
                                        options:kNilOptions
                                        error:nil];
            
            if ([dictionary isKindOfClass:[NSDictionary class]] == YES)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(dictionary, nil);
                });
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(dictionary, nil);
                });
                
            }
        }
        //    UA_log(@"data: %@",strData);
    });
    
}
@end
