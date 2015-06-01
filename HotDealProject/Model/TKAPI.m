//
//  TKAPI.m
//  HotDealProject
//
//  Created by Tran Tan Kiet on 4/16/15.
//  Copyright (c) 2015 Tran Tan Kiet. All rights reserved.
//

#import "TKAPI.h"
#define TIMEOUT 15
@implementation TKAPI
static NSDictionary * dictAddress;
static NSArray * arrState;
static NSArray * arrWar;
static NSArray * arrDistrict;
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
    operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [operationManager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [operationManager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject == nil) {
            completion(nil, nil);
            return;
        }
        else
        {
            NSDictionary* dictionary = responseObject;
            
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

- (void)getRequestLocation:(NSString *)params withURL:(NSString *)url
{
    if ([self checkFileExist] == TRUE) {
        return;
    }
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
        [self writeTofile:response1];
    });
    
}

-(void)writeTofile:(NSData*)dataReponse
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"location.json"];
    
//    NSString *str = @"hello world";
    [dataReponse writeToFile:filePath atomically:YES];
//    [dataReponse writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}

-(BOOL)checkFileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Get documents directory
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    NSString * filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"location.json"];
    if ([fileManager fileExistsAtPath:filePath]==YES) {
        return TRUE;
    }
    return FALSE;
}
-(NSDictionary *)readFile:(NSString *)filePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:filePath];
    if ([self checkFileExist]== FALSE) {
        return nil;
    }
    NSData *contents = [NSData dataWithContentsOfFile:filePath];
    dictAddress = [NSJSONSerialization
                                JSONObjectWithData:contents
                                options:kNilOptions
                                error:nil];
    return dictAddress;
}
-(NSDictionary *)getAddress
{
    if (dictAddress != nil) {
       return dictAddress;
    }
    dictAddress  = [self readFile:@"location.json"];
//    [self getAllState];
//        [self getAllDistrict];
//    [self getAllwar];
    return dictAddress;
}

-(NSArray *)getAllState
{
    if (arrState != nil) {
        return arrState;
    }
    NSArray * arrStateLocal  = [[self getAddress]objectForKey:@"states"];
    NSMutableArray * arrRaw = [[NSMutableArray alloc]init];
    for (NSDictionary * dictItem in arrStateLocal) {
        State * stateItem = [[State alloc]init];
        stateItem.stateID = [dictItem objectForKey:@"ID_Tinh_Thanh"];
        stateItem.stateName = [dictItem objectForKey:@"Ten_Tinh_Thanh"];
        stateItem.stateLogictic = [dictItem objectForKey:@"logistic_location_id"];
        [arrRaw addObject:stateItem];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stateName"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrState = [arrRaw sortedArrayUsingDescriptors:sortDescriptors];
    return arrState;
}

-(NSArray *)getAllDistrict
{
    if (arrDistrict != nil) {
        return arrDistrict;
    }
    NSArray * arrDistrictLocal  = [[self getAddress]objectForKey:@"districts"];
    NSMutableArray * arrRaw = [[NSMutableArray alloc]init];
    for (NSDictionary * dictItem in arrDistrictLocal) {
        District * districtItem = [[District alloc]init];
        districtItem.stateID = [dictItem objectForKey:@"ID_Tinh_Thanh"];
        districtItem.districtID = [dictItem objectForKey:@"ID_Quan_Huyen"];
        districtItem.districtName = [dictItem objectForKey:@"Ten_Quan_Huyen"];
        districtItem.districtLogictic = [dictItem objectForKey:@"logistic_location_id"];
        [arrRaw addObject:districtItem];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"districtName"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrDistrict = [arrRaw sortedArrayUsingDescriptors:sortDescriptors];
    return arrDistrict;
}

-(NSArray *)getAllwar
{
    if (arrWar != nil) {
        return arrWar;
    }
    NSArray * arrWarLocal  = [[self getAddress]objectForKey:@"wards"];
    NSMutableArray * arrRaw = [[NSMutableArray alloc]init];
    for (NSDictionary * dictItem in arrWarLocal) {
        Ward * wardItem = [[Ward alloc]init];
        wardItem.wardID = [dictItem objectForKey:@"ID_Phuong_Xa"];
        wardItem.wardName = [dictItem objectForKey:@"Ten_Phuong_Xa"];
        wardItem.dicstreetID = [dictItem objectForKey:@"ID_Quan_Huyen"];
        [arrRaw addObject:wardItem];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"wardName"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    arrWar = [arrRaw sortedArrayUsingDescriptors:sortDescriptors];
    return arrWar;

}
@end
